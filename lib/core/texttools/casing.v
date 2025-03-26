module texttools

pub fn snake_case(s string) string {
	return separate_words(s).join('_')
}

pub fn title_case(s string) string {
	return separate_words(s).join(' ').title()
}

pub fn pascal_case(s string) string {
	mut pascal := s.replace('_', ' ')
	return pascal.title().replace(' ', '')
}

pub fn camel_case(s string) string {
	return pascal_case(s).uncapitalize()
}

const separators = ['.', '_', '-', '/', ' ', ':', ',', ';']

fn separate_words(s string) []string {
	mut words := []string{}
	mut word := ''
	for _, c in s {
		if (c.is_capital() || c.ascii_str() in separators) && word != '' {
			words << word.to_lower()
			word = ''
		}
		if c.ascii_str() !in separators {
			word += c.ascii_str().to_lower()
		}
	}
	if word != '' {
		words << word.to_lower()
	}
	return words
}
