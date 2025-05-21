#!/usr/bin/env -S v -n -w -cg -gc none -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.web.doctreeclient
import freeflowuniverse.herolib.data.doctree
import os

println('DocTreeClient Example')
println('=====================')

// Step 1: First, populate Redis with doctree data
println('\n1. Setting up doctree data in Redis...')


tree.scan(
	git_url:  'https://git.ourworld.tf/tfgrid/docs_tfgrid4/src/branch/main/collections'
	git_pull: false
)!

tree.export(
	destination: '/tmp/mdexport'
	reset:       true
	exclude_errors: false
)!
	
println('Doctree data populated in Redis')

// Step 2: Create a DocTreeClient instance
println('\n2. Creating DocTreeClient...')
mut client := doctreeclient.new()!
println('DocTreeClient created successfully')

// Step 3: List all collections
println('\n3. Listing collections:')
collections := client.list_collections()!
println('Found ${collections.len} collections: ${collections}')

if collections.len == 0 {
	println('No collections found. Example cannot continue.')
	return
}

// Step 4: Use the example_docs collection
collection_name := 'example_docs'
println('\n4. Using collection: ${collection_name}')

// Step 5: List pages in the collection
println('\n5. Listing pages:')
pages := client.list_pages(collection_name)!
println('Found ${pages.len} pages: ${pages}')

// Step 6: Get content of a page
if pages.len > 0 {
	page_name := 'introduction'
	println('\n6. Getting content of page: ${page_name}')
	
	// Check if page exists
	exists := client.page_exists(collection_name, page_name)
	println('Page exists: ${exists}')
	
	// Get page path
	page_path := client.get_page_path(collection_name, page_name)!
	println('Page path: ${page_path}')
	
	// Get page content
	content := client.get_page_content(collection_name, page_name)!
	println('Page content:')
	println('---')
	println(content)
	println('---')
}

// Step 7: List images in the collection
println('\n7. Listing images:')
images := client.list_images(collection_name)!
println('Found ${images.len} images: ${images}')

// Step 8: Get image path
if images.len > 0 {
	image_name := images[0]
	println('\n8. Getting path of image: ${image_name}')
	
	// Check if image exists
	exists := client.image_exists(collection_name, image_name)
	println('Image exists: ${exists}')
	
	// Get image path
	image_path := client.get_image_path(collection_name, image_name)!
	println('Image path: ${image_path}')
}

// Step 9: List files in the collection
println('\n9. Listing files:')
files := client.list_files(collection_name)!
println('Found ${files.len} files: ${files}')

// Step 10: Get file path
if files.len > 0 {
	file_name := files[0]
	println('\n10. Getting path of file: ${file_name}')
	
	// Check if file exists
	exists := client.file_exists(collection_name, file_name)
	println('File exists: ${exists}')
	
	// Get file path
	file_path := client.get_file_path(collection_name, file_name)!
	println('File path: ${file_path}')
}

// Step 11: Error handling example
println('\n11. Error handling example:')
println('Trying to access a non-existent page...')

non_existent_page := 'non_existent_page'
content := client.get_page_content(collection_name, non_existent_page) or {
	println('Error caught: ${err}')
	'Error content'
}

// Step 12: Clean up
println('\n12. Cleaning up...')
os.rmdir_all(example_dir) or { println('Failed to remove example directory: ${err}') }
os.rmdir_all(export_dir) or { println('Failed to remove export directory: ${err}') }

println('\nExample completed successfully!')
