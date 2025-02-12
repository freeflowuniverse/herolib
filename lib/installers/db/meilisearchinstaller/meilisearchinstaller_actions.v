module meilisearchinstaller

import freeflowuniverse.herolib.osal
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.osal.systemd
import freeflowuniverse.herolib.osal.zinit
import freeflowuniverse.herolib.installers.ulist
import freeflowuniverse.herolib.installers.lang.golang
import freeflowuniverse.herolib.installers.lang.rust
import freeflowuniverse.herolib.installers.lang.python
import freeflowuniverse.herolib.core.httpconnection
import os

fn startupcmd() ![]zinit.ZProcessNewArgs {
	mut res := []zinit.ZProcessNewArgs{}
	mut installer := get()!
	mut env := 'development'
	if installer.production {
		env = 'production'
	}
	res << zinit.ZProcessNewArgs{
		name: 'meilisearch'
		cmd:  'meilisearch  --no-analytics --http-addr ${installer.host}:${installer.port} --env ${env} --db-path ${installer.path} --master-key ${installer.masterkey}'
	}

	return res
}

fn running() !bool {
	mut meilisearch := get()!
	// THIS IS EXAMPLE CODEAND NEEDS TO BE CHANGED
	// this checks health of meilisearchinstaller
	// curl http://localhost:3333/api/v1/s --oauth2-bearer 1234 works
	url := 'http://${meilisearch.host}:${meilisearch.port}/api/v1'
	mut conn := httpconnection.new(name: 'meilisearchinstaller', url: url)!
	conn.default_header.add(.authorization, 'Bearer ${meilisearch.masterkey}')
	conn.default_header.add(.content_type, 'application/json')

	console.print_debug("curl -X 'GET' '${url}'/version")
	response := conn.get_json_dict(prefix: 'version', debug: false) or { return false }
	println('response: ${response}')
	// if response
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
	// THIS IS EXAMPLE CODEAND NEEDS TO BE CHANGED
	// res := os.execute('${osal.profile_path_source_and()!} meilisearchinstaller version')
	// if res.exit_code != 0 {
	//     return false
	// }
	// r := res.output.split_into_lines().filter(it.trim_space().len > 0)
	// if r.len != 1 {
	//     return error("couldn't parse meilisearchinstaller version.\n${res.output}")
	// }
	// if texttools.version(version) == texttools.version(r[0]) {
	//     return true
	// }
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
	//     cmdname: 'meilisearchinstaller'
	//     source: '${gitpath}/target/x86_64-unknown-linux-musl/release/meilisearchinstaller'
	// )!
}

fn install() ! {
	console.print_header('install meilisearchinstaller')
	// THIS IS EXAMPLE CODEAND NEEDS TO BE CHANGED
	// mut url := ''
	// if core.is_linux_arm() {
	//     url = 'https://github.com/meilisearchinstaller-dev/meilisearchinstaller/releases/download/v${version}/meilisearchinstaller_${version}_linux_arm64.tar.gz'
	// } else if core.is_linux_intel() {
	//     url = 'https://github.com/meilisearchinstaller-dev/meilisearchinstaller/releases/download/v${version}/meilisearchinstaller_${version}_linux_amd64.tar.gz'
	// } else if core.is_osx_arm() {
	//     url = 'https://github.com/meilisearchinstaller-dev/meilisearchinstaller/releases/download/v${version}/meilisearchinstaller_${version}_darwin_arm64.tar.gz'
	// } else if osal.is_osx_intel() {
	//     url = 'https://github.com/meilisearchinstaller-dev/meilisearchinstaller/releases/download/v${version}/meilisearchinstaller_${version}_darwin_amd64.tar.gz'
	// } else {
	//     return error('unsported platform')
	// }

	// mut dest := osal.download(
	//     url: url
	//     minsize_kb: 9000
	//     expand_dir: '/tmp/meilisearchinstaller'
	// )!

	// //dest.moveup_single_subdir()!

	// mut binpath := dest.file_get('meilisearchinstaller')!
	// osal.cmd_add(
	//     cmdname: 'meilisearchinstaller'
	//     source: binpath.path
	// )!
}

fn build() ! {
	// url := 'https://github.com/threefoldtech/meilisearchinstaller'

	// make sure we install base on the node
	// if osal.platform() != .ubuntu {
	//     return error('only support ubuntu for now')
	// }
	// golang.install()!

	// console.print_header('build meilisearchinstaller')

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
	osal.process_kill_recursive(name: 'meilisearch')!
	osal.cmd_delete('meilisearch')!
	osal.package_remove('meilisearch') or { println('') }
}
