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

const postgres_container_name = 'herocontainer_postgresql'

// checks if a certain version or above is installed
fn installed() !bool {
	mut podman := podman_installer.get()!
	podman.install()!

	// We need to check also if postgres is installed
	mut result := os.execute('podman healthcheck run ${postgres_container_name}')

	if result.exit_code != 0 {
		return false
	}

	result = os.execute('gitea -v')

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
	container_name: '${postgres_container_name}'
"

	postgres_installer.play(heroscript: postgres_heroscript)!
	mut postgres := postgres_installer.get()!
	postgres.install()!
	postgres.start()!
}

fn install() ! {
	if installed()! {
		console.print_header('gitea binaraies already installed')
		return
	}

	console.print_header('install gitea')
	server := get()!

	// make sure we install base on the node
	base.install()!
	install_postgres(server)!

	mut download_link := ''

	is_linux_intel := core.is_linux_intel()!
	is_osx_arm := core.is_osx_arm()!

	if is_linux_intel {
		download_link = 'https://dl.gitea.com/gitea/${server.version}/gitea-${server.version}-linux-amd64'
	}

	if is_osx_arm {
		download_link = 'https://dl.gitea.com/gitea/${server.version}/gitea-${server.version}-darwin-10.12-amd64'
	}

	if download_link.len == 0 {
		return error('unsupported platform')
	}

	binary := osal.download(
		url:  download_link
		name: 'gitea'
		dest: '/tmp/gitea'
	) or { return error('failed to download gitea due to: ${err}') }

	mut res := os.execute('sudo cp ${binary.path} /usr/local/bin/gitea')
	if res.exit_code != 0 {
		return error('failed to add gitea to the path due to: ${res.output}')
	}

	res = os.execute('sudo chmod +x /usr/local/bin/gitea')
	if res.exit_code != 0 {
		return error('failed to make gitea executable due to: ${res.output}')
	}

	// create config file
	file_content := $tmpl('./templates/app.ini')
	mut file := os.open_file('/etc/gitea_app.ini', 'w')!
	file.write(file_content.bytes())!

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
	return ulist.UList{}
}

// uploads to S3 server if configured
fn upload() ! {}

fn startupcmd() ![]zinit.ZProcessNewArgs {
	mut res := []zinit.ZProcessNewArgs{}
	cfg := get()!
	res << zinit.ZProcessNewArgs{
		name: 'gitea'
		// cmd:     'GITEA_WORK_DIR=${cfg.path} sudo -u git /var/lib/git/gitea web -c /etc/gitea_app.ini'
		cmd:     '

# Variables
GITEA_USER="${cfg.run_user}"
GITEA_HOME="${cfg.path}"
GITEA_BINARY="/usr/local/bin/gitea"
GITEA_CONFIG="/etc/gitea_app.ini"
GITEA_DATA_PATH="\$GITEA_HOME/data"
GITEA_CUSTOM_PATH="\$GITEA_HOME/custom"
GITEA_LOG_PATH="\$GITEA_HOME/log"

# Ensure the script is run as root
if [[ \$EUID -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

echo "Setting up Gitea..."

# Create Gitea user if it doesn\'t exist
if id -u "\$GITEA_USER" &>/dev/null; then
    echo "User \$GITEA_USER already exists."
else
    echo "Creating Gitea user..."
    if ! sudo adduser --system --shell /bin/bash --group --disabled-password --home "/var/lib/\$GITEA_USER" "\$GITEA_USER"; then
        echo "Failed to create user \$GITEA_USER."
        exit 1
    fi
fi

# Create necessary directories
echo "Creating directories..."
mkdir -p "\$GITEA_DATA_PATH" "\$GITEA_CUSTOM_PATH" "\$GITEA_LOG_PATH"
chown -R "\$GITEA_USER:\$GITEA_USER" "\$GITEA_HOME"
chmod -R 750 "\$GITEA_HOME"

chown "\$GITEA_USER:\$GITEA_USER" "\$GITEA_CONFIG"
chmod 640 "\$GITEA_CONFIG"

GITEA_WORK_DIR=\$GITEA_HOME sudo -u git gitea web -c \$GITEA_CONFIG
'
		workdir: cfg.path
	}
	res << zinit.ZProcessNewArgs{
		name:    'restart_gitea'
		cmd:     'sleep 30 && zinit restart gitea && exit 1'
		after:   ['gitea']
		oneshot: true
		workdir: cfg.path
	}
	return res
}

fn running() !bool {
	res := os.execute('curl -fsSL http://localhost:3000 || exit 1')
	return res.exit_code == 0
}
