module screen

import freeflowuniverse.herolib.core
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.installers.ulist
import os

//////////////////// following actions are not specific to instance of the object

// checks if a certain version or above is installed
fn installed() !bool {
	res := os.execute('screen --version')
	if res.exit_code != 0 {
		return false
	}

	return true
}

// get the Upload List of the files
fn ulist_get() !ulist.UList {
	// optionally build a UList which is all paths which are result of building, is then used e.g. in upload
	return ulist.UList{}
}

// uploads to S3 server if configured
fn upload() ! {
}

fn install() ! {
	console.print_header('install screen')

	if core.is_ubuntu()! {
		res := os.execute('sudo apt install screen -y')
		if res.exit_code != 0 {
			return error('failed to install screen: ${res.output}')
		}
	} else if core.is_osx()! {
		res := os.execute('sudo brew install screen')
		if res.exit_code != 0 {
			return error('failed to install screen: ${res.output}')
		}
	} else {
		return error('unsupported platform: ${core.platform()!}')
	}
}

fn destroy() ! {
	console.print_header('uninstall screen')
	if core.is_ubuntu()! {
		res := os.execute('sudo apt remove screen -y')
		if res.exit_code != 0 {
			return error('failed to uninstall screen: ${res.output}')
		}
	} else if core.is_osx()! {
		res := os.execute('sudo brew uninstall screen')
		if res.exit_code != 0 {
			return error('failed to uninstall screen: ${res.output}')
		}
	} else {
		return error('unsupported platform: ${core.platform()!}')
	}
}
