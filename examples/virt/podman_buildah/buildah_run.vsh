#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.virt.herocontainers
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.core.base
// import freeflowuniverse.herolib.builder
import time
import os

mut pm := herocontainers.new(herocompile: true, install: false)!

mut mybuildcontainer := pm.builder_get('builder_heroweb')!

// bash & python can be executed directly in build container

// any of the herocommands can be executed like this
mybuildcontainer.run(cmd: 'installers -n heroweb', runtime: .herocmd)!

// //following will execute heroscript in the buildcontainer
// mybuildcontainer.run(
// 	cmd:"

// 	!!play.echo content:'this is just a test'

// 	!!play.echo content:'this is another test'

// 	",
// 	runtime:.heroscript)!

// there are also shortcuts for this

// mybuildcontainer.hero_copy()!
// mybuildcontainer.shell()!

// mut b2:=pm.builder_get("builderv")!
// b2.shell()!
