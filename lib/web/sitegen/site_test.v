module sitegen

import os
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.data.doctree

fn test_page_add() ! {
	// Setup a dummy doctree.Tree and pathlib.Path
	mut test_dir := pathlib.get_dir(path: os.join_path(os.temp_dir(), 'sitegen_test_output'))!
	test_dir.delete()! // Clean up previous test runs
	test_dir.create()!

	mut tree := doctree.new()!
	
	// Add a dummy page to the tree for page_add to find
	mut dummy_page_content := "# My Dummy Page\n\nThis is some content for the dummy page."
	mut dummy_page_path := "collection1:dummy_page"
	tree.page_add(dummy_page_path, dummy_page_content)!

	mut site := Site{
		name: "TestSite"
		path: test_dir
		tree: &tree
	}

	// Test Case 1: Basic page addition
	mut page1 := Page{
		title: "Test Page 1"
		description: "A simple test page."
		src: dummy_page_path
		path: "pages/test_page_1.md"
	}
	site.page_add(page1)!

	mut expected_content_page1 := "---\ntitle: 'Test Page 1'\ndescription: 'A simple test page.'\n---\n# My Dummy Page\n\nThis is some content for the dummy page.\n"
	mut output_file_page1 := pathlib.get_file(path: os.join_path(test_dir.path, "pages/test_page_1.md"))!
	assert output_file_page1.exists()
	assert output_file_page1.read()! == expected_content_page1

	// Test Case 2: Page with draft, no description, hide_title, and position
	mut page2 := Page{
		title: "Test Page 2"
		draft: true
		position: 5
		hide_title: true
		src: dummy_page_path
		path: "articles/test_page_2.md"
	}
	site.page_add(page2)!

	mut expected_content_page2 := "---\ntitle: 'Test Page 2'\nhide_title: true\ndraft: true\nsidebar_position: 5\n---\n# My Dummy Page\n\nThis is some content for the dummy page.\n"
	mut output_file_page2 := pathlib.get_file(path: os.join_path(test_dir.path, "articles/test_page_2.md"))!
	assert output_file_page2.exists()
	assert output_file_page2.read()! == expected_content_page2

	// Test Case 3: Page with no title (should use filename)
	mut page3 := Page{
		src: dummy_page_path
		path: "blog/my_blog_post.md"
	}
	site.page_add(page3)!

	mut expected_content_page3 := "---\ntitle: 'my_blog_post.md'\n---\n# My Dummy Page\n\nThis is some content for the dummy page.\n"
	mut output_file_page3 := pathlib.get_file(path: os.join_path(test_dir.path, "blog/my_blog_post.md"))!
	assert output_file_page3.exists()
	assert output_file_page3.read()! == expected_content_page3

	// Clean up
	test_dir.delete()!
}