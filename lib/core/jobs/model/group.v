module model

// Group represents a collection of members (users or other groups)
pub struct Group {
pub mut:
	guid        string   // unique id
	name        string   // name of the group
	description string   // optional description
	members     []string // can be other group or member which is defined by pubkey
}
