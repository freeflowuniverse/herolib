module doctreeclient

import freeflowuniverse.herolib.core.pathlib
import os

// List of recognized image file extensions
const image_extensions = ['.png', '.jpg', '.jpeg', '.gif', '.svg', '.webp', '.bmp', '.tiff', '.ico']

// Error types for DocTreeClient
pub enum DocTreeError {
	collection_not_found
	page_not_found
	file_not_found
	image_not_found
}

// get_page_path returns the path for a page in a collection
pub fn (mut c DocTreeClient) get_page_path(collection_name string, page_name string) !string {
	// Check if the collection exists
	collection_path := c.redis.hget('doctree:path', collection_name) or {
		return error('${DocTreeError.collection_not_found}: Collection "${collection_name}" not found')
	}
	
	// Get the relative path of the page within the collection
	rel_path := c.redis.hget('doctree:${collection_name}', page_name) or {
		return error('${DocTreeError.page_not_found}: Page "${page_name}" not found in collection "${collection_name}"')
	}
	
	// Combine the collection path with the relative path
	return os.join_path(collection_path, rel_path)
}

// get_file_path returns the path for a file in a collection
pub fn (mut c DocTreeClient) get_file_path(collection_name string, file_name string) !string {
	// Check if the collection exists
	collection_path := c.redis.hget('doctree:path', collection_name) or {
		return error('${DocTreeError.collection_not_found}: Collection "${collection_name}" not found')
	}
	
	// Get the relative path of the file within the collection
	rel_path := c.redis.hget('doctree:${collection_name}', file_name) or {
		return error('${DocTreeError.file_not_found}: File "${file_name}" not found in collection "${collection_name}"')
	}
	
	// Combine the collection path with the relative path
	return os.join_path(collection_path, rel_path)
}

// get_image_path returns the path for an image in a collection
pub fn (mut c DocTreeClient) get_image_path(collection_name string, image_name string) !string {
	// Check if the collection exists
	collection_path := c.redis.hget('doctree:path', collection_name) or {
		return error('${DocTreeError.collection_not_found}: Collection "${collection_name}" not found')
	}
	
	// Get the relative path of the image within the collection
	rel_path := c.redis.hget('doctree:${collection_name}', image_name) or {
		return error('${DocTreeError.image_not_found}: Image "${image_name}" not found in collection "${collection_name}"')
	}
	
	// Combine the collection path with the relative path
	return os.join_path(collection_path, rel_path)
}

// page_exists checks if a page exists in a collection
pub fn (mut c DocTreeClient) page_exists(collection_name string, page_name string) bool {
	// Check if the collection exists
	e:=c.redis.hexists('doctree:path', collection_name) or {
		return false
	}
	if !e{
		return false
	}
	
	// Check if the page exists in the collection
	return c.redis.hexists('doctree:${collection_name}', page_name) or {false}
}

// file_exists checks if a file exists in a collection
pub fn (mut c DocTreeClient) file_exists(collection_name string, file_name string) bool {
	// Check if the collection exists
	e:=c.redis.hexists('doctree:path', collection_name) or {
		return false
	}
	if !e{
		return false
	}
	
	
	// Check if the file exists in the collection
	return c.redis.hexists('doctree:${collection_name}', file_name) or {false}
}

// image_exists checks if an image exists in a collection
pub fn (mut c DocTreeClient) image_exists(collection_name string, image_name string) bool {
	// Check if the collection exists
	e:=c.redis.hexists('doctree:path', collection_name) or {
		return false
	}
	if !e{
		return false
	}
	
	// Check if the image exists in the collection
	return c.redis.hexists('doctree:${collection_name}', image_name) or {false}
}

// get_page_content returns the content of a page in a collection
pub fn (mut c DocTreeClient) get_page_content(collection_name string, page_name string) !string {
	// Get the path for the page
	page_path := c.get_page_path(collection_name, page_name)!
	
	// Use pathlib to read the file content
	mut path := pathlib.get_file(path: page_path)!
	
	// Check if the file exists
	if !path.exists() {
		return error('${DocTreeError.page_not_found}: Page file "${page_path}" does not exist on disk')
	}
	
	// Read and return the file content
	return path.read()!
}

// list_collections returns a list of all collection names
pub fn (mut c DocTreeClient) list_collections() ![]string {
	// Get all collection names from Redis
	return c.redis.hkeys('doctree:path')!
}

// list_pages returns a list of all page names in a collection
pub fn (mut c DocTreeClient) list_pages(collection_name string) ![]string {
	// Check if the collection exists
	if ! (c.redis.hexists('doctree:path', collection_name) or {false}) {
		return error('${DocTreeError.collection_not_found}: Collection "${collection_name}" not found')
	}
	
	// Get all keys from the collection hash
	all_keys := c.redis.hkeys('doctree:${collection_name}')!
	
	// Filter out only the page names (those without file extensions)
	mut page_names := []string{}
	for key in all_keys {
		if !key.contains('.') {
			page_names << key
		}
	}
	
	return page_names
}

// list_files returns a list of all file names in a collection
pub fn (mut c DocTreeClient) list_files(collection_name string) ![]string {
	// Check if the collection exists
	if ! (c.redis.hexists('doctree:path', collection_name) or {false}) {
		return error('${DocTreeError.collection_not_found}: Collection "${collection_name}" not found')
	}
	
	// Get all keys from the collection hash
	all_keys := c.redis.hkeys('doctree:${collection_name}')!
	
	// Filter out only the file names (those with file extensions, but not images)
	mut file_names := []string{}
	for key in all_keys {
		// Get the value (path) for this key
		value := c.redis.hget('doctree:${collection_name}', key) or { continue }
		
		// Check if the value contains a file extension (has a dot)
		if value.contains('.') {
			// Check if the value ends with any of the image extensions
			mut is_image := false
			for ext in image_extensions {
				if value.ends_with(ext) {
					is_image = true
					break
				}
			}
			
			// Add to file_names if it's not an image and not a page
			if !is_image && !value.ends_with('.md') {
				file_names << key
			}
		}
	}
	
	return file_names
}

// list_images returns a list of all image names in a collection
pub fn (mut c DocTreeClient) list_images(collection_name string) ![]string {
	// Check if the collection exists
	if ! (c.redis.hexists('doctree:path', collection_name) or {false}) {
		return error('${DocTreeError.collection_not_found}: Collection "${collection_name}" not found')
	}
	
	// Get all keys from the collection hash
	all_keys := c.redis.hkeys('doctree:${collection_name}')!
	
	// Filter out only the image names (those whose values end with image extensions)
	mut image_names := []string{}
	for key in all_keys {
		// Get the value (path) for this key
		value := c.redis.hget('doctree:${collection_name}', key) or { continue }
		
		// Check if the value ends with any of the image extensions
		for ext in image_extensions {
			if value.ends_with(ext) {
				image_names << key
				break
			}
		}
	}
	
	return image_names
}
