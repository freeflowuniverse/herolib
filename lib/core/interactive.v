module core

import base

//check if we are interactive in current context
pub fn interactive()!bool{
	mut c:=base.context()!
	if c.config.interactive{
		return true
	}	
	return false
}

pub fn interactive_set()!{
	mut c:=base.context()!
	c.config.interactive = true
}
