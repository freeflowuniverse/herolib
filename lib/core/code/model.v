module code

// Code is a list of statements
// pub type Code = []CodeItem

pub type CodeItem = Alias | Comment | CustomCode | Function | Import | Struct | Sumtype | Interface

// item for adding custom code in
pub struct CustomCode {
pub:
	text string
}

pub struct Comment {
pub:
	text     string
	is_multi bool
}

pub struct Sumtype {
pub:
	name        string
	description string
	types       []Type
}

pub struct Attribute {
pub:
	name    string // [name]
	has_arg bool
	arg     string // [name: arg]
}

pub struct Alias {
pub:
	name        string
	description string
	typ         Type
}
