
module tailwind

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.ui.console

import freeflowuniverse.herolib.sysadmin.startupmanager
import freeflowuniverse.herolib.osal.zinit
import time

__global (
    tailwind_global map[string]&Tailwind
    tailwind_default string
)

/////////FACTORY



@[params]
pub struct ArgsGet{
pub mut:
    name string
}

fn args_get (args_ ArgsGet) ArgsGet {
    mut model:=args_
    if model.name == ""{
        model.name = tailwind_default
    }
    if model.name == ""{
        model.name = "default"
    }
    return model
}

pub fn get(args_ ArgsGet) !&Tailwind  {
    mut args := args_get(args_)
    if !(args.name in tailwind_global) {
        if args.name=="default"{
            if ! config_exists(args){
                if default{
                    mut context:=base.context() or { panic("bug") }
                    context.hero_config_set("tailwind",model.name,heroscript_default()!)!
                }
            }
            load(args)!
        }
    }
    return tailwind_global[args.name] or { 
            println(tailwind_global)
            panic("could not get config for ${args.name} with name:${model.name}") 
        }
}




////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////# LIVE CYCLE MANAGEMENT FOR INSTALLERS ///////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////




@[params]
pub struct InstallArgs{
pub mut:
    reset bool
}


//switch instance to be used for tailwind
pub fn switch(name string) {
    tailwind_default = name
}


pub fn (mut self Tailwind) install(args InstallArgs) ! {
    switch(self.name)
    if args.reset {
        destroy_()!    
    }   
    if ! (installed_()!){
        install_()! 
    }
}


pub fn (mut self Tailwind) destroy() ! {
    switch(self.name)
    destroy_()!
}




