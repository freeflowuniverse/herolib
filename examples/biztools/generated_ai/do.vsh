#!/usr/bin/env -S v -n -w -cg -gc none -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.biz.bizmodel
import os

bizmodel.play(heroscript_path: '${os.dir(@FILE)}/bizmodel.heroscript')!

mut m := bizmodel.get("threefold")!
m.sheet.pprint(nr_columns: 5)!