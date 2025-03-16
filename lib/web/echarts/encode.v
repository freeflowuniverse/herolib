module echarts

import x.json2 as json

pub fn (o EChartsOption) json() string {
	return json.encode(o)
}

pub fn (o EChartsOption) mdx() string {
	option := format_js_object(o, true)
	return '<EChart option={${option}} />'
}

pub fn (o EChartsOption) markdown() string {
	option := format_js_object(o, true)
	return '```echarts\n{${option}\n};\n```\n'
}

// Generic function to format JavaScript-like objects
fn format_js_object[T](obj T, omitempty bool) string {
	mut result := ''
	result += '{'

	$for field in T.fields {
		field_name := if field.attrs.any(it.starts_with('json:')) {
			field.attrs.filter(it.starts_with('json'))[0].all_after('json:').trim_space()
		} else {
			field.name
		}
		value := obj.$(field.name)
		formatted_value := format_js_value(value, field.attrs.contains('omitempty'))
		if formatted_value.trim_space() != '' || !omitempty {
			result += '${field_name}: ${formatted_value.trim_space()}, '
		}
	}
	result += '}'
	if result == '{}' && omitempty {
		return ''
	}
	return result.str().replace(', }', '}') // Remove trailing comma
}

// Fully generic function to format any JS value
// TODO: improve code below, far from cleanest implementation
// currently is sufficient since only used in echart mdx export
fn format_js_value[T](value T, omitempty bool) string {
	return $if T is string {
		// is actually map
		if value.str().starts_with('{') && value.str().ends_with('}') {
			value
			// map_any := json2.raw_decode(value.str()) or {'{}'}.as_map()
			// println('debugzo21 ${map_any}')
			// mut val := '{'
			// for k, v in map_any {
			//     val += '${k}: ${format_js_value(v.str(), false)}'
			// }
			// val += '}'
			// if val == '{}' && omitempty {
			//     return ''
			// }
			// val
		} else {
			val := '"${value}"'
			if val == '""' && omitempty {
				return ''
			}
			val
		}
	} $else $if T is int {
		if '${value}' == '0' && omitempty {
			''
		} else {
			'${value}'
		}
	} $else $if T is f64 {
		if '${value}' == '0.0' && omitempty {
			''
		} else {
			'${value}'
		}
	} $else $if T is bool {
		if '${value}' == 'false' && omitempty {
			''
		} else {
			'${value}'
		}
	} $else $if T is $struct {
		val := format_js_object(value, omitempty)
		if val == '' && omitempty {
			return ''
		}
		val
	} $else $if T is $array {
		mut arr := '['
		for i in 0 .. value.len {
			if i != 0 {
				arr += ', '
			}
			val := format_js_value(value[i], omitempty)
			if val.starts_with('"{') && val.ends_with('}"') {
				arr += val.trim('"')
			} else if val.starts_with('"\'') && val.ends_with('\'"') {
				arr += val.trim('"')
			} else if val.trim('"').trim_space().f64() != 0 {
				arr += val.trim('"').trim_space()
			} else if val.trim('"').trim_space() == '0' || val.trim('"').trim_space() == '0.0' {
				arr += '0'
			} else {
				arr += val
			}
		}
		arr += ']'
		if omitempty && arr == '[]' {
			return ''
		}
		arr
	} $else {
		'null'
	}
}
