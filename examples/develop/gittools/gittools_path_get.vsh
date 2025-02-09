#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.develop.gittools
import freeflowuniverse.herolib.osal
import time

mut gs := gittools.new()!
mydocs_path := gs.get_path(
	pull:  true
	reset: false
	url:   'https://git.ourworld.tf/tfgrid/info_docs_depin/src/branch/main/docs'
)!

println(mydocs_path)
