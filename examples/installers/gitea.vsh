#!/usr/bin/env -S v -n -w -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.installers.infra.gitea

mut g := gitea.new(
	passwd:           '123'
	postgresql_path:  '/tmp/db'
	postgresql_reset: true
	domain:           'git.meet.tf'
	appname:          'ourworld'
)!
// postgresql will be same passwd
g.restart()!
