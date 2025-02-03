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
		flag:        .string
		required:    false
		name:        'url'
		abbrev:      'u'
		// default: ''
		description: 'Url where docusaurus source is.'
	})

	cmd_run.add_flag(Flag{
		flag:        .bool
		required:    false
		name:        'build'
		abbrev:      'b'
		description: 'build and publish.'
	})

	cmd_run.add_flag(Flag{
		flag:        .bool
		required:    false
		name:        'builddev'
		abbrev:      'bd'
		description: 'build dev version and publish.'
	})


	cmd_run.add_flag(Flag{
		flag:        .bool
		required:    false
		name:        'dev'
		abbrev:      'd'
		description: 'Run your dev environment on local browser.'
	})

	cmdroot.add_command(cmd_run)
}

fn cmd_docusaurus_execute(cmd Command) ! {
	// mut reset := cmd.flags.get_bool('reset') or { false }
	mut url := cmd.flags.get_string('url') or { '' }
	
	// mut path := cmd.flags.get_string('path') or { '' }
	// if path == '' {
	// 	path = os.getwd()
	// }
	// path = path.replace('~', os.home_dir())

	mut build := cmd.flags.get_bool('build') or { false }
	mut builddev := cmd.flags.get_bool('builddev') or { false }
	mut dev := cmd.flags.get_bool('dev') or { false }

	// if build== false && build== false && build== false {
	// 	eprintln("specify build, builddev or dev")
	// 	exit(1)
	// }


	mut docs := docusaurus.new(
		// build_path: '/tmp/docusaurus_build'
	)!

    if build{
        // Create a new docusaurus site
        _ := docs.build(
            url:url
        )!
    }

    if builddev{
        // Create a new docusaurus site
        _ := docs.build_dev(
            url:url
        )!
    }

    if dev{
        // Create a new docusaurus site
        _ := docs.dev(
            url:url
        )!
    }

}
