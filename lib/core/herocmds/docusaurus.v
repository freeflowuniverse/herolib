module herocmds

import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.core.playcmds
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.web.site
import freeflowuniverse.herolib.web.docusaurus
import os
import cli { Command, Flag }

pub fn cmd_docusaurus(mut cmdroot Command) Command {
	mut cmd_run := Command{
		name:          'docusaurus'
		description:   'Generate, build, run docusaurus sites.'
		required_args: 0
		execute:       cmd_docusaurus_execute
	}

	// cmd_run.add_flag(Flag{
	// 	flag:        .bool
	// 	required:    false
	// 	name:        'reset'
	// 	abbrev:      'r'
	// 	description: 'will reset.'
	// })

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

	cmd_run.add_flag(Flag{
		flag:     .string
		required: false
		name:     'buildpath'
		abbrev:   'b'
		// default: ''
		description: 'Path where docusaurus build is.'
	})

	cmd_run.add_flag(Flag{
		flag:     .string
		required: false
		name:     'deploykey'
		abbrev:   'dk'
		// default: ''
		description: 'Path of SSH Key used to deploy.'
	})

	cmd_run.add_flag(Flag{
		flag:     .string
		required: false
		name:     'publish'
		// default: ''
		description: 'Path where to publish.'
	})

	cmd_run.add_flag(Flag{
		flag:        .bool
		required:    false
		name:        'buildpublish'
		abbrev:      'bp'
		description: 'build and publish.'
	})

	cmd_run.add_flag(Flag{
		flag:        .bool
		required:    false
		name:        'builddevpublish'
		abbrev:      'bpd'
		description: 'build dev version and publish.'
	})

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

	cmd_run.add_flag(Flag{
		flag:        .bool
		required:    false
		name:        'new'
		abbrev:      'n'
		description: 'create a new docusaurus site.'
	})

	cmdroot.add_command(cmd_run)
	return cmdroot
}

fn cmd_docusaurus_execute(cmd Command) ! {
	mut open := cmd.flags.get_bool('open') or { false }
	mut buildpublish := cmd.flags.get_bool('buildpublish') or { false }
	mut builddevpublish := cmd.flags.get_bool('builddevpublish') or { false }
	mut dev := cmd.flags.get_bool('dev') or { false }

	// --- Build Path Logic ---
	mut build_path := cmd.flags.get_string('buildpath') or { '' }
	if build_path == '' {
		build_path = '${os.home_dir()}/hero/var/docusaurus'
	}

	// --- Path Logic ---
	mut provided_path := cmd.flags.get_string('path') or { '' }
	mut source_path := ''

	if provided_path != '' {
		if !os.exists(provided_path) || !os.is_dir(provided_path) {
			return error('Provided path "${provided_path}" does not exist or is not a directory.')
		}

		// Check if the provided path contains a cfg subdirectory (ebook directory structure)
		cfg_subdir := os.join_path(provided_path, 'cfg')
		if os.exists(cfg_subdir) && os.is_dir(cfg_subdir) {
			source_path = provided_path
		} else {
			if provided_path.ends_with('cfg') {
				// If path ends with cfg, use parent directory as source
				source_path = os.dir(provided_path)
			} else {
				return error('Provided path "${provided_path}" does not contain a "cfg" subdirectory.')
			}
		}
	} else {
		mut cwd := os.getwd()
		cfg_dir := os.join_path(cwd, 'cfg')
		if !os.exists(cfg_dir) || !os.is_dir(cfg_dir) {
			return error('Flag -path not provided and directory "./cfg" not found in the current working directory.')
		}
		source_path = cwd
	}

	console.print_header('Running Docusaurus for: ${source_path}')

	// Process the site configuration first (excluding global includes)
	mut combined_heroscript := ''
	cfg_path := os.join_path(source_path, 'cfg')
	if os.exists(cfg_path) {
		files := os.ls(cfg_path) or { []string{} }
		for file in files {
			if file.ends_with('.heroscript') {
				file_path := os.join_path(cfg_path, file)
				content := os.read_file(file_path) or { continue }

				// Skip files that contain play.include to avoid global processing
				if content.contains('!!play.include') {
					continue
				}

				combined_heroscript += content + '\n\n'
			}
		}
	}

	if combined_heroscript.len == 0 {
		return error('No valid heroscript files found (all contained global includes)')
	}

	// Process the site configuration to get the site name
	mut plbook := playbook.new(text: combined_heroscript)!
	site.play(mut plbook)!

	// Get the site name from the processed site configuration
	available_sites := site.list()
	if available_sites.len == 0 {
		return error('No sites were created from the configuration')
	}
	site_name := available_sites[0] // Use the first (and likely only) site

	// Set up the docusaurus factory
	docusaurus.factory_set(
		path_build:      build_path
		reset:           true
		install:         true
		template_update: true
	)!

	// Add the docusaurus site
	mut dsite := docusaurus.dsite_add(
		sitename: site_name
		path:     source_path
		play:     false // Site already processed
	)!

	// Execute the requested action directly
	if buildpublish {
		dsite.build_publish()!
	} else if builddevpublish {
		dsite.build()!
	} else if dev {
		dsite.dev(
			open:          open
			watch_changes: true
		)!
	} else {
		dsite.build()!
	}
}
