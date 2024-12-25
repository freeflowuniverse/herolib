
module rclone

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.ui.console

import freeflowuniverse.herolib.sysadmin.startupmanager
import freeflowuniverse.herolib.osal.zinit
import time

__global (
    rclone_global map[string]&RClone
    rclone_default string
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
        model.name = rclone_default
    }
    if model.name == ""{
        model.name = "default"
    }
    return model
}

pub fn get(args_ ArgsGet) !&RClone  {
    mut model := args_get(args_)
    if !(model.name in rclone_global) {
        if model.name=="default"{
            if ! config_exists(model){
                if default{
                    config_save(model)!
                }
            }
            config_load(model)!
        }
    }
    return rclone_global[model.name] or { 
            println(rclone_global)
            panic("could not get config for rclone with name:${model.name}") 
        }
}



fn config_exists(args_ ArgsGet) bool {
    mut model := args_get(args_)
    mut context:=base.context() or { panic("bug") }
    return context.hero_config_exists("rclone",model.name)
}

fn config_load(args_ ArgsGet) ! {
    mut model := args_get(args_)
    mut context:=base.context()!
    mut heroscript := context.hero_config_get("rclone",model.name)!
    play(heroscript:heroscript)!
}

fn config_save(args_ ArgsGet) ! {
    mut model := args_get(args_)
    mut context:=base.context()!
    context.hero_config_set("rclone",model.name,heroscript_default()!)!
}


fn set(o RClone)! {
    mut o2:=obj_init(o)!
    rclone_global[o.name] = &o2
    rclone_default = o.name
}


@[params]
pub struct PlayArgs {
pub mut:
    heroscript string  //if filled in then plbook will be made out of it
    plbook     ?playbook.PlayBook 
    reset      bool
}

pub fn play(args_ PlayArgs) ! {
    
    mut model:=args_

    if model.heroscript == "" {
        model.heroscript = heroscript_default()!
    }
    mut plbook := model.plbook or {
        playbook.new(text: model.heroscript)!
    }
    
    mut install_actions := plbook.find(filter: 'rclone.configure')!
    if install_actions.len > 0 {
        for install_action in install_actions {
            mut p := install_action.params
            mycfg:=cfg_play(p)!
            console.print_debug("install action rclone.configure\n${mycfg}")
            set(mycfg)!
        }
    }

    mut other_actions := plbook.find(filter: 'rclone.')!
    for other_action in other_actions {
        if other_action.name in ["destroy","install","build"]{
            mut p := other_action.params
            reset:=p.get_default_false("reset")
            if other_action.name == "destroy" || reset{
                console.print_debug("install action rclone.destroy")
                destroy()!
            }
            if other_action.name == "install"{
                console.print_debug("install action rclone.install")
                install()!
            }            
        }
    }

}



////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////# LIVE CYCLE MANAGEMENT FOR INSTALLERS ///////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

fn startupmanager_get(cat zinit.StartupManagerType) !startupmanager.StartupManager {
    // unknown
    // screen
    // zinit
    // tmux
    // systemd
    match cat{
        .zinit{
            console.print_debug("startupmanager: zinit")
            return startupmanager.get(cat:.zinit)!
        }
        .systemd{
            console.print_debug("startupmanager: systemd")
            return startupmanager.get(cat:.systemd)!
        }else{
            console.print_debug("startupmanager: auto")
            return startupmanager.get()!
        }
    }
}

//load from disk and make sure is properly intialized
pub fn (mut self RClone) reload() ! {
    switch(self.name)
    self=obj_init(self)!
}


@[params]
pub struct InstallArgs{
pub mut:
    reset bool
}

pub fn (mut self RClone) install(model InstallArgs) ! {
    switch(self.name)
    if model.reset || (!installed()!) {
        install()!
    }    
}


pub fn (mut self RClone) destroy() ! {
    switch(self.name)
    destroy()!
}



//switch instance to be used for rclone
pub fn switch(name string) {
    rclone_default = name
}
