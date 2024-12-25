
module postgres

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.ui.console


__global (
    postgres_global map[string]&PostgresClient
    postgres_default string
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




//switch instance to be used for postgres
pub fn switch(name string) {
    postgres_default = name
}
