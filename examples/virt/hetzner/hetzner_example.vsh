#!/usr/bin/env -S v -n -w -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.virt.hetzner
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.builder
import time
import os

console.print_header('Hetzner login.')

// USE IF YOU WANT TO CONFIGURE THE HETZNER, ONLY DO THIS ONCE
// hetzner.configure("test")!

mut cl := hetzner.get('test')!

for i in 0 .. 5 {
	println('test cache, first time slow then fast')
	cl.servers_list()!
}

println(cl.servers_list()!)

mut serverinfo := cl.server_info_get(name: 'kristof2')!

println(serverinfo)

// cl.server_reset(name:"kristof2",wait:true)!

// cl.server_rescue(name:"kristof2",wait:true)!

console.print_header('SSH login')
mut b := builder.new()!
mut n := b.node_new(ipaddr: serverinfo.server_ip)!

// n.hero_install()!
// n.hero_compile_debug()!

// mut ks:=cl.keys_get()!
// println(ks)
