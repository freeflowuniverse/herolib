
module openai

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.ui.console


__global (
    openai_global map[string]&OpenAI
    openai_default string
)

/////////FACTORY

@[params]
pub struct ArgsGet{
pub mut:
    name string
}

pub fn get(args_ ArgsGet) !&OpenAI  {
    return &OpenAI{}
}




//switch instance to be used for openai
pub fn switch(name string) {
    openai_default = name
}
