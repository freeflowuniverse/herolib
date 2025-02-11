#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.installers.sysadmintools.daguserver
import freeflowuniverse.herolib.installers.infra.zinit

// make sure zinit is there and running, will restart it if needed
mut z := zinit.get()!
z.destroy()!
z.start()!

// mut ds := daguserver.get()!
// ds.destroy()!
// ds.start()!

// println(ds)
