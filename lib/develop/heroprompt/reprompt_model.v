module heroprompt

import freeflowuniverse.herolib.data.paramsparser
// import freeflowuniverse.herolib.data.encoderhero  // temporarily commented out
import freeflowuniverse.herolib.core.pathlib
import os

pub const version = '0.0.0'
const singleton = false
const default = true

// THIS THE THE SOURCE OF THE INFORMATION OF THIS FILE, HERE WE HAVE THE CONFIG OBJECT CONFIGURED AND MODELLED

pub struct HeropromptFile {
pub mut:
	content string
	path    pathlib.Path
	name    string
}

pub struct HeropromptDir {
pub mut:
	name  string
	path  pathlib.Path
	files []&HeropromptFile
	dirs  []&HeropromptDir
}

// pub fn (wsp HeropromptWorkspace) to_tag() {
// 	tag := HeropromptTags.file_map
// 	// We need to pass it to the template
// }

// // pub fn (dir HeropromptDir) to_tag() {
// // 	tag := HeropromptTags.file_content
// // 	// We need to pass it to the template
// // }

// pub fn (fil HeropromptFile) to_tag() {
// 	tag := HeropromptTags.file_content
// 	// We need to pass it to the template
// }

// pub enum HeropromptTags {
// 	file_map
// 	file_content
// 	user_instructions
// }

// your checking & initialization code if needed
fn obj_init(mycfg_ HeropromptWorkspace) !HeropromptWorkspace {
	mut mycfg := mycfg_
	return mycfg
}

/////////////NORMALLY NO NEED TO TOUCH

// TODO: Check the compiler issue with the encde/decode
pub fn heroscript_dumps(obj HeropromptWorkspace) !string {
	// return encoderhero.encode[HeropromptWorkspace](obj)!  // temporarily commented out
	return 'name: "${obj.name}"'
}

pub fn heroscript_loads(heroscript string) !HeropromptWorkspace {
	// mut obj := encoderhero.decode[HeropromptWorkspace](heroscript)!  // temporarily commented out
	obj := HeropromptWorkspace{
		name: 'default'
	}
	return obj
}
