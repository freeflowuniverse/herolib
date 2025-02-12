module zinit_installer

import freeflowuniverse.herolib.osal
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.develop.gittools
import freeflowuniverse.herolib.core
import freeflowuniverse.herolib.osal.systemd
import freeflowuniverse.herolib.osal.zinit as zinit_module
import freeflowuniverse.herolib.installers.ulist
import os

fn startupcmd() ![]zinit_module.ZProcessNewArgs {
	mut res := []zinit_module.ZProcessNewArgs{}
	res << zinit_module.ZProcessNewArgs{
		name:        'zinit'
		cmd:         '/usr/local/bin/zinit init'
		startuptype: .systemd
		start:       true
		restart:     true
	}
	return res
}

fn running() !bool {
	cmd := 'zinit list'
	return osal.execute_ok(cmd)
}

fn start_pre() ! {
}

fn start_post() ! {
}

fn stop_pre() ! {
}

fn stop_post() ! {
}

//////////////////// following actions are not specific to instance of the object

// checks if a certain version or above is installed
fn installed() !bool {
	cmd := 'zinit --version'
	// console.print_debug(cmd)
	res := os.execute(cmd)
	if res.exit_code == 0 {
		r := res.output.split_into_lines().filter(it.trim_space().starts_with('zinit v'))
		if r.len != 1 {
			return error("couldn't parse zinit version.\n${res.output}")
		}
		if texttools.version(version) == texttools.version(r[0].all_after_first('zinit v')) {
			return true
		}
	}
	console.print_debug(res.str())
	return false
}

// get the Upload List of the files
fn ulist_get() !ulist.UList {
	// optionally build a UList which is all paths which are result of building, is then used e.g. in upload
	return ulist.UList{}
}

// uploads to S3 server if configured
fn upload() ! {}

fn install() ! {
	console.print_header('install zinit')
	if !core.is_linux()! {
		return error('only support linux for now')
	}

	release_url := 'https://github.com/threefoldtech/zinit/releases/download/v0.2.14/zinit'

	mut dest := osal.download(
		url:        release_url
		minsize_kb: 2000
		reset:      true
	)!

	osal.cmd_add(
		cmdname: 'zinit'
		source:  dest.path
	)!

	osal.dir_ensure('/etc/zinit')!
	console.print_header('install zinit done')
}

fn build() ! {
	if !core.is_linux()! {
		return error('only support linux for now')
	}

	// rust.install()

	// install zinit if it was already done will return true
	console.print_header('build zinit')

	mut gs := gittools.get(coderoot: '/tmp/builder')!
	mut repo := gs.get_repo(
		url:   'https://github.com/threefoldtech/zinit'
		reset: true
		pull:  true
	)!
	gitpath := repo.path()

	// source ${osal.profile_path()}

	cmd := '
	source ~/.cargo/env
	cd ${gitpath}
	make release
	'
	osal.execute_stdout(cmd)!

	osal.cmd_add(
		cmdname: 'zinit'
		source:  '/tmp/builder/github/threefoldtech/zinit/target/x86_64-unknown-linux-musl/release/zinit'
	)!
}

fn destroy() ! {
	mut systemdfactory := systemd.new()!
	systemdfactory.destroy('zinit') or { return error('Could not destroy zinit due to: ${err}') }

	osal.process_kill_recursive(name: 'zinit') or {
		return error('Could not kill zinit due to: ${err}')
	}
	osal.cmd_delete('zinit')!
}
