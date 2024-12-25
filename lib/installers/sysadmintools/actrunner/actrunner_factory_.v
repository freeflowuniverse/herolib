
module actrunner

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.ui.console

import freeflowuniverse.herolib.sysadmin.startupmanager
import freeflowuniverse.herolib.osal.zinit
import time

__global (
    actrunner_global map[string]&ActRunner
    actrunner_default string
)

/////////FACTORY

@[params]
pub struct ArgsGet{
pub mut:
    name string
}

pub fn get(args_ ArgsGet) !&ActRunner  {
    return &ActRunner{}
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


pub fn (mut self ActRunner) start() ! {
    switch(self.name)
    if self.running()!{
        return
    }

    console.print_header('actrunner start')

    if ! installed()!{
        install()!
    }

    configure()!

    start_pre()!

    for zprocess in startupcmd()!{
        mut sm:=startupmanager_get(zprocess.startuptype)!

        console.print_debug('starting actrunner with ${zprocess.startuptype}...')

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
    return error('actrunner did not install properly.')

}

pub fn (mut self ActRunner) install_start(model InstallArgs) ! {
    switch(self.name)
    self.install(model)!
    self.start()!
}

pub fn (mut self ActRunner) stop() ! {
    switch(self.name)
    stop_pre()!
    for zprocess in startupcmd()!{
        mut sm:=startupmanager_get(zprocess.startuptype)!
        sm.stop(zprocess.name)!
    }
    stop_post()!
}

pub fn (mut self ActRunner) restart() ! {
    switch(self.name)
    self.stop()!
    self.start()!
}

pub fn (mut self ActRunner) running() !bool {
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

pub fn (mut self ActRunner) install(model InstallArgs) ! {
    switch(self.name)
    if model.reset || (!installed()!) {
        install()!
    }    
}

pub fn (mut self ActRunner) build() ! {
    switch(self.name)
    build()!
}

pub fn (mut self ActRunner) destroy() ! {
    switch(self.name)
    self.stop() or {}
    destroy()!
}



//switch instance to be used for actrunner
pub fn switch(name string) {
    actrunner_default = name
}
