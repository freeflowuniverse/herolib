module code

struct Float {
    bytes int
}

// Integer types
const type_i8 = Integer{
    bytes: 8
}

const type_u8 = Integer{
    bytes: 8
    signed: false
}

const type_i16 = Integer{
    bytes: 16
}

const type_u16 = Integer{
    bytes: 16
    signed: false
}

const type_i32 = Integer{
    bytes: 32
}

const type_u32 = Integer{
    bytes: 32
    signed: false
}

const type_i64 = Integer{
    bytes: 64
}

const type_u64 = Integer{
    bytes: 64
    signed: false
}

// Floating-point types
const type_f32 = Float{
    bytes: 32
}

const type_f64 = Float{
    bytes: 64
}


pub type Type = Array | Object | Result | Integer | Alias | String

pub struct Integer {
	bytes u8
	signed bool = true
}

pub fn type_from_symbol(symbol_ string) Type {
	mut symbol := symbol_.trim_space()
	if symbol.starts_with('[]') {
		return Array{type_from_symbol(symbol.all_after('[]'))}
	} else if symbol == 'int' {
		return Integer{}
	} else if symbol == 'string' {
		return String{}
	}
	return Object{symbol}
}

pub fn (t Type) symbol() string {
	return match t {
		Array { '[]${t.typ.symbol()}' }
		Object { t.name }
		Result { '!${t.typ.symbol()}'}
		Integer {
            mut str := ''
            if !t.signed {
                str += 'u'
            }
            if t.bytes != 0 {
                '${str}${t.bytes}'
            } else {
                '${str}int'
            }
        }
		Alias {t.name}
		String {'string'}
	}
}

pub struct String {}

pub struct Array {
pub:
	typ Type
}

pub struct Object {
pub:
	name string
}

pub struct Result {
pub:
	typ Type
}