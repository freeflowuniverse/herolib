
module rclone

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.data.encoderhero


__global (
    rclone_global map[string]&RCloneClient
    rclone_default string
)

/////////FACTORY




//set the model in mem and the config on the filesystem
pub fn set(o RCloneClient)! {
    mut o2:=obj_init(o)!
    rclone_global[o.name] = &o2
    rclone_default = o.name
}

//check we find the config on the filesystem
pub fn exists(args_ ArgsGet) bool {
    mut model := args_get(args_)
    mut context:=base.context() or { panic("bug") }
    return context.hero_config_exists("rclone",model.name)
}

//load the config error if it doesn't exist
pub fn load(args_ ArgsGet) ! {
    mut model := args_get(args_)
    mut context:=base.context()!
    mut heroscript := context.hero_config_get("rclone",model.name)!
    play(heroscript:heroscript)!
}

//save the config to the filesystem in the context
pub fn save(o RCloneClient)! {
    mut context:=base.context()!
    heroscript := encoderhero.encode[RCloneClient](o)!
    context.hero_config_set("rclone",model.name,heroscript)!
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
    
    mut configure_actions := plbook.find(filter: 'rclone.configure')!
    if configure_actions.len > 0 {
        for config_action in configure_actions {
            mut p := config_action.params
            mycfg:=cfg_play(p)!
            console.print_debug("install action rclone.configure\n${mycfg}")
            set(mycfg)!
            save(mycfg)!
        }
    }


}




