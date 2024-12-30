#!/usr/bin/env -S v -n -w -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.installers.threefold.griddriver
mut griddriver_installer := griddriver.get()!
griddriver_installer.install()!
