#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.virt.docker

mut engine := docker.new(prefix: '', localonly: true)!

mut r := engine.recipe_new(name: 'dev_tools', platform: .alpine)

r.add_from(image: 'alpine', tag: 'latest')!

r.add_package(name: 'git,mc')!

r.add_zinit()!

r.add_sshserver()!

r.build(true)!
