#!/usr/bin/env -S v -n -w -gc none -cg -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.core.playbook
import os


heroscript_config := '
	!!heropromptworkspace.configure name:"test workspace" path:"${os.home_dir()}/code/github/freeflowuniverse/herolib"
'
mut plbook := playbook.new(
	text: heroscript_config
)!


heroprompt.play(mut plbook)!
