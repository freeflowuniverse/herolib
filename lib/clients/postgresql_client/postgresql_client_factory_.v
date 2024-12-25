
module postgresql_client

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.ui.console


__global (
    postgresql_client_global map[string]&PostgresClient
    postgresql_client_default string
)

/////////FACTORY

@[params]
pub struct ArgsGet{
pub mut:
    name string
}

pub fn get(args_ ArgsGet) !&PostgresClient  {
    return &PostgresClient{}
}




//switch instance to be used for postgresql_client
pub fn switch(name string) {
    postgresql_client_default = name
}
