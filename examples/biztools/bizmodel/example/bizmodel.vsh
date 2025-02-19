#!/usr/bin/env -S v -n -w -cg -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run

//#!/usr/bin/env -S v -cg -enable-globals run
import freeflowuniverse.herolib.data.doctree
import freeflowuniverse.herolib.biz.bizmodel
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.core.playcmds
import freeflowuniverse.herolib.web.mdbook
import os

const wikipath = os.dir(@FILE) + '/wiki'
const build_path = os.join_path(os.dir(@FILE), '/build')
const summarypath = os.dir(@FILE) + '/wiki/summary.md'
buildpath := '${os.home_dir()}/hero/var/mdbuild/bizmodel'

mut model := bizmodel.getset("example")!
model.workdir = wikipath
model.play(mut playbook.new(path: wikipath)!)!

report := model.new_report(
	name: 'example_report'
	title: 'Example Business Model'
)!

report.export(
	path: build_path
	overwrite: true
	format: .docusaurus
)!