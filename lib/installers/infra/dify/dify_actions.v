module dify

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
import freeflowuniverse.herolib.installers.virt.docker as docker_installer
import os

fn startupcmd() ![]zinit.ZProcessNewArgs {
	mut installer := get()!
	mut res := []zinit.ZProcessNewArgs{}
	mut cfg := get()!
	cmd := "
	echo 'zinit starting dify'
	export COMPOSE_PROJECT_NAME=${cfg.project_name}
	docker compose -f ${cfg.compose_file} --env-file ${cfg.path}/docker/.env -e SECRET_KEY=${cfg.secret_key} -e INIT_PASSWORD=${cfg.init_password} up -d
    	"
	res << zinit.ZProcessNewArgs{
	    name:        'dify'
	    cmd:         cmd
	    startuptype: .zinit
	}
	return res
}

fn running() !bool {
	mut installer := get()!
	cfg := get()!
	cmd := "docker compose -f ${cfg.compose_file} ps | grep dify-web"
	res := os.execute(cmd)
	return res.exit_code == 0
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
	mut cfg := get()!
	mut docker := docker_installer.get()!
	docker.install()!

	cmd := "docker compose -f ${cfg.compose_file} ps | grep dify-web"
	result := os.execute(cmd)
	if result.exit_code != 0 {
		return false
	}
	return true
}

// get the Upload List of the files
fn ulist_get() !ulist.UList {
	// optionally build a UList which is all paths which are result of building, is then used e.g. in upload
	return ulist.UList{}
}

// uploads to S3 server if configured
fn upload() ! {
	// installers.upload(
	//     cmdname: 'dify'
	//     source: '${gitpath}/target/x86_64-unknown-linux-musl/release/dify'
	// )!
}

fn install() ! {
	console.print_header('---------------- install function installing dify kjnaskldjfndfjwnf')
	mut docker := docker_installer.get()!
	mut cfg := get()!
	docker.install()!
	cmd := "
	[ -d ${cfg.path} ] || git clone https://github.com/langgenius/dify.git -b 1.4.0 ${cfg.path}
	cp ${cfg.path}/docker/.env.example ${cfg.path}/docker/.env
	docker compose -f ${cfg.compose_file} pull
	"
	osal.execute_stdout(cmd) or { return error('Cannot install dify due to: ${err}') }
	console.print_header('Docker installed and Dify images are pulled')
}

fn build() ! {
	// url := 'https://github.com/threefoldtech/dify'

	// make sure we install base on the node
	// if osal.platform() != .ubuntu {
	//     return error('only support ubuntu for now')
	// }
	// golang.install()!

	// console.print_header('build dify')

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
	mut cfg := get()!
	cmd := "docker compose -f ${cfg.compose_file} down"
	result := os.execute(cmd)
	if result.exit_code != 0 {
		return error("dify isn't running: ${result.output}")
	}

	mut docker := docker_installer.get()!
	docker.destroy()!

	mut zinit_factory := zinit.new()!
	if zinit_factory.exists('dify') {
		zinit_factory.stop('dify') or {
			return error('Could not stop dify service due to: ${err}')
		}
		zinit_factory.delete('dify') or {
			return error('Could not delete dify service due to: ${err}')
		}
	}
	console.print_header('Dify installation removed')
}
