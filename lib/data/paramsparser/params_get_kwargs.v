module paramsparser

import freeflowuniverse.herolib.core.texttools
import strconv

// see if the kwarg with the key exists
// if yes return as string trimmed
pub fn (params &Params) get(key_ string) !string {
	key := texttools.name_fix(key_)
	for p in params.params {
		if p.key == key {
			return p.value.trim(' ')
		}
	}
	$if debug {
		print_backtrace()
	}
	return error('Did not find key:${key} in ${params}')
}

pub fn (params &Params) get_map() map[string]string {
	mut r := map[string]string{}
	for p in params.params {
		r[p.key] = p.value
	}
	return r
}

// get kwarg return as string, ifn't exist return the defval
// line:
//    arg1 arg2 color:red priority:'incredible' description:'with spaces, lets see if ok
// arg1 is an arg
// description is a kwarg
pub fn (params &Params) get_default(key string, defval string) !string {
	if params.exists(key) {
		valuestr := params.get(key)!
		return valuestr.trim(' ')
	}
	return defval
}

// get kwarg return as int
// line:
//    arg1 arg2 color:red priority:'incredible' description:'with spaces, lets see if ok
// arg1 is an arg
// description is a kwarg
pub fn (params &Params) get_int(key string) !int {
	valuestr := params.get(key)!
	return strconv.atoi(valuestr) or {
		return error('Parameter ${key} = ${valuestr} is not a valid signed 32-bit integer')
	}
}

pub fn (params &Params) get_float(key string) !f64 {
	mut valuestr := params.get(key)!
	if valuestr.contains('%') {
		valuestr = valuestr.replace('%', '')
		mut vs := strconv.atof64(valuestr) or {
			return error('Parameter ${key} = ${valuestr} is not a valid 64-bit float')
		}
		vs = vs / 100
		return vs
	}
	return strconv.atof64(valuestr) or {
		return error('Parameter ${key} = ${valuestr} is not a valid 64-bit float')
	}
}

pub fn (params &Params) get_float_default(key string, defval f64) !f64 {
	if params.exists(key) {
		valuestr := params.get_float(key)!
		return valuestr
	}
	return defval
}

pub fn (params &Params) get_percentage(key string) !f64 {
	mut valuestr := params.get(key)!
	valuestr = valuestr.replace('%', '')
	v := strconv.atof64(valuestr) or {
		return error('Parameter ${key} = ${valuestr} is not a valid 64-bit float')
	}

	if v > 100 || v < 0 {
		return error('percentage "${v}" needs to be between 0 and 100')
	}
	return v / 100
}

pub fn (params &Params) get_percentage_default(key string, defval string) !f64 {
	mut v := params.get_default(key, defval)!
	v = v.replace('%', '')
	v2 := strconv.atof64(v) or {
		return error('Parameter ${key} = ${v} is not a valid 64-bit float')
	}
	if v2 > 100 || v2 < 0 {
		return error('percentage "${v2}" needs to be between 0 and 100')
	}
	return v2 / 100
}

pub fn (params &Params) get_u64(key string) !u64 {
	valuestr := params.get(key)!
	return strconv.parse_uint(valuestr, 10, 64) or {
		return error('Parameter ${key} = ${valuestr} is not a valid unsigned 64-bit integer')
	}
}

pub fn (params &Params) get_u64_default(key string, defval u64) !u64 {
	if params.exists(key) {
		valuestr := params.get_u64(key)!
		return valuestr
	}
	return defval
}

pub fn (params &Params) get_u32(key string) !u32 {
	valuestr := params.get(key)!
	return u32(strconv.parse_uint(valuestr, 10, 32) or {
		return error('Parameter ${key} = ${valuestr} is not a valid unsigned 32-bit integer')
	})
}

pub fn (params &Params) get_u32_default(key string, defval u32) !u32 {
	if params.exists(key) {
		valuestr := params.get_u32(key)!
		return valuestr
	}
	return defval
}

pub fn (params &Params) get_u8(key string) !u8 {
	valuestr := params.get(key)!
	return u8(strconv.parse_uint(valuestr, 10, 8) or {
		return error('Parameter ${key} = ${valuestr} is not a valid unsigned 8-bit integer')
	})
}

pub fn (params &Params) get_u8_default(key string, defval u8) !u8 {
	if params.exists(key) {
		valuestr := params.get_u8(key)!
		return valuestr
	}
	return defval
}

// get kwarg return as int, if it doesnt' exist return a default
// line:
//    arg1 arg2 color:red priority:'incredible' description:'with spaces, lets see if ok
// arg1 is an arg
// description is a kwarg
pub fn (params &Params) get_int_default(key string, defval int) !int {
	if params.exists(key) {
		valuestr := params.get_int(key)!
		return valuestr
	}
	return defval
}

pub fn (params &Params) get_default_true(key string) bool {
	mut r := ''
	if params.exists(key) {
		r = params.get(key) or { panic('bug') }
	}
	r = texttools.name_fix_no_underscore(r)
	if r == '' || r == '1' || r == 'true' || r == 'y' || r == 'yes' {
		return true
	}
	return false
}

pub fn (params &Params) get_default_false(key string) bool {
	mut r := ''
	if params.exists(key) {
		r = params.get(key) or { panic('bug') }
	}
	r = texttools.name_fix_no_underscore(r)
	if r == '' || r == '0' || r == 'false' || r == 'n' || r == 'no' {
		return false
	}
	return true
}

fn matchhashmap(hashmap map[string]string, tofind_ string) string {
	tofind := tofind_.to_lower().trim_space()
	for key, val in hashmap {
		for key2 in key.split(',') {
			if key2.to_lower().trim_space() == tofind {
				return val
			}
		}
	}
	return ''
}

pub fn (params &Params) get_from_hashmap(key_ string, defval string, hashmap map[string]string) !string {
	key := texttools.name_fix(key_)
	if val := params.get(key) {
		r := matchhashmap(hashmap, val)
		if r.len > 0 {
			return r
		}
	}

	r := matchhashmap(hashmap, defval)
	if r.len > 0 {
		return r
	}
	return error('Did not find key:${key} in ${params} with hashmap:${hashmap} and default:${defval}')
}
