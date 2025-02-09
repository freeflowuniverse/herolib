#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.installers.infra.coredns as coredns_installer
import freeflowuniverse.herolib.osal

// coredns_installer.delete()!
mut installer:= coredns_installer.get()!
installer.build()!

