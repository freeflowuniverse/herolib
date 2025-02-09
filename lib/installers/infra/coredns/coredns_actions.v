module coredns

import freeflowuniverse.herolib.osal
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.core
import freeflowuniverse.herolib.develop.gittools
import freeflowuniverse.herolib.osal.zinit
import freeflowuniverse.herolib.installers.ulist
import freeflowuniverse.herolib.core.httpconnection
import freeflowuniverse.herolib.installers.lang.golang
import os

fn startupcmd() ![]zinit.ZProcessNewArgs {
	mut args := get()!
	mut res := []zinit.ZProcessNewArgs{}
	cmd := "coredns -conf '${args.config_path}'"
	res << zinit.ZProcessNewArgs{
		name: 'coredns'
		cmd:  cmd
	}
	return res
}

fn running() !bool {
	mut installer := get()!
	mut conn := httpconnection.new(name: 'coredns', url: 'http://localhost:3334')!
	r := conn.get(prefix: 'health')!
	if r.trim_space() == 'OK' {
		return true
	}
	return false
}

fn start_pre() ! {
	fix()!
}

fn start_post() ! {
	set_local_dns()
}

fn stop_pre() ! {
}

fn stop_post() ! {
}

//////////////////// following actions are not specific to instance of the object

// checks if a certain version or above is installed
fn installed() !bool {
	res := os.execute('/bin/bash -c "${osal.profile_path_source_and()!} coredns --version"')
	if res.exit_code != 0 {
		return false
	}
	r := res.output.split_into_lines().filter(it.trim_space().starts_with('CoreDNS-'))
	if r.len != 1 {
		return error("couldn't parse coredns version.\n${res.output}")
	}
	if texttools.version(version) == texttools.version(r[0].all_after_first('CoreDNS-')) {
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
	//     cmdname: 'coredns'
	//     source: '${gitpath}/target/x86_64-unknown-linux-musl/release/coredns'
	// )!
}

fn install() ! {
	console.print_header('install coredns')
	build()! // because we need the plugins
	// mut url := ''
	// if core.is_linux_arm()! {
	//     url = 'https://github.com/coredns/coredns/releases/download/v${version}/coredns_${version}_linux_arm64.tgz'
	// } else if core.is_linux_intel()! {
	//     url = 'https://github.com/coredns/coredns/releases/download/v${version}/coredns_${version}_linux_amd64.tgz'
	// } else if core.is_osx_arm()! {
	//     url = 'https://github.com/coredns/coredns/releases/download/v${version}/coredns_${version}_darwin_arm64.tgz'
	// } else if core.is_osx_intel()! {
	//     url = 'https://github.com/coredns/coredns/releases/download/v${version}/coredns_${version}_darwin_amd64.tgz'
	// } else {
	//     return error('unsported platform')
	// }

	// mut dest := osal.download(
	//     url:        url
	//     minsize_kb: 13000
	//     expand_dir: '/tmp/coredns'
	// )!

	// mut binpath := dest.file_get('coredns')!
	// osal.cmd_add(
	//     cmdname: 'coredns'
	//     source:  binpath.path
	// )!
}

fn build() ! {
	url := 'https://github.com/coredns/coredns'

	if core.platform()! != .ubuntu {
		return error('only support ubuntu for now')
	}
	mut g := golang.get()!
	g.install()!

	console.print_header('build coredns')

	mut gs := gittools.new()!

	gitpath := gs.get_path(
		pull:  true
		reset: true
		url:   url
	)!

	// set the plugins file on right location
	pluginsfile := $tmpl('templates/plugin.cfg')
	mut path := pathlib.get_file(path: '${gitpath}/plugin.cfg', create: true)!
	path.write(pluginsfile)!

	cmd := '
    cd ${gitpath}
    make
    '
	osal.execute_stdout(cmd)!

	// now copy to the default bin path
	mut codedir := pathlib.get_dir(path: '${gitpath}', create: false)!
	mut binpath := codedir.file_get('coredns')!
	osal.cmd_add(
		cmdname: 'coredns'
		source:  binpath.path
	)!
}

fn destroy() ! {
	// mut systemdfactory := systemd.new()!
	// systemdfactory.destroy("zinit")!

	// osal.process_kill_recursive(name:'zinit')!
	// osal.cmd_delete('zinit')!

	// osal.package_remove('
	//    podman
	//    conmon
	//    buildah
	//    skopeo
	//    runc
	// ')!

	// //will remove all paths where go/bin is found
	// osal.profile_path_add_remove(paths2delete:"go/bin")!

	// osal.rm("
	//    podman
	//    conmon
	//    buildah
	//    skopeo
	//    runc
	//    /var/lib/containers
	//    /var/lib/podman
	//    /var/lib/buildah
	//    /tmp/podman
	//    /tmp/conmon
	// ")!
}
