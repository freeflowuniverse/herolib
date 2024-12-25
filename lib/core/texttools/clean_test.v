module texttools

fn test_clean1() {
	mut text := "
	'''js

	'''
	something
		yes

	else

	```js

	```

	'''js

	inside
	'''


	"

	mut result := "
	something
		yes

	else

	'''js

	inside
	'''
	"

	text = dedent(text)
	result = dedent(result)

	text2 := remove_double_lines(remove_empty_js_blocks(text))

	print('---')
	print(text2)
	print('---')
	print(result)
	print('---')

	assert text2.trim_space() == result.trim_space()
}
