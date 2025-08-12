module herocmds

import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.web.docusaurus
import os
import cli { Command, Flag }
import freeflowuniverse.herolib.core.playbook

pub fn cmd_docusaurus(mut cmdroot Command) Command {
	mut cmd_run := Command{
		name:          'docusaurus'
		description:   'Generate, build, run docusaurus sites.'
		required_args: 0
		execute:       cmd_docusaurus_execute
	}

	cmd_run.add_flag(Flag{
		flag:        .bool
		required:    false
		name:        'reset'
		abbrev:      'r'
		description: 'will reset.'
	})

	cmd_run.add_flag(Flag{
		flag:     .string
		required: false
		name:     'url'
		abbrev:   'u'
		// default: ''
		description: 'Url where docusaurus source is.'
	})

	cmd_run.add_flag(Flag{
		flag:     .string
		required: false
		name:     'path'
		abbrev:   'p'
		// default: ''
		description: 'Path where docusaurus configuration is.'
	})

	// cmd_run.add_flag(Flag{
	// 	flag:     .string
	// 	required: false
	// 	name:     'buildpath'
	// 	abbrev:   'b'
	// 	// default: ''
	// 	description: 'Path where docusaurus build is.'
	// })

	// cmd_run.add_flag(Flag{
	// 	flag:     .string
	// 	required: false
	// 	name:     'deploykey'
	// 	abbrev:   'dk'
	// 	// default: ''
	// 	description: 'Path of SSH Key used to deploy.'
	// })

	// cmd_run.add_flag(Flag{
	// 	flag:     .string
	// 	required: false
	// 	name:     'publish'
	// 	// default: ''
	// 	description: 'Path where to publish.'
	// })

	cmd_run.add_flag(Flag{
		flag:        .bool
		required:    false
		name:        'buildpublish'
		abbrev:      'bp'
		description: 'build and publish.'
	})

	// cmd_run.add_flag(Flag{
	// 	flag:        .bool
	// 	required:    false
	// 	name:        'builddevpublish'
	// 	abbrev:      'bpd'
	// 	description: 'build dev version and publish.'
	// })

	cmd_run.add_flag(Flag{
		flag:        .bool
		required:    false
		name:        'open'
		abbrev:      'o'
		description: 'open the site in browser.'
	})

	cmd_run.add_flag(Flag{
		flag:        .bool
		required:    false
		name:        'update'
		description: 'update your environment the template and the repo you are working on (git pull).'
	})

	cmd_run.add_flag(Flag{
		flag:        .bool
		required:    false
		name:        'dev'
		abbrev:      'd'
		description: 'Run your dev environment on local browser.'
	})

	// cmd_run.add_flag(Flag{
	// 	flag:        .bool
	// 	required:    false
	// 	name:        'new'
	// 	abbrev:      'n'
	// 	description: 'create a new docusaurus site.'
	// })

	cmdroot.add_command(cmd_run)
	return cmdroot
}

fn cmd_docusaurus_execute(cmd Command) ! {
	// ---------- FLAGS ----------
	mut open := cmd.flags.get_bool('open') or { false }
	mut buildpublish := cmd.flags.get_bool('buildpublish') or { false }
	mut builddevpublish := cmd.flags.get_bool('builddevpublish') or { false }
	mut dev := cmd.flags.get_bool('dev') or { false }
	mut reset := cmd.flags.get_bool('reset') or { false }
	// (the earlier duplicate reset flag has been removed)

	// ---------- PATH LOGIC ----------
	// Resolve the source directory that contains a “cfg” sub‑directory.
	mut path := cmd.flags.get_string('path') or { '' }
	mut source_path := ''
	if path != '' {
		// user supplied a path
		if !os.exists(path) || !os.is_dir(path) {
			return error('Provided path "${path}" does not exist or is not a directory.')
		}
		cfg_subdir := os.join_path(path, 'cfg')
		source_path = if os.exists(cfg_subdir) && os.is_dir(cfg_subdir) {
			path
		} else if path.ends_with('cfg') {
			os.dir(path)
		} else {
			return error('Provided path "${path}" does not contain a “cfg” subdirectory.')
		}
	} else {
		// default to current working directory
		cwd := os.getwd()
		cfg_dir := os.join_path(cwd, 'cfg')
		if !os.exists(cfg_dir) || !os.is_dir(cfg_dir) {
			return error('No path supplied and "./cfg" not found in the current directory.')
		}
		source_path = cwd
	}

	console.print_header('Running Docusaurus for: ${source_path}')

	// ---------- BUILD PLAYBOOK ----------
	// Build a PlayBook from the source directory (it contains the HeroScript actions)
	mut plbook := playbook.new(path: source_path)!

	// If the user asked for a CLI‑level reset we inject a temporary define action
	// so that the underlying factory_set receives `reset:true`.
	if reset {
		// prepend a temporary docusaurus.define action (this is safe because the playbook
		// already contains the real definitions, the extra one will just be ignored later)
		mut reset_action := playbook.Action{
			actor:  'docusaurus'
			name:   'define'
			params: {
				'reset': 'true'
			}
			done:   false
		}
		// Insert at the front of the action list
		plbook.actions.prepend(reset_action)
	}

	// ---------- RUN DOCUSUROUS ----------
	// This will:
	//   * read the generic `site.*` definitions,
	//   * create a Docusaurus factory (or reuse an existing one),
	//   * add the site to the factory via `dsite_add`.
	docusaurus.play(mut plbook)!

	// After `play` we should have exactly one site in the global map.
	// Retrieve it – if more than one exists we pick the one whose source path matches.
	mut dsite_opt := docusaurus.dsite_get(plbook.ensure_once(filter: 'site.define')!.params.get('name')!) or {
		// fallback: take the first entry
		if docusaurus_sites.len == 0 {
			return error('No Docusaurus site was created by the playbook.')
		}
		docusaurus_sites.values()[0]!
	}

	// ---------- ACTIONS ----------
	if buildpublish {
		dsite_opt.build_publish()!
	} else if builddevpublish {
		dsite_opt.build()!
	} else if dev {
		dsite_opt.dev(
			open:          open
			watch_changes: false
		)!
	} else {
		// default: just build the static site
		dsite_opt.build()!
	}
}
