module podman

import freeflowuniverse.herolib.osal
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.core
import freeflowuniverse.herolib.installers.ulist
import os

//////////////////// following actions are not specific to instance of the object

// checks if a certain version or above is installed
fn installed() !bool {
	res := os.execute('${osal.profile_path_source_and()!} podman -v')
	if res.exit_code != 0 {
		println(res)
		return false
	}
	r := res.output.split_into_lines().filter(it.trim_space().len > 0)
	if r.len != 1 {
		return error("couldn't parse podman version.\n${res.output}")
	}
	if texttools.version(version) <= texttools.version(r[0].all_after('version')) {
		return true
	}
	return false
}

// get the Upload List of the files
fn ulist_get() !ulist.UList {
	// optionally build a UList which is all paths which are result of building, is then used e.g. in upload
	return ulist.UList{}
}

fn upload() ! {
}

fn install() ! {
	console.print_header('install podman')
	mut url := ''
	if core.is_linux_arm()! || core.is_linux_intel()! {
		osal.package_install('podman,buildah,crun,mmdebstrap')!
		return
	} else if core.is_linux_intel()! {
		url = 'https://github.com/containers/podman/releases/download/v${version}/podman-installer-macos-arm64.pkg'
	} else if core.is_osx_intel()! {
		url = 'https://github.com/containers/podman/releases/download/v${version}/podman-installer-macos-amd64.pkg'
	} else {
		return error('unsported platform')
	}

	mut dest := osal.download(
		url:        url
		minsize_kb: 9000
		expand_dir: '/tmp/podman'
	)!

	// dest.moveup_single_subdir()!

	panic('implement')
}

fn destroy() ! {
	// mut systemdfactory := systemd.new()!
	// systemdfactory.destroy("zinit")!

	// osal.process_kill_recursive(name:'zinit')!
	// osal.cmd_delete('zinit')!

	osal.package_remove('
       podman
       conmon
       buildah
       skopeo
       runc
    ')!

	// //will remove all paths where go/bin is found
	// osal.profile_path_add_remove(paths2delete:"go/bin")!

	osal.rm('
       podman
       conmon
       buildah
       skopeo
       runc
       /var/lib/containers
       /var/lib/podman
       /var/lib/buildah
       /tmp/podman
       /tmp/conmon
    ')!
}
