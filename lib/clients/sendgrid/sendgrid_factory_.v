module sendgrid

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.ui.console

__global (
	sendgrid_global  map[string]&SendGrid
	sendgrid_default string
)

/////////FACTORY

@[params]
pub struct ArgsGet {
pub mut:
	name string
}

pub fn get(args_ ArgsGet) !&SendGrid {
	return &SendGrid{}
}

// switch instance to be used for sendgrid
pub fn switch(name string) {
	sendgrid_default = name
}
