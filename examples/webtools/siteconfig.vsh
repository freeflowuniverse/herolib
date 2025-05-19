#!/usr/bin/env -S v -n -w -gc none  -cg -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.web.siteconfig
import os
mypath :='${os.dir(@FILE)}/siteconfigexample'

mut sc:=siteconfig.new(mypath)!

println(sc)
