module base

import freeflowuniverse.herolib.data.ourtime

// our attempt to make a message object which can be used for email as well as chat
pub struct Base {
pub mut:
	id            u32
	creation_time ourtime.OurTime
	mod_time      ourtime.OurTime // Last modified time
	comments      []u32
}
