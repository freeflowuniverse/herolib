#!/usr/bin/env -S v -n -w -cg -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.biz.bizmodel
import freeflowuniverse.herolib.core.playbook
import os

heroscript := "

!!bizmodel.revenue_define bizname:'test' name:'oem1'
    descr:'OEM Deals'  
    revenue:'10:1000000EUR,15:3333,20:1200000'
    cogs_percent: '1:20%,20:15%'  cogs_delay:1

!!bizmodel.cost_define bizname:'test' name:'rent'
    descr:'Rent for office'  
    cost:'1:10000EUR,15:15000EUR'

!!bizmodel.cost_define bizname:'test' name:'marketing'
    descr:'Marketing Costs'  
    cost:'1:5000EUR,15:10000EUR'
"

// Create a new playbook with the heroscript text
mut pb := playbook.new(text: heroscript)!

// Play the bizmodel actions
bizmodel.play(mut pb)!

// Get the bizmodel and print it
mut bm := bizmodel.get('test')!

bm.sheet.pprint(nr_columns: 30)!