
module mailclient

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.ui.console


__global (
    mailclient_global map[string]&MailClient
    mailclient_default string
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
        model.name = mailclient_default
    }
    if model.name == ""{
        model.name = "default"
    }
    return model
}

pub fn get(args_ ArgsGet) !&MailClient  {
    mut model := args_get(args_)
    if !(model.name in mailclient_global) {
        if model.name=="default"{
            if ! config_exists(model){
                if default{
                    config_save(model)!
                }
            }
            config_load(model)!
        }
    }
    return mailclient_global[model.name] or { 
            println(mailclient_global)
            panic("could not get config for mailclient with name:${model.name}") 
        }
}



fn config_exists(args_ ArgsGet) bool {
    mut model := args_get(args_)
    mut context:=base.context() or { panic("bug") }
    return context.hero_config_exists("mailclient",model.name)
}

fn config_load(args_ ArgsGet) ! {
    mut model := args_get(args_)
    mut context:=base.context()!
    mut heroscript := context.hero_config_get("mailclient",model.name)!
    play(heroscript:heroscript)!
}

fn config_save(args_ ArgsGet) ! {
    mut model := args_get(args_)
    mut context:=base.context()!
    context.hero_config_set("mailclient",model.name,heroscript_default()!)!
}


fn set(o MailClient)! {
    mut o2:=obj_init(o)!
    mailclient_global[o.name] = &o2
    mailclient_default = o.name
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
    
    mut install_actions := plbook.find(filter: 'mailclient.configure')!
    if install_actions.len > 0 {
        for install_action in install_actions {
            mut p := install_action.params
            mycfg:=cfg_play(p)!
            console.print_debug("install action mailclient.configure\n${mycfg}")
            set(mycfg)!
        }
    }


}




//switch instance to be used for mailclient
pub fn switch(name string) {
    mailclient_default = name
}
