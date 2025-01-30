module code

import os
import log
import freeflowuniverse.herolib.core.texttools

pub struct WriteCode {
	destination string
}

interface ICodeItem {
	vgen() string
}

pub fn vgen(code []CodeItem) string {
	mut str := ''
	for item in code {
		if item is Function {
			str += '\n${item.vgen()}'
		}
		if item is Struct {
			str += '\n${item.vgen()}'
		}
		if item is CustomCode {
			str += '\n${item.vgen()}'
		}
	}
	return str
}

// pub fn (code Code) vgen() string {
// 	return code.items.map(it.vgen()).join_lines()
// }

// vgen_import generates an import statement for a given type
pub fn (import_ Import) vgen() string {
	types_str := if import_.types.len > 0 {
		'{${import_.types.join(', ')}}'
	} else {
		''
	} // comma separated string list of  types
	return 'import ${import_.mod} ${types_str}'
}

// TODO: enfore that cant be both mutable and shared
pub fn (t Type) vgen() string {
	return t.symbol()
}

pub fn (field StructField) vgen() string {
	symbol := field.get_type_symbol()
	mut vstr := '${field.name} ${symbol}'
	if field.description != '' {
		vstr += '// ${field.description}'
	}
	return vstr
}

pub fn (field StructField) get_type_symbol() string {
	mut field_str := if field.structure.name != '' {
		field.structure.get_type_symbol()
	} else {
		field.typ.symbol()
	}

	if field.is_ref {
		field_str = '&${field_str}'
	}

	return field_str
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

pub fn vgen_generics(generics map[string]string) string {
	if generics.keys().len == 0 {
		return ''
	}
	mut vstr := '['
	for key, val in generics {
		vstr += if val != '' { val } else { key }
	}
	return '${vstr}]'
}

// vgen_function generates a function statement for a function
pub fn (function Function) vgen(options WriteOptions) string {
	mut params_ := function.params.clone()
	optionals := function.params.filter(it.is_optional)
	options_struct := Struct{
		name: '${texttools.name_fix_snake_to_pascal(function.name)}Options'
		attrs: [Attribute{
			name: 'params'
		}]
		fields: optionals.map(StructField{
			name: it.name
			description: it.description
			typ: it.typ
		})
	}
	if optionals.len > 0 {
		params_ << Param{
			name: 'options'
			typ: type_from_symbol(options_struct.name)
		}
	}

	params := params_.filter(!it.is_optional).map(it.vgen()).join(', ')

	receiver := if function.receiver.vgen().trim_space() != '' {
		'(${function.receiver.vgen()})'
	} else {''}

	// generate anon result param
	result := Param{...function.result,
		name: ''
	}.vgen()

	mut function_str := $tmpl('templates/function/function.v.template')
	
	// if options.format {
	// 	result := os.execute_opt('echo "${function_str.replace('$', '\\$')}" | v fmt') or {
	// 		panic('${function_str}\n${err}')
	// 	}
	// 	function_str = result.output
	// }
	function_str = function_str.split_into_lines().filter(!it.starts_with('import ')).join('\n')

	return if options_struct.fields.len != 0 {
		'${options_struct.vgen()}\n${function_str}'
	} else {
		function_str
	}
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

	priv_fields := struct_.fields.filter(!it.is_mut && !it.is_pub).map(generate_struct_field(it))
	pub_fields := struct_.fields.filter(!it.is_mut && it.is_pub).map(generate_struct_field(it))
	mut_fields := struct_.fields.filter(it.is_mut && !it.is_pub).map(generate_struct_field(it))
	pub_mut_fields := struct_.fields.filter(it.is_mut && it.is_pub).map(generate_struct_field(it))

	mut struct_str := $tmpl('templates/struct/struct.v.template')
	if false {
		result := os.execute_opt('echo "${struct_str.replace('$', '\$')}" | v fmt') or {
			log.debug(struct_str)
			panic(err)
		}
		return result.output
	}
	return struct_str
	// mut struct_str := $tmpl('templates/struct/struct.v.template')
	// return struct_str
	// result := os.execute_opt('echo "${struct_str.replace('$', '\$')}" | v fmt') or {panic(err)}
	// return result.output
}

pub fn generate_struct_field(field StructField) string {
	symbol := field.get_type_symbol()
	mut vstr := '${field.name} ${symbol}'
	if field.description != '' {
		vstr += '// ${field.description}'
	}
	return vstr
}

pub fn (custom CustomCode) vgen() string {
	return custom.text
}

@[params]
pub struct WriteOptions {
pub:
	format    bool
	overwrite bool
	document  bool
	prefix    string
	compile bool // whether to compile the written code
	test bool // whether to test the written code
}
