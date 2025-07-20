import freeflowuniverse.herolib.biz.bizmodel
import os

fn main() ! {
    heroscript:="

    Next will define an OEM product in month 10, 1 Million EUR, ... cogs is a percent which is 20% at start but goes to 10% after 20 months.

    !!bizmodel.revenue_define bizname:'test' name:'oem1'
        descr:'OEM Deals'
        revenue:'10:1000000EUR,15:3333,20:1200000'
        cogs_percent: '1:20%,20:10%'


    This time we have the cogs defined in fixed manner, the default currency is USD doesn't have to be mentioned.

    !!bizmodel.revenue_define bizname:'test' name:'oem2'
        descr:'OEM Deals'
        revenue:'10:1000000EUR,15:3333,20:1200000'
        cogs: '10:100000,15:1000,20:120000'
    "
    
    bizmodel.play(heroscript:heroscript)!
    
    mut bm:=bizmodel.get("test")!
    
    bm.sheet.pprint()!
}