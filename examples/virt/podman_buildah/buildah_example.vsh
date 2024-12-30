#!/usr/bin/env -S v -n -w -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.virt.herocontainers
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.osal

import freeflowuniverse.herolib.installers.virt.pacman


mut installer:= pacman.get()!

//installer.destroy()!
//installer.install()!

//exit(0)

//interative means will ask for login/passwd

mut engine:=herocontainers.new(install:true,herocompile:false)!

engine.reset_all()!

mut builder_gorust := engine.builder_go_rust()!

//will build nodejs, python build & herolib, hero
//mut builder_hero := engine.builder_hero(reset:true)!

//mut builder_web := engine.builder_heroweb(reset:true)!



builder_gorust.shell()!
