module buildah

import freeflowuniverse.herolib.osal
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.installers.ulist
import freeflowuniverse.herolib.core

// checks if a certain version or above is installed
fn installed() !bool {
	osal.execute_silent('buildah -v') or { return false }

	return true
}

fn install() ! {
	console.print_header('install buildah')
	if core.platform()! != .ubuntu {
		return error('Only ubuntu is supported for now')
	}

	cmd := 'sudo apt-get -y update && sudo apt-get -y install buildah'
	osal.execute_stdout(cmd)!

	console.print_header('Buildah Installed Successfuly')
}

// get the Upload List of the files
fn ulist_get() !ulist.UList {
	// mut installer := get()!
	// optionally build a UList which is all paths which are result of building, is then used e.g. in upload
	return ulist.UList{}
}

fn destroy() ! {
	osal.execute_stdout('sudo apt remove --purge -y buildah')!
}
