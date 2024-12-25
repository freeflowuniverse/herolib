
module zdb

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.ui.console


__global (
    zdb_global map[string]&ZeroDBClient
    zdb_default string
)

/////////FACTORY

@[params]
pub struct ArgsGet{
pub mut:
    name string
}

pub fn get(args_ ArgsGet) !&ZeroDBClient  {
    return &ZeroDBClient{}
}




//switch instance to be used for zdb
pub fn switch(name string) {
    zdb_default = name
}
