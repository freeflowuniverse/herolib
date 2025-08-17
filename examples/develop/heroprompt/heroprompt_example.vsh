#!/usr/bin/env -S v -n -w -gc none -cg -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.develop.heroprompt
import freeflowuniverse.herolib.core.playbook
import os

// heroscript_config := '
// 	!!heropromptworkspace.configure name:"test workspace" path:"${os.home_dir()}/code/github/freeflowuniverse/herolib"
// '
// mut plbook := playbook.new(
// 	text: heroscript_config
// )!

// heroprompt.play(mut plbook)!

// mut workspace1 := heroprompt.new_workspace(
// 	path: '${os.home_dir()}/code/github/freeflowuniverse/herolib'
// )!

mut workspace2 := heroprompt.get(
	name: 'test workspace'
)!

// workspace1.add_dir(path: '${os.home_dir()}/code/github/freeflowuniverse/herolib/docker')!
// workspace1.add_file(path: '${os.home_dir()}/code/github/freeflowuniverse/herolib/docker/docker_ubuntu_install.sh')!

// workspace1.add_dir(path: '${os.home_dir()}/code/github/freeflowuniverse/herolib/docker/herolib')!
// workspace1.add_file(path: '${os.home_dir()}/code/github/freeflowuniverse/herolib/docker/herolib/.gitignore')!
// workspace1.add_file(path: '${os.home_dir()}/code/github/freeflowuniverse/herolib/docker/herolib/build.sh')!
// workspace1.add_file(path: '${os.home_dir()}/code/github/freeflowuniverse/herolib/docker/herolib/debug.sh')!

// workspace1.add_dir(path: '${os.home_dir()}/code/github/freeflowuniverse/herolib/docker/postgresql')!

// prompt := workspace1.prompt(
// 	text: 'Using the selected files, i want you to get all print statments'
// )

// println(prompt)
