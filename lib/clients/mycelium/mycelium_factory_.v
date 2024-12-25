
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

pub fn get(args_ ArgsGet) !&Mycelium  {
    return &Mycelium{}
}




//switch instance to be used for mycelium
pub fn switch(name string) {
    mycelium_default = name
}
