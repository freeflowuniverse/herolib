module gitea

import freeflowuniverse.herolib.osal
import freeflowuniverse.herolib.core
// import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.core.pathlib
// import freeflowuniverse.herolib.osal.systemd
import freeflowuniverse.herolib.installers.base
import freeflowuniverse.herolib.installers.ulist
import freeflowuniverse.herolib.installers.lang.golang
import freeflowuniverse.herolib.installers.lang.rust
import freeflowuniverse.herolib.installers.lang.python
import freeflowuniverse.herolib.installers.db.postgresql as postgresinstaller
import os

// checks if a certain version or above is installed
fn installed() !bool {
	// THIS IS EXAMPLE CODEAND NEEDS TO BE CHANGED
	cfg := get()!
	res := os.execute('/bin/bash -c "gitea --version"')
	if res.exit_code != 0 {
		return false
	}
	r := res.output.split(' ')
	if r.len < 3 {
		return error("couldn't parse gitea version.\n${res.output}")
	}
	if texttools.version(cfg.version) > texttools.version(r[2]) {
		return false
	}
	return false
}

fn install() ! {
	console.print_header('install gitea')

	if core.platform()! != .ubuntu || core.platform()! != .arch {
		return error('only support ubuntu and arch for now')
	}

	if osal.done_exists('gitea_install') {
		console.print_header('gitea binaraies already installed')
		return
	}

	// make sure we install base on the node
	base.install()!
	postgresinstaller.install()!

	cfg := get()!
	version := cfg.version
	url := 'https://github.com/go-gitea/gitea/releases/download/v${version}/gitea-${version}-linux-amd64.xz'
	console.print_debug(' download ${url}')
	mut dest := osal.download(
		url:         url
		minsize_kb:  40000
		reset:       true
		expand_file: '/tmp/download/gitea'
	)!

	binpath := pathlib.get_file(path: dest.path, create: false)!
	osal.cmd_add(
		cmdname: 'gitea'
		source:  binpath.path
	)!

	osal.done_set('gitea_install', 'OK')!

	console.print_header('gitea installed properly.')
}

fn build() ! {
	install()!
}

fn start_pre() ! {
}

fn start_post() ! {
}

fn stop_pre() ! {
}

fn stop_post() ! {
}

fn destroy() ! {
	server := get()!
	server.stop()!

	osal.process_kill_recursive(name: 'gitea')!
	osal.cmd_delete('gitea')!
}

// get the Upload List of the files
fn ulist_get() !ulist.UList {
	// mut installer := get()!
	// optionally build a UList which is all paths which are result of building, is then used e.g. in upload
	return ulist.UList{}
}

// uploads to S3 server if configured
fn upload() ! {
	// mut installer := get()!
	// installers.upload(
	//     cmdname: 'gitea'
	//     source: '${gitpath}/target/x86_64-unknown-linux-musl/release/gitea'
	// )!
}

fn startupcmd() ![]zinit.ZProcessNewArgs {
	mut res := []zinit.ZProcessNewArgs{}
	// THIS IS EXAMPLE CODEAND NEEDS TO BE CHANGED
	// res << zinit.ZProcessNewArgs{
	//     name: 'gitea'
	//     cmd: 'gitea server'
	//     env: {
	//         'HOME': '/root'
	//     }
	// }

	return res
}

fn running() !bool {
	mut installer := get()!
	// THIS IS EXAMPLE CODEAND NEEDS TO BE CHANGED
	// this checks health of gitea
	// curl http://localhost:3333/api/v1/s --oauth2-bearer 1234 works
	// url:='http://127.0.0.1:${cfg.port}/api/v1'
	// mut conn := httpconnection.new(name: 'gitea', url: url)!

	// if cfg.secret.len > 0 {
	//     conn.default_header.add(.authorization, 'Bearer ${cfg.secret}')
	// }
	// conn.default_header.add(.content_type, 'application/json')
	// console.print_debug("curl -X 'GET' '${url}'/tags --oauth2-bearer ${cfg.secret}")
	// r := conn.get_json_dict(prefix: 'tags', debug: false) or {return false}
	// println(r)
	// if true{panic("ssss")}
	// tags := r['Tags'] or { return false }
	// console.print_debug(tags)
	// console.print_debug('gitea is answering.')
	return false
}
