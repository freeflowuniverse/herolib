module griddriver

import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.installers.ulist
import freeflowuniverse.herolib.installers.lang.golang
import freeflowuniverse.herolib.develop.gittools
import os

// checks if a certain version or above is installed
fn installed() !bool {
	res := os.execute("griddriver --version")
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

fn ulist_get() !ulist.UList {
	// optionally build a UList which is all paths which are result of building, is then used e.g. in upload
	return ulist.UList{}
}

// uploads to S3 server if configured
fn upload() ! {}

fn install() ! {
	console.print_header('install griddriver')
	panic("to implement")
	console.print_header('install griddriver OK')
}

fn build() ! {
	console.print_header('build griddriver')
	mut installer := golang.get()!
	installer.install()!

	mut gs := gittools.get()!
	url := 'https://github.com/threefoldtech/web3gw/tree/development_integration/griddriver'

	mut repo := gs.get_repo(
		url:   url
		reset: true
		pull:  true
	)!

	mut path := repo.path()
	path = '${path}/griddriver'

	cmd := '/bin/bash -c "cd ${path} && . ${path}/build.sh"'
	res := os.execute(cmd)
	if res.exit_code != 0 {
		return error('failed to build: ${res.output}')
	}

	console.print_header('build griddriver OK')
}

fn destroy() ! {
	console.print_header('uninstall griddriver')
	mut res := os.execute('sudo rm -rf /usr/local/bin/griddriver')
	if res.exit_code != 0 {
		return error('failed to uninstall griddriver: ${res.output}')
	}

	res = os.execute('sudo rm -rf ~/code/github/threefoldtech/web3gw')
	if res.exit_code != 0 {
		return error('failed to uninstall griddriver: ${res.output}')
	}

	console.print_header('uninstall griddriver OK')
}
