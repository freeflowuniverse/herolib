#!/usr/bin/env -S v -gc none -no-retry-compilation -d use_openssl -enable-globals -cg run

//#!/usr/bin/env -S v -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals -cg run
import freeflowuniverse.herolib.threefold.gridproxy
import freeflowuniverse.herolib.threefold.tfgrid3deployer
import freeflowuniverse.herolib.installers.threefold.griddriver
import os
import time

griddriver.install()!

v := tfgrid3deployer.get()!
println('cred: ${v}')
deployment_name := 'vm_caddy1'
mut deployment := tfgrid3deployer.new_deployment(deployment_name)!
deployment.add_network(ip_range: '1.1.1.1/16', user_access: 5)
deployment.add_machine(
	name:       'vm_caddy1'
	cpu:        1
	memory:     2
	planetary:  false
	public_ip4: true
	size:       10 // 10 gig
	mycelium:   tfgrid3deployer.Mycelium{}
)
deployment.deploy()!

vm1 := deployment.vm_get('vm_caddy1')!
println('vm1 info: ${vm1}')

vm1_public_ip4 := vm1.public_ip4.all_before('/')

deployment.add_webname(name: 'gwnamecaddy', backend: 'http://${vm1_public_ip4}:80', use_wireguard: true)
deployment.deploy()!
gw1 := deployment.webname_get('gwnamecaddy')!
println('gw info: ${gw1}')
