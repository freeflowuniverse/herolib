module doctreeclient

import os

fn test_extract_image_links(exclude_http bool) {
	// Test case 1: Basic case with one image link
	mut result := extract_image_links('Some text ![Alt Text](https://example.com/image1.png) more text')!
	assert result.len == 1
	assert result[0] == 'https://example.com/image1.png'

	// Test case 2: Multiple image links
	result = extract_image_links('![Img1](https://example.com/img1.jpg) Text ![Img2](https://example.com/img2.gif)')!
	assert result.len == 2
	assert result[0] == 'https://example.com/img1.jpg'
	assert result[1] == 'https://example.com/img2.gif'

	// Test case 3: No image links
	result = extract_image_links('Just some plain text without images.')!
	assert result.len == 0

	// Test case 4: Mixed content with other markdown
	result = extract_image_links('A link [Link](https://example.com) and an image ![Photo](https://example.com/photo.jpeg).')!
	assert result.len == 1
	assert result[0] == 'https://example.com/photo.jpeg'

	// Test case 5: Invalid image link (missing parenthesis)
	result = extract_image_links('Invalid ![Broken Link]https://example.com/broken.png')!
	assert result.len == 0

	// Test case 6: Empty string
	result = extract_image_links('')!
	assert result.len == 0

	// Test case 7: Image link at the beginning of the string
	result = extract_image_links('![Start](https://example.com/start.png) Some text.')!
	assert result.len == 1
	assert result[0] == 'https://example.com/start.png'

	// Test case 8: Image link at the end of the string
	result = extract_image_links('Some text ![End](https://example.com/end.png)')!
	assert result.len == 1
	assert result[0] == 'https://example.com/end.png'

	// Test case 9: Image link with spaces in URL (should not happen in valid markdown, but good to test robustness)
	result = extract_image_links('![Space](https://example.com/image with spaces.png)')!
	assert result.len == 1
	assert result[0] == 'https://example.com/image with spaces.png'

	// Test case 10: Image link with special characters in URL
	result = extract_image_links('![Special](https://example.com/path/to/image?id=1&name=test.png)')!
	assert result.len == 1
	assert result[0] == 'https://example.com/path/to/image?id=1&name=test.png'

	// Test case 11: Multiple image links without spaces in between
	result = extract_image_links('![A](https://a.com)![B](https://b.com)![C](https://c.com)')!
	assert result.len == 3
	assert result[0] == 'https://a.com'
	assert result[1] == 'https://b.com'
	assert result[2] == 'https://c.com'

	// Test case 12: Image link with empty alt text
	result = extract_image_links('![](https://example.com/noalt.png)')!
	assert result.len == 1
	assert result[0] == 'https://example.com/noalt.png'

	// Test case 13: Image link with empty URL (invalid markdown, but test behavior)
	result = extract_image_links('![Empty URL]()')!
	assert result.len == 1
	assert result[0] == '' // Expecting an empty string for the URL

	// Test case 14: Image link with only alt text and no URL part
	result = extract_image_links('![Only Alt Text]')!
	assert result.len == 0

	// Test case 15: Image link with only URL part and no alt text
	result = extract_image_links('()')!
	assert result.len == 0
}