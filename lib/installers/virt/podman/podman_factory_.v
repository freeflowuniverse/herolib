module podman

import freeflowuniverse.herolib.sysadmin.startupmanager
import freeflowuniverse.herolib.osal.zinit
import freeflowuniverse.herolib.ui.console
import time

__global (
	podman_global  map[string]&PodmanInstaller
	podman_default string
)

/////////FACTORY

@[params]
pub struct ArgsGet {
pub mut:
	name string = 'default'
}

pub fn get(args_ ArgsGet) !&PodmanInstaller {
	return &PodmanInstaller{}
}

@[params]
pub struct InstallArgs {
pub mut:
	reset bool
}

pub fn (mut self PodmanInstaller) install(args InstallArgs) ! {
	switch(self.name)
	install()!
}

pub fn (mut self PodmanInstaller) installed(args InstallArgs) bool {
	switch(self.name)
	return installed()
}

pub fn (mut self PodmanInstaller) build() ! {
	switch(self.name)
	build()!
}

pub fn (mut self PodmanInstaller) destroy() ! {
	switch(self.name)
	destroy()!
}

// switch instance to be used for podman
pub fn switch(name string) {
	podman_default = name
}
