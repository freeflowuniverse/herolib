#!/usr/bin/env -S v -n -w -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.installers.virt.youki

mut youki_installer := youki.get()!

youki_installer.install()!
