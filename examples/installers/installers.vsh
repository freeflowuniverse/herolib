#!/usr/bin/env -S v -n -w -cg -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.installers.lang.rust
import freeflowuniverse.herolib.installers.lang.python
import freeflowuniverse.herolib.installers.lang.nodejs
import freeflowuniverse.herolib.installers.lang.golang
import freeflowuniverse.herolib.core

core.interactive_set()! // make sure the sudo works so we can do things even if it requires those rights

// import freeflowuniverse.herolib.data.dbfs
// import freeflowuniverse.herolib.installers.lang.vlang
// import freeflowuniverse.herolib.installers.db.redis as redis_installer
// import freeflowuniverse.herolib.installers.infra.coredns as coredns_installer
// import freeflowuniverse.herolib.installers.sysadmintools.daguserver as dagu_installer
// import freeflowuniverse.herolib.installers.sysadmintools.b2 as b2_installer
// import freeflowuniverse.herolib.installers.net.mycelium as mycelium_installer
// import freeflowuniverse.herolib.osal.screen
// import freeflowuniverse.herolib.osal

// redis_installer.new()!
// dagu_installer.install(passwd:"1234",secret:"1234",restart:true)!

// coredns_installer.install()!
// mycelium_installer.install()!
// mycelium_installer.restart()!

// mut screens:=screen.new()!
// println(screens)

// dagu_installer.check(secret:"1234")!

// vlang.v_analyzer_install()!

// b2_installer.install()!

// rust.install(reset:false)!
// python.install(reset:false)!
// nodejs.install(reset:false)!
golang.install(reset: false)!
