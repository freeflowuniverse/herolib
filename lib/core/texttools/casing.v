module texttools 

pub fn camel_case(s string) string {
	mut camel := s.replace('_', ' ')
	camel = camel.title().replace(' ', '')
	return camel.uncapitalize()
}

pub fn pascal_case(s string) string {
	mut camel := s.replace('_', ' ')
	return camel.title().replace(' ', '')
}