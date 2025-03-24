#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.installers.db.cometbft as cometbft_installer

// coredns_installer.delete()!
mut installer := cometbft_installer.get()!
installer.install()!
