#!/usr/bin/env -S v -n -w -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run


import freeflowuniverse.herolib.hero.bootstrap

mut al:=bootstrap.new_alpine_loader()

al.start()!
