#!/usr/bin/env -S v -cg -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run
// #!/usr/bin/env -S v -n -cg -w -enable-globals run

import freeflowuniverse.herolib.installers.sysadmintools.daguserver
import freeflowuniverse.herolib.installers.infra.zinit

//make sure zinit is there and running, will restart it if needed
mut z:=zinit.get()!
z.destroy()!
z.start()!

// mut ds := daguserver.get()!
// ds.destroy()!
// ds.start()!

// println(ds)
