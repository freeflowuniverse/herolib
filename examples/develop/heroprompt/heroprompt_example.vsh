#!/usr/bin/env -S v -n -w -gc none -cg -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.develop.heroprompt

mut session := heroprompt.new_session()

mut workspace1 := session.add_workspace()!
// TODO: Check the name bug
// mut workspace2 := session.add_workspace(name: 'withname')!

mut dir1 := workspace1.add_dir(path: '/Users/mahmoud/code/github/freeflowuniverse/herolib/docker')!
dir1.select_file(name: 'docker_ubuntu_install.sh')!

mut dir2 := workspace1.add_dir(
	path: '/Users/mahmoud/code/github/freeflowuniverse/herolib/docker/herolib'
)!

dir2.select_file(name: '.gitignore')!
dir2.select_file(name: 'build.sh')!
dir2.select_file(name: 'debug.sh')!

mut dir3 := workspace1.add_dir(
	path:       '/Users/mahmoud/code/github/freeflowuniverse/herolib/docker/postgresql'
	select_all: true
)!

selected := workspace1.get_selected()

prompt := workspace1.prompt(
	text: 'Using the selected files, i want you to get all print statments'
)

println(prompt)
