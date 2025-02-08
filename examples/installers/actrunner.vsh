#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.installers.sysadmintools.actrunner
import freeflowuniverse.herolib.installers.virt.herocontainers

actrunner.install()!
// herocontainers.start()!
