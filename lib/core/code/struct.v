module code

import log
import os
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

// vgen_function generates a function statement for a function
pub fn (struct_ Struct) vgen() string {
	name := if struct_.generics.len > 0 {
		'${struct_.name}${vgen_generics(struct_.generics)}'
	} else {
		struct_.name
	}

	prefix := if struct_.is_pub {
		'pub'
	} else {
		''
	}

	priv_fields := struct_.fields.filter(!it.is_mut && !it.is_pub).map(it.vgen())
	pub_fields := struct_.fields.filter(!it.is_mut && it.is_pub).map(it.vgen())
	mut_fields := struct_.fields.filter(it.is_mut && !it.is_pub).map(it.vgen())
	pub_mut_fields := struct_.fields.filter(it.is_mut && it.is_pub).map(it.vgen())

	mut struct_str := $tmpl('templates/struct/struct.v.template')
	if false {
		result := os.execute_opt('echo "${struct_str.replace('$', '\$')}" | v fmt') or {
			log.debug(struct_str)
			panic(err)
		}
		return result.output
	}
	return struct_str
}


pub struct Interface {
pub mut:
	name        string
	description string
	is_pub      bool
	embeds      []Interface          @[str: skip]
	attrs       []Attribute
	fields      []StructField
	methods      []Function
}

pub fn (iface Interface) vgen() string {
	name := texttools.pascal_case(iface.name)

	prefix := if iface.is_pub {
		'pub'
	} else {
		''
	}

	mut fields := iface.fields.filter(!it.is_mut).map(it.vgen())
	mut mut_fields := iface.fields.filter(it.is_mut).map(it.vgen())

	fields << iface.methods.filter(!it.receiver.mutable).map(function_to_interface_field(it))
	mut_fields << iface.methods.filter(it.receiver.mutable).map(function_to_interface_field(it))

	mut iface_str := $tmpl('templates/interface/interface.v.template')
	if false {
		result := os.execute_opt('echo "${iface_str.replace('$', '\$')}" | v fmt') or {
			log.debug(iface_str)
			panic(err)
		}
		return result.output
	}
	return iface_str
}

pub fn function_to_interface_field(f Function) string {
	param_types := f.params.map(it.typ.vgen()).join(', ')
	return '${f.name}(${param_types}) ${f.result.typ.vgen()}'
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

pub fn (field StructField) vgen() string {
	mut vstr := field.Param.vgen()
	if field.description != '' {
		vstr += '// ${field.description}'
	}
	return vstr
}

pub fn (structure Struct) get_type_symbol() string {
	mut symbol := if structure.mod != '' {
		'${structure.mod.all_after_last('.')}.${structure.name}'
	} else {
		structure.name
	}
	if structure.generics.len > 0 {
		symbol = '${symbol}${vgen_generics(structure.generics)}'
	}

	return symbol
}

pub fn (s Struct) typescript() string {
	name := texttools.name_fix_pascal(s.name)
	fields := s.fields.map(it.typescript()).join_lines()
	return 'export interface ${name} {\n${fields}\n}'
}