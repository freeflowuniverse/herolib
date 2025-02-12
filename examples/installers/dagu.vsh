#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.installers.sysadmintools.daguserver
import freeflowuniverse.herolib.installers.infra.zinit_installer

mut ds := daguserver.get()!
ds.install()!
ds.start()!
ds.destroy()!
