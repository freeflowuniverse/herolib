module resp

import freeflowuniverse.herolib.ui.console

fn print_val_to_check(s string) {
	console.print_debug(s.replace('\n', '\\\\n').replace('\r', '\\\\r'))
}

fn val_to_check(s string) string {
	return s.replace('\n', '\\n').replace('\r', '\\r')
}

fn test_readline() {
	mut r := new_line_reader('123456'.bytes())

	mut res := []u8{}
	for _ in 0 .. 9 {
		res << r.read(1)
	}
	assert res.bytestr() == '123456'

	res = []u8{}
	r.reset()
	for _ in 0 .. 7 {
		res << r.read(2)
	}
	assert res.bytestr() == '123456'

	r = new_line_reader('12\n34\r\n56\r\n'.bytes())
	res = []u8{}
	for _ in 0 .. 4 {
		line := r.read_line()
		res << line
		res << '\\n'.bytes()
	}
	assert '12\\n34\\n56\\n\\n' == res.bytestr()
}

fn test_1() {
	mut rv := RValue(RError{
		value: 'my error'
	})
	// console.print_debug(rv.encode()rv.encode().replace("\n","\\n").replace("\r","\\r"))

	rv = RValue(RArray{
		values: [RValue(RError{
			value: 'my error'
		}), RValue(RInt{
			value: 100
		})]
	})
	assert '*2\\r\\n-my error\\r\\n:100\\r\\n' == rv.encode().bytestr().replace('\n',
		'\\n').replace('\r', '\\r')

	rv = r_list_string(['a', 'b', 'c'])
	assert '*3\\r\\n+a\\r\\n+b\\r\\n+c\\r\\n' == rv.encode().bytestr().replace('\n', '\\n').replace('\r',
		'\\r')
}

fn test_2() {
	mut b := builder_new()
	b.add(r_list_string(['a', 'b']))
	b.add(r_int(10))
	b.add(r_ok())
	print_val_to_check(b.data.bytestr())
	assert '*2\\r\\n+a\\r\\n+b\\r\\n:10\\r\\n+OK\\r\\n' == val_to_check(b.data.bytestr())

	res := decode(b.data) or { [r_error('could not decode')] }

	compare := [
		RValue(RArray{
			values: [RValue(RString{
				value: 'a'
			}), RValue(RString{
				value: 'b'
			})]
		}),
		RValue(RInt{
			value: 10
		}),
		RValue(RString{
			value: 'OK'
		}),
	]
	assert compare == res
}

fn test_3() {
	data := encode([r_list_string(['a', 'b']), r_int(10), r_ok()])
	console.print_debug(data)

	// panic('s')
}

// fn test_buffered_reader1() {
// 	mut stream := buffered_string_reader('Hello')
// 	mut buff := []u8{len: 1}
// 	assert buff.len == 1
// 	for i in 0 .. 8 {
// 		z := stream.read(mut buff) or { -1 }
// 		console.print_header(' reader buff len $buff.len ($i:$buff) | readresult: $z')
// 	}
// 	panic('s')
// }

// fn test_buffered_reader2() {
// 	mut str := StringReader{
// 		text: 'Hello '
// 	}
// 	mut stream := io.new_buffered_reader(reader: io.make_reader(str), cap: 256)
// 	mut buff := []u8{len: 1}
// 	assert buff.len == 1
// 	for i in 0 .. 8 {
// 		z := stream.read(mut buff) or { -1 }
// 		console.print_header(' reader buff len $buff.len ($i:$buff) | readresult: $z')
// 	}

// 	// panic('s')

// }
