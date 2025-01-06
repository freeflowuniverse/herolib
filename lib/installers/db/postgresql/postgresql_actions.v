module postgresql

import freeflowuniverse.herolib.osal
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.installers.virt.podman as podman_installer
import freeflowuniverse.herolib.osal.zinit

fn installed_() !bool {
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
    podman run --name ${cfg.name} -e POSTGRES_USER=${cfg.user} -e POSTGRES_PASSWORD=\"${cfg.password}\" -v ${cfg.volume_path}:/var/lib/postgresql/data -p ${cfg.port}:5432 --health-cmd=\"pg_isready -U ${cfg.user}\" postgres:latest
    "

	res << zinit.ZProcessNewArgs{
		name:        'postgresql'
		cmd:         cmd
		workdir:     cfg.volume_path
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
	mut mydb := get()!
	mydb.destroy()!

	// mut cfg := get()!
	// osal.rm("
	//     ${cfg.path}
	//     /etc/postgresql/
	//     /etc/postgresql-common/
	//     /var/lib/postgresql/
	//     /etc/systemd/system/multi-user.target.wants/postgresql
	//     /lib/systemd/system/postgresql.service
	//     /lib/systemd/system/postgresql@.service
	// ")!

	// c := '

	// #dont die
	// set +e

	// # Stop the PostgreSQL service
	// sudo systemctl stop postgresql

	// # Purge PostgreSQL packages
	// sudo apt-get purge -y postgresql* pgdg-keyring

	// # Remove all data and configurations
	// sudo userdel -r postgres
	// sudo groupdel postgres

	// # Reload systemd configurations and reset failed systemd entries
	// sudo systemctl daemon-reload
	// sudo systemctl reset-failed

	// echo "PostgreSQL has been removed completely"

	// '
	// osal.exec(cmd: c)!
}
