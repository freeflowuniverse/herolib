
module mycelium

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.ui.console


__global (
    mycelium_global map[string]&Mycelium
    mycelium_default string
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
        model.name = mycelium_default
    }
    if model.name == ""{
        model.name = "default"
    }
    return model
}

pub fn get(args_ ArgsGet) !&Mycelium  {
    mut model := args_get(args_)
    if !(model.name in mycelium_global) {
        if model.name=="default"{
            if ! config_exists(model){
                if default{
                    config_save(model)!
                }
            }
            config_load(model)!
        }
    }
    return mycelium_global[model.name] or { 
            println(mycelium_global)
            panic("could not get config for mycelium with name:${model.name}") 
        }
}



fn config_exists(args_ ArgsGet) bool {
    mut model := args_get(args_)
    mut context:=base.context() or { panic("bug") }
    return context.hero_config_exists("mycelium",model.name)
}

fn config_load(args_ ArgsGet) ! {
    mut model := args_get(args_)
    mut context:=base.context()!
    mut heroscript := context.hero_config_get("mycelium",model.name)!
    play(heroscript:heroscript)!
}

fn config_save(args_ ArgsGet) ! {
    mut model := args_get(args_)
    mut context:=base.context()!
    context.hero_config_set("mycelium",model.name,heroscript_default()!)!
}


fn set(o Mycelium)! {
    mut o2:=obj_init(o)!
    mycelium_global[o.name] = &o2
    mycelium_default = o.name
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
    
    mut install_actions := plbook.find(filter: 'mycelium.configure')!
    if install_actions.len > 0 {
        for install_action in install_actions {
            mut p := install_action.params
            mycfg:=cfg_play(p)!
            console.print_debug("install action mycelium.configure\n${mycfg}")
            set(mycfg)!
        }
    }


}




//switch instance to be used for mycelium
pub fn switch(name string) {
    mycelium_default = name
}
