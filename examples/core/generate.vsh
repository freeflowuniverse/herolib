#!/usr/bin/env -S v -n -w -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.core.generator.installer

installer.scan('~/code/github/freeflowuniverse/herolib/herolib')!
