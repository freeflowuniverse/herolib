#!/usr/bin/env -S v -n -w -cg -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run

//#!/usr/bin/env -S v -cg -enable-globals run
import freeflowuniverse.herolib.biz.bizmodel
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.core.playcmds
import os

// TODO: need to fix wrong location
const playbook_path = os.dir(@FILE) + '/playbook'
const build_path = os.join_path(os.dir(@FILE), '/docusaurus')

buildpath := '${os.home_dir()}/hero/var/mdbuild/bizmodel'

mut model := bizmodel.getset('example')!
model.workdir = build_path
model.play(mut playbook.new(path: playbook_path)!)!

println(model.sheet)
println(model.sheet.export()!)

// model.sheet.export(path:"~/Downloads/test.csv")!
// model.sheet.export(path:"~/code/github/freeflowuniverse/starlight_template/src/content/test.csv")!

report := model.new_report(
	name:  'example_report'
	title: 'Example Business Model'
)!

report.export(
	path:      build_path
	overwrite: true
	format:    .docusaurus
)!
