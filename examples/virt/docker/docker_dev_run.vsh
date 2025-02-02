#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.virt.docker

mut engine := docker.new(prefix: '', localonly: true)!


// Check if dev_tools image exists
if ! engine.image_exists(repo: 'dev_tools') !{
    eprintln("image dev_tools doesn't exist, build it")
    exit(1)
}

// Check if container exists and get its status
mut container := engine.container_get(
    name: 'dev_tools'
) or {
    // Container doesn't exist, create it
    println('Creating dev_tools container...')
    engine.container_create(
        name: 'dev_tools'
        image_repo: 'dev_tools'
        remove_when_done: false
    )!
}

// Start container if not running
if container.status != .up {
    println('Starting dev_tools container...')
    container.start()!
}

// Open shell to container
println('Opening shell to dev_tools container...')
container.shell()!
