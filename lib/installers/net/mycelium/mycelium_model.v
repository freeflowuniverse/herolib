module mycelium
import freeflowuniverse.herolib.data.paramsparser
import freeflowuniverse.herolib.data.encoderhero
import os

pub const version = '0.0.0'
const singleton = false
const default = true

//THIS THE THE SOURCE OF THE INFORMATION OF THIS FILE, HERE WE HAVE THE CONFIG OBJECT CONFIGURED AND MODELLED
@[heap]
pub struct MyceliumInstaller {
pub mut:
    name string = 'default'
    homedir    string
    configpath string
    username   string
    password   string @[secret]
    title      string
    host       string
    port       int
}



//your checking & initialization code if needed
fn obj_init(mycfg_ MyceliumInstaller)!MyceliumInstaller{
    mut mycfg:=mycfg_
    if mycfg.password == '' && mycfg.secret == '' {
        return error('password or secret needs to be filled in for ${mycfg.name}')
    }    
    return mycfg
}

//called before start if done
fn configure() ! {
    //mut installer := get()!
}


/////////////NORMALLY NO NEED TO TOUCH

pub fn heroscript_dumps(obj MyceliumInstaller) !string {
    return encoderhero.encode[MyceliumInstaller ](obj)!
}

pub fn heroscript_loads(heroscript string) !MyceliumInstaller {
    mut obj := encoderhero.decode[MyceliumInstaller](heroscript)!
    return obj
}
