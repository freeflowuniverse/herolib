#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.core.generator.generic as generator


generic.scan(path:"~/code/github/freeflowuniverse/herolib/herolib/installers",force:true)!
