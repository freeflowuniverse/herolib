#!/usr/bin/env -S v -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.biz.investortool
import freeflowuniverse.herolib.core.playbook
import os

mut plbook := playbook.new(
	path: '${os.home_dir()}/code/git.threefold.info/ourworld_holding/investorstool/output'
)!
mut it := investortool.play(mut plbook)!
it.check()!
