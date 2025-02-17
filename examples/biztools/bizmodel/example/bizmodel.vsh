#!/usr/bin/env -S v -n -w -cg -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run

//#!/usr/bin/env -S v -cg -enable-globals run
import freeflowuniverse.herolib.data.doctree
import freeflowuniverse.herolib.biz.bizmodel
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.core.playcmds
import freeflowuniverse.herolib.web.mdbook
import os

const wikipath = os.dir(@FILE) + '/wiki'
const summarypath = os.dir(@FILE) + '/wiki/summary.md'
buildpath := '${os.home_dir()}/hero/var/mdbuild/bizmodel'

mut m := bizmodel.getset("example")!
m.workdir = wikipath
m.play(mut playbook.new(path: wikipath)!)!
m.export_sheets()!
bizmodel.set(m)

// // execute the actions so we have the info populated
// // playcmds.run(mut plb,false)!


// // just run the doctree & mdbook and it should
// // load the doctree, these are all collections
// mut tree := doctree.new(name: 'bizmodel')!
// tree.scan(path: wikipath)!
// tree.export(dest: buildpath, reset: true)!

// // mut bm:=bizmodel.get("test")!
// // println(bm)

// mut mdbooks := mdbook.get()!
// mdbooks.generate(
// 	name:         'bizmodel'
// 	summary_path: summarypath
// 	doctree_path: buildpath
// 	title:        'bizmodel example'
// )!
// mdbook.book_open('bizmodel')!
