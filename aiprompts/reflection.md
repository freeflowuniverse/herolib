## Compile time reflection

$ is used as a prefix for compile time (also referred to as 'comptime') operations.

Having built-in JSON support is nice, but V also allows you to create efficient serializers for any data format. V has compile time if and for constructs:

.fields
You can iterate over struct fields using .fields, it also works with generic types (e.g. T.fields) and generic arguments (e.g. param.fields where fn gen[T](param T) {).

struct User {
	name string
	age  int
}

fn main() {
	$for field in User.fields {
		$if field.typ is string {
			println('${field.name} is of type string')
		}
	}
}

// Output:
// name is of type string
.values
You can read Enum values and their attributes.

enum Color {
	red   @[RED]  // first attribute
	blue  @[BLUE] // second attribute
}

fn main() {
	$for e in Color.values {
		println(e.name)
		println(e.attrs)
	}
}

// Output:
// red
// ['RED']
// blue
// ['BLUE']
.attributes
You can read Struct attributes.

@[COLOR]
struct Foo {
	a int
}

fn main() {
	$for e in Foo.attributes {
		println(e)
	}
}

// Output:
// StructAttribute{
//    name: 'COLOR'
//    has_arg: false
//    arg: ''
//    kind: plain
// }
.variants
You can read variant types from Sum type.

type MySum = int | string

fn main() {
	$for v in MySum.variants {
		$if v.typ is int {
			println('has int type')
		} $else $if v.typ is string {
			println('has string type')
		}
	}
}

// Output:
// has int type
// has string type
.methods
You can retrieve information about struct methods.

struct Foo {
}

fn (f Foo) test() int {
	return 123
}

fn (f Foo) test2() string {
	return 'foo'
}

fn main() {
	foo := Foo{}
	$for m in Foo.methods {
		$if m.return_type is int {
			print('${m.name} returns int: ')
			println(foo.$method())
		} $else $if m.return_type is string {
			print('${m.name} returns string: ')
			println(foo.$method())
		}
	}
}

// Output:
// test returns int: 123
// test2 returns string: foo
.params
You can retrieve information about struct method params.

struct Test {
}

fn (t Test) foo(arg1 int, arg2 string) {
}

fn main() {
	$for m in Test.methods {
		$for param in m.params {
			println('${typeof(param.typ).name}: ${param.name}')
		}
	}
}

// Output:
// int: arg1
// string: arg2

## Example

```v
// An example deserializer implementation

struct User {
	name string
	age  int
}

fn main() {
	data := 'name=Alice\nage=18'
	user := decode[User](data)
	println(user)
}

fn decode[T](data string) T {
	mut result := T{}
	// compile-time `for` loop
	// T.fields gives an array of a field metadata type
	$for field in T.fields {
		$if field.typ is string {
			// $(string_expr) produces an identifier
			result.$(field.name) = get_string(data, field.name)
		} $else $if field.typ is int {
			result.$(field.name) = get_int(data, field.name)
		}
	}
	return result
}

fn get_string(data string, field_name string) string {
	for line in data.split_into_lines() {
		key_val := line.split('=')
		if key_val[0] == field_name {
			return key_val[1]
		}
	}
	return ''
}

fn get_int(data string, field string) int {
	return get_string(data, field).int()
}

// `decode<User>` generates:
// fn decode_User(data string) User {
//     mut result := User{}
//     result.name = get_string(data, 'name')
//     result.age = get_int(data, 'age')
//     return result
// }
```