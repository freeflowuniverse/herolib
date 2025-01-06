module podman

import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.core
import os

// Check if Podman is installed
fn installed() bool {
	console.print_header('Checking if Podman is installed...')
	result := os.execute('podman -v')
	return result.exit_code == 0
}

// Install Podman
fn install() ! {
	if installed() {
		return error('Podman is already installed.')
	}

	console.print_header('Installing Podman...')
	platform := core.platform()!
	command := get_platform_command(platform, 'install')!
	execute_command(command, 'installing Podman')!
	console.print_header('Podman installed successfully.')
}

// Remove Podman
fn destroy() ! {
	if !installed() {
		return error('Podman is not installed.')
	}

	console.print_header('Removing Podman...')
	platform := core.platform()!
	command := get_platform_command(platform, 'remove')!
	execute_command(command, 'removing Podman')!
	console.print_header('Podman removed successfully.')
}

// Build Podman (install it)
fn build() ! {
	install()!
}

// Get platform-specific commands for installing/removing Podman
fn get_platform_command(platform core.PlatformType, action string) !string {
	return match platform {
		.ubuntu {
			if action == 'install' {
				'sudo apt-get -y install podman'
			} else if action == 'remove' {
				'sudo apt-get -y remove podman'
			} else {
				return error('Invalid action: ${action}')
			}
		}
		.arch {
			if action == 'install' {
				'sudo pacman -S --noconfirm podman'
			} else if action == 'remove' {
				'sudo pacman -R --noconfirm podman'
			} else {
				return error('Invalid action: ${action}')
			}
		}
		.osx {
			if action == 'install' {
				'brew install podman'
			} else if action == 'remove' {
				'brew uninstall podman'
			} else {
				return error('Invalid action: ${action}')
			}
		}
		else {
			return error('Only Ubuntu, Arch, and macOS are supported.')
		}
	}
}

// Execute a shell command and handle errors
fn execute_command(command string, operation string) ! {
	result := os.execute(command)
	if result.exit_code != 0 {
		return error('Failed ${operation}: ${result.output}')
	}
}
