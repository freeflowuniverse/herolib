#!/usr/bin/env -S v -n -w -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run


import freeflowuniverse.herolib.installers.infra.coredns as coredns_installer


coredns_installer.install()!
