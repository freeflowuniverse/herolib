#!/usr/bin/env -S v -n -w -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.threefold.gridproxy
import freeflowuniverse.herolib.threefold.tfgrid3deployer
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.installers.threefold.griddriver

fn main() {
	griddriver.install()!

	v := tfgrid3deployer.get()!
	println('cred: ${v}')
	deployment_name := 'my_deployment27'

	mut deployment := tfgrid3deployer.new_deployment(deployment_name)!
	// mut deployment := tfgrid3deployer.get_deployment(deployment_name)!
	deployment.add_machine(
		name:       'my_vm1'
		cpu:        1
		memory:     2
		planetary:  false
		public_ip4: true
		mycelium:   tfgrid3deployer.Mycelium{}
		nodes:      [u32(167)]
	)
	deployment.add_machine(
		name:      'my_vm2'
		cpu:       1
		memory:    2
		planetary: false
		mycelium:  tfgrid3deployer.Mycelium{}
		// nodes:     [u32(164)]
	)

	deployment.add_zdb(name: 'my_zdb', password: 'my_passw&rd', size: 2)
	deployment.add_webname(name: 'mywebname2', backend: 'http://37.27.132.47:8000')
	deployment.deploy()!

	// deployment.add_machine(
	// 	name:      'my_vm4'
	// 	cpu:       2
	// 	memory:    3
	// 	planetary: false
	// 	mycelium:  tfgrid3deployer.Mycelium{}
	// )
	// deployment.deploy()!

	// deployment.remove_machine('my_vm1')!
	// deployment.remove_webname('mywebname2')!
	// deployment.remove_zdb('my_zdb')!
	// deployment.deploy()!

	tfgrid3deployer.delete_deployment(deployment_name)!
}
