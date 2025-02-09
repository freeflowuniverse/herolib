module zerodb

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.data.paramsparser

import freeflowuniverse.herolib.sysadmin.startupmanager
import freeflowuniverse.herolib.osal.zinit
import time

__global (
    zerodb_global map[string]&ZeroDB
    zerodb_default string
)

/////////FACTORY

@[params]
pub struct ArgsGet{
pub mut:
    name string
}

pub fn get(args_ ArgsGet) !&ZeroDB  {
    return &ZeroDB{}
}

@[params]
pub struct PlayArgs {
pub mut:
    heroscript string  //if filled in then plbook will be made out of it
    plbook     ?playbook.PlayBook 
    reset      bool
}

pub fn play(args_ PlayArgs) ! {
    
    mut args:=args_

    mut plbook := args.plbook or {
        playbook.new(text: args.heroscript)!
    }
    

    mut other_actions := plbook.find(filter: 'zerodb.')!
    for other_action in other_actions {
        if other_action.name in ["destroy","install","build"]{
            mut p := other_action.params
            reset:=p.get_default_false("reset")
            if other_action.name == "destroy" || reset{
                console.print_debug("install action zerodb.destroy")
                destroy()!
            }
            if other_action.name == "install"{
                console.print_debug("install action zerodb.install")
                install()!
            }            
        }
        if other_action.name in ["start","stop","restart"]{
            mut p := other_action.params
            name := p.get('name')!            
            mut zerodb_obj:=get(name:name)!
            console.print_debug("action object:\n${zerodb_obj}")
            if other_action.name == "start"{
                console.print_debug("install action zerodb.${other_action.name}")
                zerodb_obj.start()!
            }

            if other_action.name == "stop"{
                console.print_debug("install action zerodb.${other_action.name}")
                zerodb_obj.stop()!
            }
            if other_action.name == "restart"{
                console.print_debug("install action zerodb.${other_action.name}")
                zerodb_obj.restart()!
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


pub fn (mut self ZeroDB) start() ! {
    switch(self.name)
    if self.running()!{
        return
    }

    console.print_header('zerodb start')

    if ! installed()!{
        install()!
    }

    configure()!

    start_pre()!

    for zprocess in startupcmd()!{
        mut sm:=startupmanager_get(zprocess.startuptype)!

        console.print_debug('starting zerodb with ${zprocess.startuptype}...')

        sm.new(zprocess)!

        sm.start(zprocess.name)!
    }

    start_post()!

    for _ in 0 .. 50 {
        if self.running()! {
            return
        }
        time.sleep(100 * time.millisecond)
    }
    return error('zerodb did not install properly.')

}

pub fn (mut self ZeroDB) install_start(args InstallArgs) ! {
    switch(self.name)
    self.install(args)!
    self.start()!
}

pub fn (mut self ZeroDB) stop() ! {
    switch(self.name)
    stop_pre()!
    for zprocess in startupcmd()!{
        mut sm:=startupmanager_get(zprocess.startuptype)!
        sm.stop(zprocess.name)!
    }
    stop_post()!
}

pub fn (mut self ZeroDB) restart() ! {
    switch(self.name)
    self.stop()!
    self.start()!
}

pub fn (mut self ZeroDB) running() !bool {
    switch(self.name)

    //walk over the generic processes, if not running return
    for zprocess in startupcmd()!{
        mut sm:=startupmanager_get(zprocess.startuptype)!
        r:=sm.running(zprocess.name)!
        if r==false{
            return false
        }
    }
    return running()!
}

@[params]
pub struct InstallArgs{
pub mut:
    reset bool
}

pub fn (mut self ZeroDB) install(args InstallArgs) ! {
    switch(self.name)
    if args.reset || (!installed()!) {
        install()!
    }    
}

pub fn (mut self ZeroDB) build() ! {
    switch(self.name)
    build()!
}

pub fn (mut self ZeroDB) destroy() ! {
    switch(self.name)
    self.stop() or {}
    destroy()!
}



//switch instance to be used for zerodb
pub fn switch(name string) {
    zerodb_default = name
}


//helpers

@[params]
pub struct DefaultConfigArgs{
    instance string = 'default'
}
