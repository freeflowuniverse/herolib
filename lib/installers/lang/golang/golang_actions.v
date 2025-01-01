module golang

import freeflowuniverse.herolib.osal
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.core
import freeflowuniverse.herolib.installers.base
import freeflowuniverse.herolib.installers.ulist
import os

// checks if a certain version or above is installed
fn installed_() !bool {
	res := os.execute('${osal.profile_path_source_and()!} go version')

	if res.exit_code == 0 {
		r := res.output.split_into_lines()
			.filter(it.contains('go version'))

		if r.len != 1 {
			return error("couldn't parse go version, expected 'go version' on 1 row.\n${res.output}")
		}

		mut vstring := r[0] or { panic('bug') }

		vstring = vstring.all_after_first('version').all_after_first('go').all_before(' ').trim_space()
		v := texttools.version(vstring)
		if v >= texttools.version(version) {
			return true
		}
	}
	return false
}

fn install_() ! {
	console.print_header('install golang')
	base.install()!
	// destroy()!

	mut url := ''
	if core.is_linux_arm()! {
		url = 'https://go.dev/dl/go${version}.limux-arm64.tar.gz'
	} else if core.is_linux_intel()! {
		url = 'https://go.dev/dl/go${version}.linux-amd64.tar.gz'
	} else if core.is_osx_arm()! {
		url = 'https://go.dev/dl/go${version}.darwin-arm64.tar.gz'
	} else if core.is_osx_intel()! {
		url = 'https://go.dev/dl/go${version}.darwin-amd64.tar.gz'
	} else {
		return error('unsupported platform')
	}

	expand_dir := '/tmp/golang'

	// the downloader is cool, it will check the download succeeds and also check the minimum size
	dest := osal.download(
		url:        url
		minsize_kb: 40000
		expand_dir: expand_dir
	)!
	go_dest := '${osal.usr_local_path()!}/go'
	println(go_dest)
	os.mv('${expand_dir}/go', go_dest)!
	os.rmdir_all(expand_dir)!
	osal.profile_path_add_remove(paths2add: '${go_dest}/bin')!
}

fn build_() ! {
}

// get the Upload List of the files
fn ulist_get() !ulist.UList {
	// mut installer := get()!
	// optionally build a UList which is all paths which are result of building, is then used e.g. in upload
	return ulist.UList{}
}

fn destroy_() ! {
	console.print_debug('golang destroy')

	osal.package_remove('golang')!

	// will remove all paths where go/bin is found
	osal.profile_path_add_remove(paths2delete: 'go/bin')!

	osal.rm('
        #next will find go as a binary and remove is like cmd delete
        ~/hero/bin/go
        /usr/local/go
        /root/hero/bin/go
        ~/.go
        ~/go
		~/hero/go
		go
    ')!
}
