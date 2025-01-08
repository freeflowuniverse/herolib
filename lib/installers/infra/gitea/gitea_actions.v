module gitea

import freeflowuniverse.herolib.osal
import freeflowuniverse.herolib.core
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.installers.base
import freeflowuniverse.herolib.installers.ulist
import freeflowuniverse.herolib.installers.db.postgresql as postgres_installer
import freeflowuniverse.herolib.installers.virt.podman as podman_installer
import freeflowuniverse.herolib.osal.zinit
import os

// checks if a certain version or above is installed
fn installed() !bool {
	mut podman := podman_installer.get()!
	podman.install()!

	cmd := 'gitea -v'
	result := os.execute(cmd)

	if result.exit_code != 0 {
		return false
	}
	return true
}

fn install_postgres(cfg GiteaServer) ! {
	postgres_heroscript := "
!!postgresql.configure 
	name: '${cfg.database_name}'
	user: '${cfg.database_user}'
	password: '${cfg.database_passwd}'
	host: '${cfg.database_host}'
	port: ${cfg.database_port}
	volume_path:'/var/lib/postgresql/data'
	container_name: 'herocontainer_postgresql'
"

	postgres_installer.play(heroscript: postgres_heroscript)!
	mut postgres := postgres_installer.get()!
	postgres.install()!
}

fn install() ! {
	if installed()! {
		console.print_header('gitea binaraies already installed')
		return
	}

	console.print_header('install gitea')
	cfg := get()!

	// make sure we install base on the node
	base.install()!
	install_postgres(cfg)!

	platform := core.platform()!
	mut download_link := ''

	is_linux_intel := core.is_linux_intel()!
	is_osx_arm := core.is_osx_arm()!

	if is_linux_intel {
		download_link = 'https://dl.gitea.com/gitea/${cfg.version}/gitea-${cfg.version}-linux-amd64'
	}

	if is_osx_arm {
		download_link = 'https://dl.gitea.com/gitea/${cfg.version}/gitea-${cfg.version}-darwin-10.12-amd64'
	}

	if download_link.len == 0 {
		return error('unsupported platform')
	}

	binary := osal.download(url: download_link, name: 'gitea', dest: '/tmp/gitea') or {
		return error('failed to download gitea due to: ${err}')
	}

	osal.cmd_add(cmdname: 'gitea', source: binary.path) or {
		return error('failed to add gitea to the path due to: ${err}')
	}

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
	mut server := get()!
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
	server := get()!
	cfg_file := $tmpl('./templates/app.ini')
	// TODO: We need to finish the work here
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
