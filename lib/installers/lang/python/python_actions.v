module python

import freeflowuniverse.herolib.osal
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.core
import freeflowuniverse.herolib.installers.base
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.installers.ulist
import os


//////////////////// following actions are not specific to instance of the object

// checks if a certain version or above is installed
fn installed() !bool {
	res := os.execute('python3 --version')
	if res.exit_code != 0 {
		return false
	}

	r := res.output.split_into_lines().filter(it.trim_space().len > 0)
	if r.len != 1 {
		return error("couldn't parse pnpm version.\n${res.output}")
	}

	if texttools.version(r[0].all_after_first('ython')) >= texttools.version(version) {
		return true
	}

	return false
}

// get the Upload List of the files
fn ulist_get() !ulist.UList {
	// optionally build a UList which is all paths which are result of building, is then used e.g. in upload
	return ulist.UList{}
}

// uploads to S3 server if configured
fn upload() ! {
	// installers.upload(
	//     cmdname: 'python'
	//     source: '${gitpath}/target/x86_64-unknown-linux-musl/release/python'
	// )!
}

fn install() ! {
	console.print_header('install python')
	base.install()!

	osal.package_install('python3')!
	pl := core.platform()!
	if pl == .arch {
		osal.package_install('python-pipx,sqlite')!
	} else if pl == .ubuntu {
		osal.package_install('pipx,sqlite')!
	} else if pl == .osx {
		osal.package_install('pipx,sqlite')!
	} else {
		return error('only support osx, arch & ubuntu.')
	}
	osal.execute_silent('pipx install uv')!
}

fn destroy() ! {
	console.print_header('destroy python')
	osal.package_remove('python3')!
	pl := core.platform()!
	if pl == .arch {
		osal.package_remove('pipx,sqlite')!
	} else if pl == .ubuntu {
		osal.package_remove('pipx,sqlite')!
	} else if pl == .osx {
		osal.package_remove('pipx,sqlite')!
	} else {
		return error('only support osx, arch & ubuntu.')
	}
}
