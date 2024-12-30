#!/usr/bin/env -S v -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.installers.lang.vlang
import freeflowuniverse.herolib.installers.sysadmintools.daguserver
import freeflowuniverse.herolib.installers.sysadmintools.b2 as b2_installer

vlang.v_analyzer_install()!
daguserver.new()! //will install & start a daguserver

