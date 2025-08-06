#!/usr/bin/env -S v -n -w -cg -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run

//#!/usr/bin/env -S v -cg -enable-globals run
import freeflowuniverse.herolib.biz.bizmodel
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.core.playcmds
import os

// heroscript := os.join_path(os.dir(@FILE), 'examples/full')
// // Execute the script and print results
// bizmodel.play(heroscript_path:heroscript)!

heroscript := os.join_path(os.dir(@FILE), 'examples/complete.heroscript')
// Execute the script and print results
bizmodel.play(heroscript_path: heroscript)!

mut bm := bizmodel.get('threefold')!
bm.sheet.pprint(nr_columns: 10)!

// buildpath := '${os.home_dir()}/hero/var/mdbuild/bizmodel'
// println("buildpath: ${buildpath}")

// model.play(mut playbook.new(path: playbook_path)!)!

// println(model.sheet)
// println(model.sheet.export()!)

// model.sheet.export(path:"~/Downloads/test.csv")!
// model.sheet.export(path:"~/code/github/freeflowuniverse/starlight_template/src/content/test.csv")!

bm.export(
	name:  'example_report'
	title: 'Example Business Model'
	path:  '/tmp/bizmodel_export'
)!
