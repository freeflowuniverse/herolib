#!/usr/bin/env -S v -n -w -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.installers.virt.podman as podman_installer

mut podman := podman_installer.get()!

if podman.installed() {
	podman.destroy()!
} else {
	podman.install()!
}
