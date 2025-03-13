module code

import freeflowuniverse.herolib.core.texttools

pub struct Function {
pub:
	name     string  @[omitempty]
	receiver Param   @[omitempty]
	is_pub   bool    @[omitempty]
	mod      string  @[omitempty]
pub mut:
	summary string   @[omitempty]
	description string   @[omitempty]
	params      []Param  @[omitempty]
	body        string   @[omitempty]
	result      Param   @[omitempty]
	has_return  bool     @[omitempty]
}


// vgen_function generates a function statement for a function
pub fn (function Function) vgen(options WriteOptions) string {
	mut params_ := function.params.clone()
	optionals := function.params.filter(it.is_optional)
	options_struct := Struct{
		name: '${texttools.pascal_case(function.name)}Options'
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

	receiver_ := Param{
		...function.receiver,
		typ: if function.receiver.typ is Result {
			function.receiver.typ.typ
		} else {function.receiver.typ}

	}
	receiver := if receiver_.vgen().trim_space() != '' {
		'(${receiver_.vgen()})'
	} else {''}

	name := texttools.name_fix(function.name)
	result := function.result.typ.vgen()

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

pub fn new_function(code string) !Function {
	// TODO: implement function from file line
	return parse_function(code)!
}

pub fn parse_function(code_ string) !Function {
	mut code := code_.trim_space()
	is_pub := code.starts_with('pub ')
	if is_pub {
		code = code.trim_string_left('pub ').trim_space()
	}

	is_fn := code.starts_with('fn ')
	if !is_fn {
		return error('invalid function format')
	}
	code = code.trim_string_left('fn ').trim_space()

	receiver := if code.starts_with('(') {
		param_str := code.all_after('(').all_before(')').trim_space()
		code = code.all_after(')').trim_space()
		parse_param(param_str)!
	} else {
		Param{}
	}

	name := code.all_before('(').trim_space()
	code = code.trim_string_left(name).trim_space()

	params_str := code.all_after('(').all_before(')')
	params := if params_str.trim_space() != '' {
		params_str_lst := params_str.split(',')
		params_str_lst.map(parse_param(it)!)
	} else {
		[]Param{}
	}
	result := new_param(
		v: code.all_after(')').all_before('{').replace(' ', '')
	)!

	body := if code.contains('{') { code.all_after('{').all_before_last('}') } else { '' }
	return Function{
		name: name
		receiver: receiver
		params: params
		result: result
		body: body
	}
}