#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.threefold.tfrobot
import freeflowuniverse.herolib.ui.console

console.print_header("Get VM's.")

for vm in tfrobot.vms_get('holotest2')! {
	console.print_debug(vm.str())
	mut node := vm.node()!
	r := node.exec(cmd: 'ls /')!
	println(r)
}
