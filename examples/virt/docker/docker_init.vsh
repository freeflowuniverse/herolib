#!/usr/bin/env -S v -n -w -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.virt.docker

mut engine := docker.new()!

engine.reset_all()!

println(engine)
