module herocmds

import freeflowuniverse.herolib.web.docusaurus
import os
import cli { Command, Flag }

pub fn cmd_docusaurus(mut cmdroot Command) {
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
		description: 'Path where docusaurus source is.'
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
}

fn cmd_docusaurus_execute(cmd Command) ! {
	mut update := cmd.flags.get_bool('update') or { false }
	mut init := cmd.flags.get_bool('new') or { false }
	mut url := cmd.flags.get_string('url') or { '' }
	mut publish_path := cmd.flags.get_string('publish') or { '' }
	mut deploykey := cmd.flags.get_string('deploykey') or { '' }

	mut path := cmd.flags.get_string('path') or { '' }

	mut buildpublish := cmd.flags.get_bool('buildpublish') or { false }
	mut builddevpublish := cmd.flags.get_bool('builddevpublish') or { false }
	mut dev := cmd.flags.get_bool('dev') or { false }

	// if build== false && build== false && build== false {
	// 	eprintln("specify build, builddev or dev")
	// 	exit(1)
	// }

	mut docs := docusaurus.new(update: update)!
	mut site := docs.get(
			url:          url
			path: 		  path
			update:       update
			publish_path: publish_path
			deploykey:    deploykey
			init:init
	)!

	if publish_path.len > 0 {
		site.build()!
	}

	if buildpublish {
		site.build_publish()!
	}

	if builddevpublish {
		site.build_dev_publish()!
	}

	if dev {
		site.dev()!
	}
}
