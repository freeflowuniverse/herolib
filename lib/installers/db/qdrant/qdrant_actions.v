module qdrant

import freeflowuniverse.herolib.osal
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.core
import freeflowuniverse.herolib.core.texttools
// import freeflowuniverse.herolib.core.pathlib
// import freeflowuniverse.herolib.osal.systemd
import freeflowuniverse.herolib.osal.zinit
import freeflowuniverse.herolib.installers.ulist
// import freeflowuniverse.herolib.installers.lang.golang
// import freeflowuniverse.herolib.installers.lang.rust
// import freeflowuniverse.herolib.installers.lang.python
import freeflowuniverse.herolib.core.httpconnection
import os

fn startupcmd() ![]zinit.ZProcessNewArgs {
	mut res := []zinit.ZProcessNewArgs{}
	res << zinit.ZProcessNewArgs{
		name: 'qdrant'
		cmd:  'qdrant --config-path ${os.home_dir()}/hero/var/qdrant/config.yaml'
	}
	return res
}

fn running() !bool {
	println('running')
	mut installer := get()!
	url := 'curl http://localhost:6333'
	mut conn := httpconnection.new(name: 'qdrant', url: url)!
	r := conn.get(prefix: 'healthz', debug: false) or { return false }
	println(r)
	return false
}

fn start_pre() ! {
}

fn start_post() ! {
}

fn stop_pre() ! {
}

fn stop_post() ! {
}

//////////////////// following actions are not specific to instance of the object

// checks if a certain version or above is installed
fn installed() !bool {
	res := os.execute('${osal.profile_path_source_and()!} qdrant -V')
	if res.exit_code != 0 {
		println('Error to call qdrant: ${res}')
		return false
	}
	r := res.output.split_into_lines().filter(it.contains('qdrant'))
	if r.len != 1 {
		return error("couldn't parse qdrant version.\n${res.output}")
	}
	if texttools.version(version) == texttools.version(r[0].all_after('qdrant')) {
		return true
	}
	return false
}

// get the Upload List of the files
fn ulist_get() !ulist.UList {
	return ulist.UList{}
}

// uploads to S3 server if configured
fn upload() ! {
	// installers.upload(
	//     cmdname: 'qdrant'
	//     source: '${gitpath}/target/x86_64-unknown-linux-musl/release/qdrant'
	// )!
}

fn install() ! {
	console.print_header('install qdrant')
	mut url := ''
	if core.is_linux_arm()! {
		url = 'https://github.com/qdrant/qdrant/releases/download/v${version}/qdrant-aarch64-unknown-linux-musl.tar.gz'
	} else if core.is_linux_intel()! {
		url = 'https://github.com/qdrant/qdrant/releases/download/v${version}/qdrant-x86_64-unknown-linux-musl.tar.gz'
	} else if core.is_osx_arm()! {
		url = 'https://github.com/qdrant/qdrant/releases/download/v${version}/qdrant-aarch64-apple-darwin.tar.gz'
	} else if core.is_osx_intel()! {
		url = 'https://github.com/qdrant/qdrant/releases/download/v${version}/qdrant-x86_64-apple-darwin.tar.gz'
	} else {
		return error('unsported platform')
	}
	mut dest := osal.download(
		url:        url
		minsize_kb: 18000
		expand_dir: '/tmp/qdrant'
	)!

	mut binpath := dest.file_get('qdrant')!
	osal.cmd_add(
		cmdname: 'qdrant'
		source:  binpath.path
	)!
}

fn build() ! {
	// url := 'https://github.com/threefoldtech/qdrant'

	// make sure we install base on the node
	// if osal.platform() != .ubuntu {
	//     return error('only support ubuntu for now')
	// }
	// golang.install()!

	// console.print_header('build qdrant')

	// gitpath := gittools.get_repo(coderoot: '/tmp/builder', url: url, reset: true, pull: true)!

	// cmd := '
	// cd ${gitpath}
	// source ~/.cargo/env
	// exit 1 #todo
	// '
	// osal.execute_stdout(cmd)!
	//
	// //now copy to the default bin path
	// mut binpath := dest.file_get('...')!
	// adds it to path
	// osal.cmd_add(
	//     cmdname: 'griddriver2'
	//     source: binpath.path
	// )!
}

fn destroy() ! {
	osal.process_kill_recursive(name: 'qdrant')!
	osal.cmd_delete('qdrant')!

	osal.package_remove('
	   qdrant
	')!

	osal.rm('
	   qdrant
	   ${os.home_dir()}/hero/var/qdrant
	')!
}
