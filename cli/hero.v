module main

import os
import cli { Command, Flag }
import freeflowuniverse.herolib.core.herocmds
// import freeflowuniverse.herolib.hero.cmds
// import freeflowuniverse.herolib.hero.publishing
import freeflowuniverse.herolib.installers.base
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.ui
import freeflowuniverse.herolib.osal
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.core.playcmds

fn playcmds_do(path string) ! {
	mut plbook := playbook.new(path: path)!
	playcmds.run(mut plbook, false)!
}

fn do() ! {
	if os.args.len == 2 {
		mypath := os.args[1]
		if mypath.to_lower().ends_with('.hero') {
			// hero was called from a file
			playcmds_do(mypath)!
			return
		}
	}

	mut cmd := Command{
		name:        'hero'
		description: 'Your HERO toolset.'
		version:     '2.0.0'
	}

	cmd.add_flag(Flag{
		flag:        .string
		name:        'url'
		abbrev:      'u'
		global:      true
		description: 'url of playbook'
	})

	// herocmds.cmd_run_add_flags(mut cmd)

	mut toinstall := false
	if !osal.cmd_exists('mc') || !osal.cmd_exists('redis-cli') {
		toinstall = true
	}

	if osal.is_osx() {
		if !osal.cmd_exists('brew') {
			console.clear()
			mut myui := ui.new()!
			toinstall = myui.ask_yesno(
				question: "we didn't find brew installed is it ok to install for you?"
				default:  true
			)!
			if toinstall {
				base.install()!
			}
			console.clear()
			console.print_stderr('Brew installed, please follow instructions and do hero ... again.')
			exit(0)
		}
	} else {
		if toinstall {
			base.install()!
		}
	}

	base.redis_install()!

	// herocmds.cmd_bootstrap(mut cmd)
	// herocmds.cmd_run(mut cmd)
	// herocmds.cmd_git(mut cmd)
	// herocmds.cmd_init(mut cmd)
	// herocmds.cmd_imagedownsize(mut cmd)
	// herocmds.cmd_biztools(mut cmd)
	// herocmds.cmd_gen(mut cmd)
	// herocmds.cmd_sshagent(mut cmd)
	// herocmds.cmd_installers(mut cmd)
	// herocmds.cmd_configure(mut cmd)
	// herocmds.cmd_postgres(mut cmd)
	// herocmds.cmd_mdbook(mut cmd)
	// herocmds.cmd_luadns(mut cmd)
	// herocmds.cmd_caddy(mut cmd)
	// herocmds.cmd_zola(mut cmd)
	// herocmds.cmd_juggler(mut cmd)
	// herocmds.cmd_generator(mut cmd)
	// herocmds.cmd_docsorter(mut cmd)
	// cmd.add_command(publishing.cmd_publisher(pre_func))
	cmd.setup()
	cmd.parse(os.args)
}

fn main() {
	do() or { panic(err) }
}

fn pre_func(cmd Command) ! {
	herocmds.plbook_run(cmd)!
}
