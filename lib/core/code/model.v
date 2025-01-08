module code

// Code is a list of statements
// pub type Code = []CodeItem

pub type CodeItem = Alias | Comment | CustomCode | Function | Import | Struct | Sumtype

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

pub struct Struct {
pub mut:
	name        string
	description string
	mod         string
	is_pub      bool
	embeds      []Struct          @[str: skip]
	generics    map[string]string @[str: skip]
	attrs       []Attribute
	fields      []StructField
}

pub struct Sumtype {
pub:
	name        string
	description string
	types       []Type
}

pub struct StructField {
pub mut:
	comments    []Comment
	attrs       []Attribute
	name        string
	description string
	default     string
	is_pub      bool
	is_mut      bool
	is_ref      bool
	anon_struct Struct      @[str: skip] // sometimes fields may hold anonymous structs
	typ         Type
	structure   Struct      @[str: skip]
}

pub struct Attribute {
pub:
	name    string // [name]
	has_arg bool
	arg     string // [name: arg]
}

pub fn parse_param(code_ string) !Param {
	mut code := code_.trim_space()

	if code == '!' {
		return Param{is_result: true}
	} else if code == '?' {
		return Param{is_optional: true}
	}

	is_mut := code.starts_with('mut ')
	if is_mut {
		code = code.trim_string_left('mut ').trim_space()
	}
	split := code.split(' ').filter(it != '')

	if split.len == 1 {
		// means anonymous param
		return Param{
			typ: type_from_symbol(split[0])
			mutable: is_mut
		}
	}
	if split.len != 2 {
		return error('invalid param format: ${code_}')
	}
	return Param{
		name: split[0]
		typ: type_from_symbol(split[1])
		mutable: is_mut
	}
}

pub struct Alias {
pub:
	name        string
	description string
	typ         Type
}
