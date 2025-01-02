module garage_s3

import freeflowuniverse.herolib.osal
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.core
import freeflowuniverse.herolib.osal.zinit
// import freeflowuniverse.herolib.osal.systemd
import os

// checks if a certain version or above is installed
fn installed() !bool {
	// THIS IS EXAMPLE CODEAND NEEDS TO BE CHANGED
	res := os.execute('${osal.profile_path_source_and()!} garage_s3 version')
	if res.exit_code != 0 {
		return false
	}

	r := res.output.split_into_lines().filter(it.trim_space().len > 0)
	if r.len != 1 {
		return error("couldn't parse garage_s3 version.\n${res.output}")
	}

	if texttools.version(version) > texttools.version(r[0]) {
		return false
	}

	return true
}

fn install() ! {
	console.print_header('install garage_s3')
	mut installer := get()!
	// THIS IS EXAMPLE CODEAND NEEDS TO BE CHANGED
	mut url := ''
	if core.is_linux_arm()! {
		url = 'https://github.com/garage_s3-dev/garage_s3/releases/download/v${version}/garage_s3_${version}_linux_arm64.tar.gz'
	} else if core.is_linux_intel()! {
		url = 'https://github.com/garage_s3-dev/garage_s3/releases/download/v${version}/garage_s3_${version}_linux_amd64.tar.gz'
	} else if core.is_osx_arm()! {
		url = 'https://github.com/garage_s3-dev/garage_s3/releases/download/v${version}/garage_s3_${version}_darwin_arm64.tar.gz'
	} else if core.is_osx_intel()! {
		url = 'https://github.com/garage_s3-dev/garage_s3/releases/download/v${version}/garage_s3_${version}_darwin_amd64.tar.gz'
	} else {
		return error('unsported platform')
	}

	mut dest := osal.download(
		url:        url
		minsize_kb: 9000
		expand_dir: '/tmp/garage_s3'
	)!

	// dest.moveup_single_subdir()!

	mut binpath := dest.file_get('garage_s3')!
	osal.cmd_add(
		cmdname: 'garage_s3'
		source:  binpath.path
	)!
}

fn startupcmd() ![]zinit.ZProcessNewArgs {
	mut res := []zinit.ZProcessNewArgs{}
	// THIS IS EXAMPLE CODEAND NEEDS TO BE CHANGED
	res << zinit.ZProcessNewArgs{
		name: 'garage_s3'
		cmd:  'garage_s3 server'
		env:  {
			'HOME': '/root'
		}
	}

	return res
}

fn running_() !bool {
	mut installer := get()!
	// THIS IS EXAMPLE CODEAND NEEDS TO BE CHANGED
	// this checks health of garage_s3
	// curl http://localhost:3333/api/v1/s --oauth2-bearer 1234 works
	// url:='http://127.0.0.1:${cfg.port}/api/v1'
	// mut conn := httpconnection.new(name: 'garage_s3', url: url)!

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
	// console.print_debug('garage_s3 is answering.')
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

fn destroy_() ! {
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
