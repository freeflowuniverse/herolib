
module meilisearch

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.data.encoderhero


__global (
    meilisearch_global map[string]&MeilisearchClient
    meilisearch_default string
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
        model.name = meilisearch_default
    }
    if model.name == ""{
        model.name = "default"
    }
    return model
}

pub fn get(args_ ArgsGet) !&MeilisearchClient  {
    mut args := args_get(args_)
    if !(args.name in meilisearch_global) {
        if args.name=="default"{
            if ! config_exists(args){
                if default{
                    mut context:=base.context() or { panic("bug") }
                    context.hero_config_set("meilisearch",model.name,heroscript_default()!)!
                }
            }
            load(args)!
        }
    }
    return meilisearch_global[args.name] or { 
            println(meilisearch_global)
            panic("could not get config for ${args.name} with name:${model.name}") 
        }
}



//set the model in mem and the config on the filesystem
pub fn set(o MeilisearchClient)! {
    mut o2:=obj_init(o)!
    meilisearch_global[o.name] = &o2
    meilisearch_default = o.name
}

//check we find the config on the filesystem
pub fn exists(args_ ArgsGet) bool {
    mut model := args_get(args_)
    mut context:=base.context() or { panic("bug") }
    return context.hero_config_exists("meilisearch",model.name)
}

//load the config error if it doesn't exist
pub fn load(args_ ArgsGet) ! {
    mut model := args_get(args_)
    mut context:=base.context()!
    mut heroscript := context.hero_config_get("meilisearch",model.name)!
    play(heroscript:heroscript)!
}

//save the config to the filesystem in the context
pub fn save(o MeilisearchClient)! {
    mut context:=base.context()!
    heroscript := encoderhero.encode[MeilisearchClient](o)!
    context.hero_config_set("meilisearch",model.name,heroscript)!
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
    
    mut configure_actions := plbook.find(filter: 'meilisearch.configure')!
    if configure_actions.len > 0 {
        for config_action in configure_actions {
            mut p := config_action.params
            mycfg:=cfg_play(p)!
            console.print_debug("install action meilisearch.configure\n${mycfg}")
            set(mycfg)!
            save(mycfg)!
        }
    }


}




