
module garage_s3

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.ui.console

import freeflowuniverse.herolib.sysadmin.startupmanager
import freeflowuniverse.herolib.osal.zinit
import time

__global (
    garage_s3_global map[string]&GarageS3
    garage_s3_default string
)

/////////FACTORY

@[params]
pub struct ArgsGet{
pub mut:
    name string
}

pub fn get(args_ ArgsGet) !&GarageS3  {
    return &GarageS3{}
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


pub fn (mut self GarageS3) start() ! {
    switch(self.name)
    if self.running()!{
        return
    }

    console.print_header('garage_s3 start')

    if ! installed()!{
        install()!
    }

    configure()!

    start_pre()!

    for zprocess in startupcmd()!{
        mut sm:=startupmanager_get(zprocess.startuptype)!

        console.print_debug('starting garage_s3 with ${zprocess.startuptype}...')

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
    return error('garage_s3 did not install properly.')

}

pub fn (mut self GarageS3) install_start(model InstallArgs) ! {
    switch(self.name)
    self.install(model)!
    self.start()!
}

pub fn (mut self GarageS3) stop() ! {
    switch(self.name)
    stop_pre()!
    for zprocess in startupcmd()!{
        mut sm:=startupmanager_get(zprocess.startuptype)!
        sm.stop(zprocess.name)!
    }
    stop_post()!
}

pub fn (mut self GarageS3) restart() ! {
    switch(self.name)
    self.stop()!
    self.start()!
}

pub fn (mut self GarageS3) running() !bool {
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

pub fn (mut self GarageS3) install(model InstallArgs) ! {
    switch(self.name)
    if model.reset || (!installed()!) {
        install()!
    }    
}

pub fn (mut self GarageS3) build() ! {
    switch(self.name)
    build()!
}

pub fn (mut self GarageS3) destroy() ! {
    switch(self.name)
    self.stop() or {}
    destroy()!
}



//switch instance to be used for garage_s3
pub fn switch(name string) {
    garage_s3_default = name
}
