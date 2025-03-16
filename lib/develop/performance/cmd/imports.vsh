#!/usr/bin/env -S v -n -w -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run

import os

struct ImportNode {
	name     string
	children []ImportNode
}

// Function to recursively walk through a directory and gather all .v files
fn walk_v_files(dir string) []string {
	mut v_files := []string{}
	if os.is_dir(dir) || os.is_link(dir) {
		files := os.ls(dir) or { return [] }
		for file in files {
			full_path := os.join_path(dir, file)
			if os.is_dir(full_path) || os.is_link(full_path) {
				v_files << walk_v_files(full_path)
			} else if full_path.ends_with('.v') {
				v_files << full_path
			}
		}
	}
	return v_files
}

// Function to extract imports from a .v file
fn extract_imports(file_path string) []string {
	content := os.read_file(file_path) or {
		println('Failed to read file: $file_path')
		return []
	}
	mut imports := []string{}
	for line in content.split_into_lines() {
		if line.starts_with('import ') {
			// Remove 'import ' and clean inline comments or braces
			import_line := line[7..].all_before('//').all_before('{').trim_space()
			if import_line.contains(' ') {
				imports << import_line.split(',').map(it.trim_space())
			} else {
				imports << import_line
			}
		}
	}
	return imports
}

// Function to find the directory of a module in .vmodules
fn find_module_dir(module_name string) string {
	module_path := module_name.replace('.', os.path_separator)
	vmodules_path := os.join_path(os.home_dir(), '.vmodules')
	module_dir := os.join_path(vmodules_path, module_path)
	if os.is_dir(module_dir) {
		return module_dir
	}
	return ''
}

// Function to build a tree of imports, including .vmodules
fn build_import_tree(file_path string, mut visited map[string]bool) ImportNode {
	if file_path in visited {
		return ImportNode{name: os.base(file_path), children: []}
	}
	visited[file_path] = true

	imports := extract_imports(file_path)
	mut children := []ImportNode{}

	for import_path in imports {
		// Check if the import is from the current project or .vmodules
		module_dir := find_module_dir(import_path)
		if module_dir != '' {
			module_files := walk_v_files(module_dir)
			mut module_children := []ImportNode{}
			for module_file in module_files {
				child_node := build_import_tree(module_file, mut visited)
				module_children << child_node
			}
			children << ImportNode{name: import_path, children: module_children}
		} else {
			children << ImportNode{name: import_path, children: []}
		}
	}

	return ImportNode{name: os.base(file_path), children: children}
}

// Function to print the tree of imports
fn print_import_tree(node ImportNode, depth int) {
	println('${'  '.repeat(depth)}- ${node.name}')
	for child in node.children {
		print_import_tree(child, depth + 1)
	}
}

fn main() {
	root_dir := '.' // Replace with your target directory
	mut visited := map[string]bool{}
	v_files := walk_v_files(root_dir)

	for v_file in v_files {
		root_node := build_import_tree(v_file, mut visited)
		print_import_tree(root_node, 0)
	}
}