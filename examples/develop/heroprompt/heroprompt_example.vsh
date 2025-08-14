#!/usr/bin/env -S v -n -w -gc none -cg -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.develop.heroprompt

import freeflowuniverse.herolib.core.playbook
import os


heroscript_config := '
	!!heropromptworkspace.configure name:"test workspace" path:"${os.home_dir()}/code/github/freeflowuniverse/herolib"
'
mut plbook := playbook.new(
	text: heroscript_config
)!

heroprompt.play(mut plbook)!

mut workspace1 := heroprompt.new_workspace(
	path: '${os.home_dir()}/code/github/freeflowuniverse/herolib'
)!

// mut workspace2 := heroprompt.get(
// 	name: 'test workspace'
// )!

mut dir1 := workspace1.add_dir(path: '${os.home_dir()}/code/github/freeflowuniverse/herolib/docker')!
dir1.select_file(name: 'docker_ubuntu_install.sh')!

mut dir2 := workspace1.add_dir(
	path: '${os.home_dir()}/code/github/freeflowuniverse/herolib/docker/herolib'
)!

dir2.select_file(name: '.gitignore')!
dir2.select_file(name: 'build.sh')!
file := dir2.select_file(name: 'debug.sh')!
// println(file.read()!)

mut dir3 := workspace1.add_dir(
	path:       '${os.home_dir()}/code/github/freeflowuniverse/herolib/docker/postgresql'
	select_all: true
)!

selected := workspace1.get_selected()

prompt := workspace1.prompt(
	text: 'Using the selected files, i want you to get all print statments'
)

println(prompt)
