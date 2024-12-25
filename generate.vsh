#!/usr/bin/env -S v -n -w -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.code.generator.generic

generic.scan(path:"~/code/github/freeflowuniverse/herolib/lib/installers",force:true, add:true)!
