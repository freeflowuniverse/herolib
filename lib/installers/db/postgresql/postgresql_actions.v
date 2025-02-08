module postgresql

import freeflowuniverse.herolib.osal
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.installers.virt.podman as podman_installer
import freeflowuniverse.herolib.osal.zinit
import os

fn installed_() !bool {
	mut cfg := get()!
	mut podman := podman_installer.get()!
	podman.install()!

	cmd := 'podman healthcheck run ${cfg.container_name}'
	result := os.execute(cmd)

	if result.exit_code != 0 {
		return false
	}
	return true
}

fn install_() ! {
	console.print_header('install postgresql')
	mut podman := podman_installer.get()!
	podman.install()!
	osal.execute_silent('podman pull docker.io/library/postgres:latest')!
}

fn startupcmd() ![]zinit.ZProcessNewArgs {
	mut cfg := get()!
	mut res := []zinit.ZProcessNewArgs{}
	cmd := "
    mkdir -p ${cfg.volume_path}
    podman run --name ${cfg.container_name} -e POSTGRES_USER=${cfg.user} -e POSTGRES_PASSWORD=\"${cfg.password}\" -v ${cfg.volume_path}:/var/lib/postgresql/data -p ${cfg.port}:5432 --health-cmd=\"pg_isready -U ${cfg.user}\" postgres:latest
    "

	res << zinit.ZProcessNewArgs{
		name:        'postgresql'
		cmd:         cmd
		startuptype: .zinit
	}
	return res
}

fn running_() !bool {
	mut mydb := get()!
	mydb.check() or { return false }
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

fn destroy_() ! {
	// remove the podman postgresql container
	mut cfg := get()!
	cmd := 'podman rm -f ${cfg.container_name}'
	result := os.execute(cmd)

	if result.exit_code != 0 {
		return error("Postgresql container isn't running: ${result.output}")
	}
	console.print_header('Postgresql container removed')
}
