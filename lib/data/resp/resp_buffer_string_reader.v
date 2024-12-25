module resp

import io

pub struct StringReader {
	text string
mut:
	place int
}

fn imin(a int, b int) int {
	return if a < b { a } else { b }
}

fn (mut s StringReader) read(mut buf []u8) !int {
	// console.print_header(' consumer buff len $buf.len ($s.place | ${imin(s.place + buf.len, s.text.len)} | $s.text.len)')
	if s.place >= s.text.len {
		// console.print_debug('NONE')
		return -1
	}
	nrread := copy(mut buf, s.text[s.place..imin(s.place + buf.len, s.text.len)].bytes())
	s.place += nrread
	return nrread
}

pub fn buffered_string_reader(s string) &io.BufferedReader {
	mut s2 := StringReader{
		text: s + ' '
	}
	return io.new_buffered_reader(reader: s2, cap: 256)
}
