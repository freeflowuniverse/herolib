module wireguard

import freeflowuniverse.herolib.osal
import freeflowuniverse.herolib.installers.ulist
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.core

//////////////////// following actions are not specific to instance of the object

// checks if a certain version or above is installed
fn installed() !bool {
	osal.execute_silent('wg --version') or { return false }
	return true
}

// get the Upload List of the files
fn ulist_get() !ulist.UList {
	return ulist.UList{}
}

// uploads to S3 server if configured
fn upload() ! {
}

fn install() ! {
	console.print_header('install wireguard')

	cmd := match core.platform()! {
		.ubuntu {
			'sudo apt install -y wireguard'
		}
		.osx {
			'sudo brew install -y wireguard-tools'
		}
		else {
			return error('unsupported platfrom ${core.platform()!}')
		}
	}

	osal.execute_stdout(cmd)!
}

fn destroy() ! {
	console.print_header('uninstall wireguard')

	cmd := match core.platform()! {
		.ubuntu {
			'sudo apt remove -y wireguard wireguard-tools'
		}
		.osx {
			'sudo brew uninstall -y wireguard-tools'
		}
		else {
			return error('unsupported platform ${core.platform()!}')
		}
	}

	osal.execute_stdout(cmd)!
}
