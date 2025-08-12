module reprompt

import freeflowuniverse.herolib.data.paramsparser
import freeflowuniverse.herolib.data.encoderhero
import freeflowuniverse.herolib.core.pathlib
import os

pub const version = '0.0.0'
const singleton = false
const default = true

// THIS THE THE SOURCE OF THE INFORMATION OF THIS FILE, HERE WE HAVE THE CONFIG OBJECT CONFIGURED AND MODELLED

@[heap]
pub struct RepromptWorkspace {
pub mut:
	name string = 'default'
	dirs []RepromptDir
}

pub struct RepromptDir {
pub mut:
	path       pathlib.Path
	selections []string // paths selected in the RepromptDir
}


// your checking & initialization code if needed
fn obj_init(mycfg_ RepromptWorkspace) !RepromptWorkspace {
	mut mycfg := mycfg_
	if mycfg.password == '' && mycfg.secret == '' {
		return error('password or secret needs to be filled in for ${mycfg.name}')
	}
	return mycfg
}

/////////////NORMALLY NO NEED TO TOUCH

pub fn heroscript_dumps(obj RepromptWorkspace) !string {
	//create heroscript following template
	//check for our homedir on our machine and replace in the heroscript to @HOME in path
	return encoderhero.encode[RepromptWorkspace](obj)!
}

pub fn heroscript_loads(heroscript string) !RepromptWorkspace {
	//TODO: parse heroscript populate RepromptWorkspace
	mut obj := encoderhero.decode[RepromptWorkspace](heroscript)!
	return obj
}
