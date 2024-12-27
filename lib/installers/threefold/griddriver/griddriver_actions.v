module griddriver

import freeflowuniverse.herolib.osal
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.develop.gittools
import freeflowuniverse.herolib.installers.ulist
import freeflowuniverse.herolib.installers.lang.golang
import freeflowuniverse.herolib.core.texttools
import os

// checks if a certain version or above is installed
fn installed() !bool {
	res := os.execute('${osal.profile_path_source_and()} griddriver --version')
	if res.exit_code != 0 {
		return false
	}

	r := res.output.split(' ')
	if r.len != 3 {
		return error("couldn't parse griddriver version.\n${res.output}")
	}

	if texttools.version(version) > texttools.version(r[2]) {
		return false
	}

	return true
}

fn install() ! {
	// console.print_header('install griddriver')
	build()!
}

fn build() ! {
	console.print_header('build griddriver')
	mut installer := golang.get()!
	installer.install()!

	mut gs := gittools.get()!
	url := 'https://github.com/threefoldtech/web3gw/tree/development_integration/griddriver'

	mut repo := gs.get_repo(
		url: url
		reset: true
		pull: true
	)!

	mut path := repo.get_path()!
	path = '${path}/griddriver'

	cmd := '/bin/bash -c "cd ${path} && . ${path}/build.sh"'
	res := os.execute(cmd)
	if res.exit_code != 0 {
		return error('failed to build: ${res.output}')
	}

	console.print_header('build griddriver OK')
}

// get the Upload List of the files
fn ulist_get() !ulist.UList {
	// mut installer := get()!
	// optionally build a UList which is all paths which are result of building, is then used e.g. in upload
	return ulist.UList{}
}

// uploads to S3 server if configured
fn upload() ! {
	// mut installer := get()!
	// installers.upload(
	//     cmdname: 'griddriver'
	//     source: '${gitpath}/target/x86_64-unknown-linux-musl/release/griddriver'
	// )!
}

fn destroy() ! {
	// mut installer := get()!
	// cmd:="
	//     systemctl disable griddriver_scheduler.service
	//     systemctl disable griddriver.service
	//     systemctl stop griddriver_scheduler.service
	//     systemctl stop griddriver.service

	//     systemctl list-unit-files | grep griddriver

	//     pkill -9 -f griddriver

	//     ps aux | grep griddriver

	//     "

	// osal.exec(cmd: cmd, stdout:true, debug: false)!
}
