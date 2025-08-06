module herocmds

import freeflowuniverse.herolib.web.docusaurus
import freeflowuniverse.herolib.web.site
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.core.playcmds
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
	mut update := cmd.flags.get_bool('update') or { false }
	mut init := cmd.flags.get_bool('new') or { false }
	mut open := cmd.flags.get_bool('open') or { false }
	mut url := cmd.flags.get_string('url') or { '' }
	mut publish_path := cmd.flags.get_string('publish') or { '' }

	// --- Build Path Logic ---
	mut build_path := cmd.flags.get_string('buildpath') or { '' }
	if build_path == '' {
		// Default build path if not provided (e.g., use CWD or a specific temp dir)
		// Using CWD for now based on previous edits, adjust if needed
		build_path = '${os.home_dir()}/hero/var/docusaurus'
	}

	// --- Start: Heroscript Path Logic ---
	mut provided_path := cmd.flags.get_string('path') or { '' }
	mut heroscript_config_dir := ''

	if provided_path != '' {
		if !os.exists(provided_path) || !os.is_dir(provided_path) {
			return error('Provided path "${provided_path}" does not exist or is not a directory.')
		}

		// Check if the provided path contains a cfg subdirectory (ebook directory structure)
		cfg_subdir := os.join_path(provided_path, 'cfg')
		if os.exists(cfg_subdir) && os.is_dir(cfg_subdir) {
			heroscript_config_dir = cfg_subdir
		} else {
			// Assume the provided path is already the cfg directory
			heroscript_config_dir = provided_path
		}
	} else {
		mut cwd := os.getwd()
		cfg_dir := os.join_path(cwd, 'cfg')
		if !os.exists(cfg_dir) || !os.is_dir(cfg_dir) {
			return error('Flag -path not provided and directory "./cfg" not found in the current working directory.')
		}
		heroscript_config_dir = cfg_dir
	}

	mut buildpublish := cmd.flags.get_bool('buildpublish') or { false }
	mut builddevpublish := cmd.flags.get_bool('builddevpublish') or { false }
	mut dev := cmd.flags.get_bool('dev') or { false }


	// // Get the site configuration that was processed from the heroscript files
	// // The site.play() function processes the heroscript and creates sites in the global websites map
	// // We need to get the site by name from the processed configuration
	// config_actions := plbook.find(filter: 'site.config')!
	// if config_actions.len == 0 {
	// 	return error('No site.config found in heroscript files. Make sure config.heroscript contains !!site.config.')
	// }

	// // Get the site name from the first site.config action
	// site_name := config_actions[0].params.get('name') or {
	// 	return error('site.config must specify a name parameter')
	// }

	// // Get the processed site configuration
	// mut generic_site := site.get(name: site_name)!

	// // Add docusaurus site
	// mut dsite := docusaurus.dsite_add(
	// 	site:            generic_site
	// 	path_src:        url // Use URL as source path for now
	// 	path_build:      build_path
	// 	path_publish:    publish_path
	// 	reset:           false
	// 	template_update: update
	// 	install:         init
	// )!

	// // Conditional site actions based on flags
	// if buildpublish {
	// 	dsite.build_publish()!
	// } else if builddevpublish {
	// 	dsite.build_dev_publish()!
	// } else if dev {
	// 	dsite.dev(host: 'localhost', port: 3000, open: open)!
	// } else if open {
	// 	dsite.open('localhost', 3000)!
	// } else {
	// 	// If no specific action (build/dev/open) is requested, just generate the site
	// 	dsite.generate()!
	// }

	panic("implement")
}
