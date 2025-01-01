
module openai

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.ui.console


__global (
    openai_global map[string]&OpenAI
    openai_default string
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
        model.name = openai_default
    }
    if model.name == ""{
        model.name = "default"
    }
    return model
}

pub fn get(args_ ArgsGet) !&OpenAI  {
    mut args := args_get(args_)
    if !(args.name in openai_global) {
        if args.name=="default"{
            if ! config_exists(args){
                if default{
                    mut context:=base.context() or { panic("bug") }
                    context.hero_config_set("openai",model.name,heroscript_default()!)!
                }
            }
            load(args)!
        }
    }
    return openai_global[args.name] or { 
            println(openai_global)
            panic("could not get config for ${args.name} with name:${model.name}") 
        }
}





