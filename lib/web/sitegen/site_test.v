module sitegen

import os
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.data.doctree

fn test_page_add() ! {
	// Setup a dummy doctree.Tree and pathlib.Path
	// Setup a temporary directory for site output
	mut site_output_dir := pathlib.get_dir(path: os.join_path(os.temp_dir(), 'sitegen_test_output'), create: true)!
	site_output_dir.delete()! // Clean up previous test runs

	// Setup a temporary directory for doctree source content
	mut doctree_source_dir := pathlib.get_dir(path: os.join_path(os.temp_dir(), 'doctree_test_source'), create: true)!
	doctree_source_dir.delete()! // Clean up previous test runs

	// Create a collection directory and a .collection file
	mut collection_dir_path := os.join_path(doctree_source_dir.path, "my_collection")
	os.mkdir_all(collection_dir_path)!
	os.write_file(os.join_path(collection_dir_path, ".collection"), "")!

	// Write a dummy markdown file to the collection directory
	mut dummy_md_file_path := os.join_path(collection_dir_path, "dummy_page.md")
	os.write_file(dummy_md_file_path, "# My Dummy Page\n\nThis is some content for the dummy page.")!

	// Initialize doctree.Tree and scan the source directory
	mut tree := doctree.new(name: "test_tree")!
	tree.scan(path: doctree_source_dir.path)!
	
	// Debug prints
	println("Tree collections after scan: ${tree.collections.keys()}")
	if "my_collection" in tree.collections {
		println("my_collection exists in tree.collections")
		println("Pages in my_collection: ${tree.collections["my_collection"].pages.keys()}")
	} else {
		println("my_collection DOES NOT exist in tree.collections")
	}

	// The dummy page path in doctree will be collection_name:page_name
	mut dummy_page_doctree_path := "my_collection:dummy_page"
	println("Dummy page doctree path: ${dummy_page_doctree_path}")

	mut site := Site{
		name: "TestSite"
		path: site_output_dir
		tree: tree // Pass the pointer directly
	}

	// Test Case 1: Basic page addition
	mut page1 := Page{
		title: "Test Page 1"
		description: "A simple test page."
		src: dummy_page_doctree_path
		path: "pages/test_page_1.md"
	}
	site.page_add(page1)!

	mut expected_content_page1 := "---\ntitle: 'Test Page 1'\ndescription: 'A simple test page.'\n---\n# My Dummy Page\n\nThis is some content for the dummy page.\n"
	mut output_file_page1 := pathlib.get_file(path: os.join_path(site_output_dir.path, "pages/test_page_1.md"))!
	assert output_file_page1.exists()
	assert output_file_page1.read()! == expected_content_page1

	// Test Case 2: Page with draft, no description, hide_title, and position
	mut page2 := Page{
		title: "Test Page 2"
		draft: true
		position: 5
		hide_title: true
		src: dummy_page_doctree_path
		path: "articles/test_page_2.md"
	}
	site.page_add(page2)!

	mut expected_content_page2 := "---\ntitle: 'Test Page 2'\nhide_title: true\ndraft: true\nsidebar_position: 5\n---\n# My Dummy Page\n\nThis is some content for the dummy page.\n"
	mut output_file_page2 := pathlib.get_file(path: os.join_path(site_output_dir.path, "articles/test_page_2.md"))!
	assert output_file_page2.exists()
	assert output_file_page2.read()! == expected_content_page2

	// Test Case 3: Page with no title (should use filename)
	mut page3 := Page{
		src: dummy_page_doctree_path
		path: "blog/my_blog_post.md"
	}
	site.page_add(page3)!

	mut expected_content_page3 := "---\ntitle: 'my_blog_post.md'\n---\n# My Dummy Page\n\nThis is some content for the dummy page.\n"
	mut output_file_page3 := pathlib.get_file(path: os.join_path(site_output_dir.path, "blog/my_blog_post.md"))!
	assert output_file_page3.exists()
	assert output_file_page3.read()! == expected_content_page3

	// Clean up
	site_output_dir.delete()!
	doctree_source_dir.delete()!
}