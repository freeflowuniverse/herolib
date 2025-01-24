module code

import freeflowuniverse.herolib.core.texttools

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

pub struct StructField {
	Param
pub mut:
	comments    []Comment
	attrs       []Attribute
	description string
	default     string
	is_pub      bool
	is_mut      bool
	is_ref      bool
	anon_struct Struct      @[str: skip] // sometimes fields may hold anonymous structs
	structure   Struct      @[str: skip]
}

pub fn (s Struct) typescript() string {
	name := texttools.name_fix_pascal(s.name)
	fields := s.fields.map(it.typescript()).join_lines()
	return 'export interface ${name} {\n${fields}\n}'
}
