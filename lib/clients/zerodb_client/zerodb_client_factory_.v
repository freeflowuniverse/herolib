
module zerodb_client

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.ui.console


__global (
    zerodb_client_global map[string]&ZeroDBClient
    zerodb_client_default string
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




//switch instance to be used for zerodb_client
pub fn switch(name string) {
    zerodb_client_default = name
}
