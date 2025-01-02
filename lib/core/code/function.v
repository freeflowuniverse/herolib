module code

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

pub struct Param {
pub mut:
	required    bool    @[omitempty]
	mutable     bool    @[omitempty]
	is_shared   bool    @[omitempty]
	is_optional bool    @[omitempty]
	is_result   bool    @[omitempty]
	description string  @[omitempty]
	name        string  @[omitempty]
	typ         Type    @[omitempty]
	struct_     Struct  @[omitempty]
}

@[params]
pub struct Params{
pub:
	v string
}

pub fn new_param(params Params) !Param {
	// TODO: implement function from file line
	return parse_param(params.v)!
}

pub struct Result {
pub mut:
	typ         Type    @[omitempty]
	description string  @[omitempty]
	name        string  @[omitempty]
	result      bool    @[omitempty] // whether is result type
	optional    bool    @[omitempty] // whether is result type
	structure   Struct  @[omitempty]
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