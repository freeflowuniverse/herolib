module dify

import freeflowuniverse.herolib.osal
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.installers.virt.docker as docker_installer
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.osal.systemd
import freeflowuniverse.herolib.osal.zinit
import freeflowuniverse.herolib.installers.ulist
import os

fn startupcmd() ![]zinit.ZProcessNewArgs {
	mut installer := get()!
	mut cfg := get()!
	mut res := []zinit.ZProcessNewArgs{}
	mut path := cfg.path
	
	cmd := "
	git clone https://github.com/langgenius/dify.git -b 1.4.0 ${path}
	cp ${path}/docker/.env.example ${path}/docker/.env
	export COMPOSE_PROJECT_NAME=${cfg.project_name}
	docker compose -f ${cfg.compose_file} --env-file ${cfg.path}/docker/.env up -d
    	"
	return res
}

fn running() !bool {
	cfg := get()!
	cmd := 'docker compose -f ${cfg.compose_file} ps | grep dify-web'
	result := os.execute(cmd)

	if result.exit_code != 0 {
		return false
	}
	return true
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

fn installed() !bool {
	mut cfg := get()!
	mut docker := docker_installer.get()!
	docker.install()!

	cmd := 'docker compose -f ${cfg.compose_file} ps | grep dify-web'
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
	console.print_header('install dify')
	mut cfg := get()!
	mut docker := docker_installer.get()!
	docker.install()!
	os.system('sed -i "s/^SECRET_KEY=.*/SECRET_KEY=${cfg.secret_key}/; s/^INIT_PASSWORD=.*/INIT_PASSWORD=${cfg.init_password}/" ${cfg.path}/docker/.env')
	osal.execute_silent('docker compose pull -f ${cfg.compose_file} pull')!
}

fn destroy() ! {
	mut cfg := get()!
	cmd := 'docker compose -f ${cfg.compose_file} down'
	result := os.execute(cmd)

	if result.exit_code != 0 {
		return error("dify isn't running: ${result.output}")
	}

	// Remove docker
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
