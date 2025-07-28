#!/usr/bin/env -S v -n -w -cg -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.biz.bizmodel
import os


heroscript := os.join_path(os.dir(@FILE), 'examples/complete.heroscript')

// Execute the script and print results
bizmodel.play(heroscript_path:heroscript)!
mut bm := bizmodel.get("threefold")!
bm.sheet.pprint(nr_columns: 10)!
