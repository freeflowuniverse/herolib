
module nodejs

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.ui.console

import freeflowuniverse.herolib.sysadmin.startupmanager
import freeflowuniverse.herolib.osal.zinit
import time

__global (
    nodejs_global map[string]&NodeJS
    nodejs_default string
)

/////////FACTORY





////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////# LIVE CYCLE MANAGEMENT FOR INSTALLERS ///////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////




@[params]
pub struct InstallArgs{
pub mut:
    reset bool
}


pub fn install(args InstallArgs) ! {
    if args.reset {
        destroy()!
    }    
    if ! (installed_()!){
        install_()!    
    }
}

pub fn destroy() ! {
    destroy_()!
}






