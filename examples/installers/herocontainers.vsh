#!/usr/bin/env -S v -n -w -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.osal
import freeflowuniverse.herolib.installers.lang.golang

import freeflowuniverse.herolib.installers.virt.podman as podman_installer
import freeflowuniverse.herolib.installers.virt.buildah as buildah_installer

mut podman_installer0:= podman_installer.get()!
mut buildah_installer0:= buildah_installer.get()!

//podman_installer0.destroy()! //will remove all

podman_installer0.install()!
buildah_installer0.install()!
