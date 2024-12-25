module mycelium
import freeflowuniverse.herolib.data.paramsparser
import os

pub const version = '1.14.3'
const singleton = true
const default = true


//THIS THE THE SOURCE OF THE INFORMATION OF THIS FILE, HERE WE HAVE THE CONFIG OBJECT CONFIGURED AND MODELLED

$[heap]
pub struct Mycelium {
pub mut:
    name string = 'default'
    mail_from    string
    mail_password string @[secret]
    mail_port   int
    mail_server   string
    mail_username     string 
}



fn obj_init(obj_ Mycelium)!Mycelium{
    //never call get here, only thing we can do here is work on object itself
    mut obj:=obj_
    return obj
}



