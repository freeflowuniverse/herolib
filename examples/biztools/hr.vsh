#!/usr/bin/env -S v -n -w -cg -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.biz.bizmodel
import os

heroscript:="

!!bizmodel.employee_define bizname:'test' 
    descr:'Junior Engineer'
    nrpeople:'1:5,60:30'
    cost:'4000USD'
    indexation:'5%'
    department:'engineering'
    cost_percent_revenue:'4%'

!!bizmodel.department_define bizname:'test' 
    name:'engineering'
    descr:'Software Development Department'
    title:'Engineering Division'
"

bizmodel.play(heroscript:heroscript)!

mut bm:=bizmodel.get("test")!

bm.sheet.pprint(nr_columns:30)!