#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.virt.docker

fn build() ! {
	mut engine := docker.new(prefix: '', localonly: true)!

	mut r := engine.recipe_new(name: 'dev_tools', platform: .alpine)

	r.add_from(image: 'alpine', tag: 'latest')!

	r.add_package(name: 'git,mc,htop')!

	r.add_zinit()!

	r.add_sshserver()!

	r.build(true)!
}

// build()!

mut engine := docker.new(prefix: '', localonly: true)!

// Check if dev_tools image exists
if !engine.image_exists(repo: 'dev_tools')! {
	eprintln("image dev_tools doesn't exist, build it")
	build()!
}

engine.container_delete(name: 'dev2') or {}

// Check if container exists and get its status
mut container := engine.container_get(
	name: 'dev2'
) or {
	// Container doesn't exist, create it
	println('Creating dev2 container...')
	engine.container_create(
		name:             'dev2'
		image_repo:       'dev_tools'
		remove_when_done: false
		forwarded_ports:  ['8022:22/tcp'] // this forward 8022 on host to 22 on container
		env:              {
			'SSH_KEY': 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIahWiRRm9cWAKktH9dndn3R45grKqzPC3mKX8IjGgH6 kristof@incubaid.com'
		}
	)!
}

// Start container if not running
if container.status != .up {
	println('Starting dev2 container...')
	container.start()!
}

// Open shell to container
println('Opening shell to dev2 container...')
container.shell()!
