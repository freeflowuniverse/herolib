module s3

import freeflowuniverse.herolib.osal
import freeflowuniverse.herolib.installers.base
import freeflowuniverse.herolib.installers.zinit as zinitinstaller
import freeflowuniverse.herolib.installers.rclone
import freeflowuniverse.herolib.ui.console

// install s3 will return true if it was already installed
pub fn install() ! {
	base.install()!
	zinitinstaller.install()!
	rclone.install()!

	if osal.done_exists('install_s3') {
		return
	}

	build()!

	console.print_header('install s3')

	osal.done_set('install_s3', 'OK')!
}
