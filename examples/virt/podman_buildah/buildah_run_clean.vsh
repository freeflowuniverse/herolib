#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.virt.herocontainers
import freeflowuniverse.herolib.ui.console
// import freeflowuniverse.herolib.builder
import time
import os

mut pm := herocontainers.new(herocompile: false)!

mut b := pm.builder_new()!

println(b)

// mut mybuildcontainer := pm.builder_get("builderv")!

// mybuildcontainer.clean()!

// mybuildcontainer.commit('localhost/buildersmall')!

b.shell()!
