module herocmds

import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.web.docusaurus
import freeflowuniverse.herolib.core.playcmds
import freeflowuniverse.herolib.develop.gittools
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

	cmdroot.add_command(cmd_run)
	return cmdroot
}

fn cmd_docusaurus_execute(cmd Command) ! {
	// ---------- FLAGS ----------
	mut open_ := cmd.flags.get_bool('open') or { false }
	mut buildpublish := cmd.flags.get_bool('buildpublish') or { false }
	mut builddevpublish := cmd.flags.get_bool('builddevpublish') or { false }
	mut dev := cmd.flags.get_bool('dev') or { false }
	mut reset := cmd.flags.get_bool('reset') or { false }
	mut update := cmd.flags.get_bool('update') or { false }

	// ---------- PATH LOGIC ----------
	// Resolve the source directory that contains a “cfg” sub‑directory.
	mut path := cmd.flags.get_string('path') or { '' }
	mut url := cmd.flags.get_string('url') or { '' }

	if path == '' && url == '' {
		path = os.getwd()
	}

	docusaurus_path := gittools.path(
		git_url:   url
		path:      path
		git_reset: reset
		git_pull:  update
	)!

	// `docusaurus_path` is a pathlib.Path – we need its string representation
	if os.exists(os.join_path(docusaurus_path.path, 'cfg'))==false {
		return error('Docusaurus configuration directory not found at: ${os.join_path(docusaurus_path.path,
			'cfg')}')
	}

	console.print_header('Running Docusaurus for: ${docusaurus_path.path}')

	// The `playcmds.run` helper expects a string path. Use the underlying
	// filesystem path from the pathlib.Path value.
	playcmds.run(
		heroscript_path: docusaurus_path.path
		reset:           false
	)!

	// // ---------- ACTIONS ----------
	// mut dsite_opt := docusaurus.dsite_add(
	// 	sitename: 'default'
	// 	path:     docusaurus_path.path
	// )!

	// if buildpublish {
	// 	dsite_opt.build()!
	// } else if dev {
	// 	dsite_opt.dev(
	// 		open:          open_
	// 		watch_changes: false
	// 	)!
	// } else {
	// 	// default: just build the static site
	// 	dsite_opt.build()!
	// }
}
