#!/usr/bin/env -S v -n -w -cg -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.biz.bizmodel
import os

const playbook_path = os.dir(@FILE) + '/playbook'
const build_path = os.join_path(os.dir(@FILE), '/docusaurus')

buildpath := '${os.home_dir()}/hero/var/mdbuild/bizmodel'

mut model := bizmodel.generate('test', playbook_path)!

println(model.sheet)
println(model.sheet.export()!)

model.sheet.export(path: '~/Downloads/test.csv')!
// model.sheet.export(path: '~/code/github/freeflowuniverse/starlight_template/src/content/test.csv')!

model.sheet
