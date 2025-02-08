module zdb

import freeflowuniverse.herolib.develop.gittools
import freeflowuniverse.herolib.osal
import freeflowuniverse.herolib.installers.base
import freeflowuniverse.herolib.ui.console

// install zdb will return true if it was already installed
pub fn build_() ! {
	base.install()!
	console.print_header('package_install install zdb')
	if !osal.done_exists('install_zdb') && !osal.cmd_exists('zdb') {
		mut gs := gittools.new()!
		mut repo := gs.get_repo(
			url:   'git@github.com:threefoldtech/0-db.git'
			reset: false
			pull:  true
		)!
		path := repo.path()
		cmd := '
		set -ex
		cd ${path}
		make
		sudo rsync -rav ${path}/bin/zdb* /usr/local/bin/
		'
		osal.execute_silent(cmd) or { return error('Cannot install zdb.\n${err}') }
		osal.done_set('install_zdb', 'OK')!
	}
}
