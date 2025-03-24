#!/usr/bin/env -S v -n -w -cg -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.installers.lang.rust
import freeflowuniverse.herolib.installers.lang.python
import freeflowuniverse.herolib.installers.lang.nodejs
import freeflowuniverse.herolib.installers.lang.golang
import freeflowuniverse.herolib.core

core.interactive_set()! // make sure the sudo works so we can do things even if it requires those rights

mut i1:=golang.get()!
i1.install()!
