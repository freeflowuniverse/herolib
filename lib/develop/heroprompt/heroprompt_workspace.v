module heroprompt

import rand
import time
import os
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.develop.codewalker

fn (wsp &Workspace) save() !&Workspace {
	mut tmp := wsp
	tmp.updated = time.now()
	tmp.is_saved = true
	set(tmp)!
	return get(name: wsp.name)!
}

// // WorkspaceItem represents a file or directory in the workspace tree
// pub struct WorkspaceItem {
// pub mut:
// 	name         string          // Item name (file or directory name)
// 	path         string          // Full path to the item
// 	is_directory bool            // True if this is a directory
// 	is_file      bool            // True if this is a file
// 	size         i64             // File size in bytes (0 for directories)
// 	extension    string          // File extension (empty for directories)
// 	children     []WorkspaceItem // Child items (for directories)
// 	is_expanded  bool            // Whether directory is expanded in UI
// 	is_selected  bool            // Whether this item is selected for prompts
// 	depth        int             // Depth level in the tree (0 = root)
// }

// // WorkspaceList represents the complete hierarchical listing of a workspace
// pub struct WorkspaceList {
// pub mut:
// 	root_path   string          // Root path of the workspace
// 	items       []WorkspaceItem // Top-level items in the workspace
// 	total_files int             // Total number of files
// 	total_dirs  int             // Total number of directories
// }

// // list returns the complete hierarchical structure of the workspace
// pub fn (wsp Workspace) list() WorkspaceList {
// 	mut result := WorkspaceList{
// 		root_path: wsp.base_path
// 	}

// 	if wsp.base_path.len == 0 || !os.exists(wsp.base_path) {
// 		return result
// 	}

// 	// Build the complete tree structure (ALL files and directories)
// 	result.items = wsp.build_workspace_tree(wsp.base_path, 0)
// 	wsp.calculate_totals(result.items, mut result)

// 	// Mark selected items
// 	wsp.mark_selected_items(mut result.items)

// 	return result
// }

// // build_workspace_tree recursively builds the workspace tree structure
// fn (wsp Workspace) build_workspace_tree(path string, depth int) []WorkspaceItem {
// 	mut items := []WorkspaceItem{}

// 	entries := os.ls(path) or { return items }

// 	for entry in entries {
// 		full_path := os.join_path(path, entry)

// 		if os.is_dir(full_path) {
// 			mut dir_item := WorkspaceItem{
// 				name:         entry
// 				path:         full_path
// 				is_directory: true
// 				is_file:      false
// 				size:         0
// 				extension:    ''
// 				is_expanded:  false
// 				is_selected:  false
// 				depth:        depth
// 			}

// 			// Recursively get children
// 			dir_item.children = wsp.build_workspace_tree(full_path, depth + 1)
// 			items << dir_item
// 		} else if os.is_file(full_path) {
// 			file_info := os.stat(full_path) or { continue }
// 			extension := get_file_extension(entry)

// 			file_item := WorkspaceItem{
// 				name:         entry
// 				path:         full_path
// 				is_directory: false
// 				is_file:      true
// 				size:         file_info.size
// 				extension:    extension
// 				children:     []
// 				is_expanded:  false
// 				is_selected:  false
// 				depth:        depth
// 			}
// 			items << file_item
// 		}
// 	}

// 	// Sort: directories first, then files, both alphabetically
// 	items.sort_with_compare(fn (a &WorkspaceItem, b &WorkspaceItem) int {
// 		if a.is_directory && !b.is_directory {
// 			return -1
// 		}
// 		if !a.is_directory && b.is_directory {
// 			return 1
// 		}
// 		if a.name < b.name {
// 			return -1
// 		}
// 		if a.name > b.name {
// 			return 1
// 		}
// 		return 0
// 	})

// 	return items
// }

// // calculate_totals counts total files and directories in the workspace
// fn (wsp Workspace) calculate_totals(items []WorkspaceItem, mut result WorkspaceList) {
// 	for item in items {
// 		if item.is_directory {
// 			result.total_dirs++
// 			wsp.calculate_totals(item.children, mut result)
// 		} else {
// 			result.total_files++
// 		}
// 	}
// }

// // mark_selected_items marks which items are currently selected for prompts
// fn (wsp Workspace) mark_selected_items(mut items []WorkspaceItem) {
// 	for mut item in items {
// 		// Check if this item is selected by comparing paths
// 		item.is_selected = wsp.is_item_selected(item.path)

// 		// Recursively mark children
// 		if item.is_directory && item.children.len > 0 {
// 			wsp.mark_selected_items(mut item.children)
// 		}
// 	}
// }

// // is_item_selected checks if a specific path is selected in the workspace
// fn (wsp Workspace) is_item_selected(path string) bool {
// 	dirs := wsp.children.filter(fn (item &HeropromptChild) bool {
// 		return item.path.cat == .dir
// 	})
// 	for dir in dirs {
// 		if dir.path.path == path {
// 			return true
// 		}
// 		files := dir.children.filter(fn (item &HeropromptChild) bool {
// 			return item.path.cat == .file
// 		})
// 		for file in files {
// 			if file.path.path == path {
// 				return true
// 			}
// 		}
// 		child_dirs := dir.children.filter(fn (item &HeropromptChild) bool {
// 			return item.path.cat == .dir
// 		})
// 		if wsp.is_path_in_selected_dirs(path, child_dirs) {
// 			return true
// 		}
// 	}
// 	return false
// }

// Selection API
@[params]
pub struct AddDirParams {
pub mut:
	path string @[required]
}

@[params]
pub struct AddFileParams {
pub mut:
	path string @[required]
}

// add a directory to the selection (no recursion stored; recursion is done on-demand)
pub fn (mut wsp Workspace) add_dir(args AddDirParams) !HeropromptChild {
	if args.path.len == 0 {
		return error('the directory path is required')
	}

	if !os.exists(args.path) || !os.is_dir(args.path) {
		return error('path is not an existing directory: ${args.path}')
	}

	abs_path := os.real_path(args.path)
	name := os.base(abs_path)

	for child in wsp.children {
		if child.name == name {
			return error('another directory with the same name already exists: ${name}')
		}
	}

	mut ch := HeropromptChild{
		path: pathlib.Path{
			path:  abs_path
			cat:   .dir
			exist: .yes
		}
		name: name
	}
	wsp.children << ch
	wsp.save()!
	return ch
}

// add a file to the selection
pub fn (mut wsp Workspace) add_file(args AddFileParams) !HeropromptChild {
	if args.path.len == 0 {
		return error('The file path is required')
	}

	if !os.exists(args.path) || !os.is_file(args.path) {
		return error('Path is not an existing file: ${args.path}')
	}

	abs_path := os.real_path(args.path)
	name := os.base(abs_path)

	for child in wsp.children {
		if child.path.cat == .file && child.name == name {
			return error('another file with the same name already exists: ${name}')
		}

		if child.path.cat == .dir && child.name == name {
			return error('${name}: is a directory, cannot add file with same name')
		}
	}

	content := os.read_file(abs_path) or { '' }
	mut ch := HeropromptChild{
		path:    pathlib.Path{
			path:  abs_path
			cat:   .file
			exist: .yes
		}
		name:    name
		content: content
	}

	wsp.children << ch
	wsp.save()!
	return ch
}

// Removal API
@[params]
pub struct RemoveParams {
pub mut:
	path string
	name string
}

// Remove a directory from the selection (by absolute path or name)
pub fn (mut wsp Workspace) remove_dir(args RemoveParams) ! {
	if args.path.len == 0 && args.name.len == 0 {
		return error('either path or name is required to remove a directory')
	}
	mut idxs := []int{}
	for i, ch in wsp.children {
		if ch.path.cat != .dir {
			continue
		}
		if args.path.len > 0 && os.real_path(args.path) == ch.path.path {
			idxs << i
			continue
		}
		if args.name.len > 0 && args.name == ch.name {
			idxs << i
		}
	}
	if idxs.len == 0 {
		return error('no matching directory found to remove')
	}
	// remove from end to start to keep indices valid
	idxs.sort(a > b)
	for i in idxs {
		wsp.children.delete(i)
	}
	wsp.save()!
}

// Remove a file from the selection (by absolute path or name)
pub fn (mut wsp Workspace) remove_file(args RemoveParams) ! {
	if args.path.len == 0 && args.name.len == 0 {
		return error('either path or name is required to remove a file')
	}
	mut idxs := []int{}
	for i, ch in wsp.children {
		if ch.path.cat != .file {
			continue
		}
		if args.path.len > 0 && os.real_path(args.path) == ch.path.path {
			idxs << i
			continue
		}
		if args.name.len > 0 && args.name == ch.name {
			idxs << i
		}
	}
	if idxs.len == 0 {
		return error('no matching file found to remove')
	}
	idxs.sort(a > b)
	for i in idxs {
		wsp.children.delete(i)
	}
	wsp.save()!
}

// Delete this workspace from the store
pub fn (wsp &Workspace) delete_workspace() ! {
	delete(name: wsp.name)!
}

// List workspaces (wrapper over factory list)
pub fn list_workspaces() ![]&Workspace {
	return list(fromdb: false)!
}

pub fn list_workspaces_fromdb() ![]&Workspace {
	return list(fromdb: true)!
}

// Get the currently selected children (copy)
pub fn (wsp Workspace) selected_children() []HeropromptChild {
	return wsp.children.clone()
}

// Build utilities
fn list_files_recursive(root string) []string {
	mut out := []string{}
	entries := os.ls(root) or { return out }
	for e in entries {
		fp := os.join_path(root, e)
		if os.is_dir(fp) {
			out << list_files_recursive(fp)
		} else if os.is_file(fp) {
			out << fp
		}
	}
	return out
}

// build_file_content generates formatted content for all selected files (and all files under selected dirs)
fn (wsp Workspace) build_file_content() !string {
	mut content := ''
	// files selected directly
	for ch in wsp.children {
		if ch.path.cat == .file {
			if content.len > 0 {
				content += '\n\n'
			}
			content += '${ch.path.path}\n'
			ext := get_file_extension(ch.name)
			if ch.content.len == 0 {
				// read on demand
				ch_content := os.read_file(ch.path.path) or { '' }
				if ch_content.len == 0 {
					content += '(Empty file)\n'
				} else {
					content += '```' + ext + '\n' + ch_content + '\n```'
				}
			} else {
				content += '```' + ext + '\n' + ch.content + '\n```'
			}
		}
	}
	// files under selected directories, using CodeWalker for filtered traversal
	for ch in wsp.children {
		if ch.path.cat == .dir {
			mut cw := codewalker.new(codewalker.CodeWalkerArgs{})!
			mut fm := cw.filemap_get(path: ch.path.path)!
			for rel, fc in fm.content {
				if content.len > 0 {
					content += '\n\n'
				}
				abs := os.join_path(ch.path.path, rel)
				content += abs + '\n'
				ext := get_file_extension(os.base(abs))
				if fc.len == 0 {
					content += '(Empty file)\n'
				} else {
					content += '```' + ext + '\n' + fc + '\n```'
				}
			}
		}
	}
	return content
}

// Minimal tree builder for selected directories only; marks files with *
fn build_file_tree_fs(roots []HeropromptChild, prefix string) string {
	mut out := ''
	for i, root in roots {
		if root.path.cat != .dir {
			continue
		}
		connector := if i == roots.len - 1 { '└── ' } else { '├── ' }
		out += '${prefix}${connector}${root.name}\n'
		child_prefix := if i == roots.len - 1 { prefix + '    ' } else { prefix + '│   ' }
		// list children under root
		entries := os.ls(root.path.path) or { []string{} }
		// sort: dirs first then files
		mut dirs := []string{}
		mut files := []string{}
		for e in entries {
			fp := os.join_path(root.path.path, e)
			if os.is_dir(fp) {
				dirs << fp
			} else if os.is_file(fp) {
				files << fp
			}
		}
		dirs.sort()
		files.sort()
		// files
		for j, f in files {
			file_connector := if j == files.len - 1 && dirs.len == 0 {
				'└── '
			} else {
				'├── '
			}
			out += '${child_prefix}${file_connector}${os.base(f)} *\n'
		}
		// subdirectories
		for j, d in dirs {
			sub_connector := if j == dirs.len - 1 { '└── ' } else { '├── ' }
			out += '${child_prefix}${sub_connector}${os.base(d)}\n'
			sub_prefix := if j == dirs.len - 1 {
				child_prefix + '    '
			} else {
				child_prefix + '│   '
			}
			out += build_file_tree_fs([
				HeropromptChild{
					path: pathlib.Path{
						path:  d
						cat:   .dir
						exist: .yes
					}
					name: os.base(d)
				},
			], sub_prefix)
		}
	}
	return out
}

pub struct HeropromptTmpPrompt {
pub mut:
	user_instructions string
	file_map          string
	file_contents     string
}

fn (wsp Workspace) build_user_instructions(text string) string {
	return text
}

// build_file_map creates a complete file map with base path and metadata
fn (wsp Workspace) build_file_map() string {
	mut file_map := ''
	// roots are selected directories
	mut roots := []HeropromptChild{}
	mut files_only := []HeropromptChild{}
	for ch in wsp.children {
		if ch.path.cat == .dir {
			roots << ch
		} else if ch.path.cat == .file {
			files_only << ch
		}
	}
	if roots.len > 0 {
		base_path := roots[0].path.path
		parent_path := if base_path.contains('/') {
			base_path.split('/')[..base_path.split('/').len - 1].join('/')
		} else {
			base_path
		}
		// metadata
		mut total_files := 0
		mut total_content_length := 0
		mut file_extensions := map[string]int{}
		// files under dirs
		for r in roots {
			for f in list_files_recursive(r.path.path) {
				total_files++
				ext := get_file_extension(os.base(f))
				if ext.len > 0 {
					file_extensions[ext] = file_extensions[ext] + 1
				}
				total_content_length += (os.read_file(f) or { '' }).len
			}
		}
		// files only
		for fo in files_only {
			total_files++
			ext := get_file_extension(fo.name)
			if ext.len > 0 {
				file_extensions[ext] = file_extensions[ext] + 1
			}
			total_content_length += fo.content.len
		}
		mut extensions_summary := ''
		for ext, count in file_extensions {
			if extensions_summary.len > 0 {
				extensions_summary += ', '
			}
			extensions_summary += '${ext}(${count})'
		}
		file_map = '${parent_path}\n'
		file_map += '# Selected Files: ${total_files} | Total Content: ${total_content_length} chars'
		if extensions_summary.len > 0 {
			file_map += ' | Extensions: ${extensions_summary}'
		}
		file_map += '\n\n'
		file_map += build_file_tree_fs(roots, '')
		// list standalone files as well
		for fo in files_only {
			file_map += fo.path.path + ' *\n'
		}
	}
	return file_map
}

pub struct WorkspacePrompt {
pub mut:
	text string
}

pub fn (wsp Workspace) prompt(args WorkspacePrompt) string {
	user_instructions := wsp.build_user_instructions(args.text)
	file_map := wsp.build_file_map()
	file_contents := wsp.build_file_content() or { '(Error building file contents)' }
	prompt := HeropromptTmpPrompt{
		user_instructions: user_instructions
		file_map:          file_map
		file_contents:     file_contents
	}
	reprompt := $tmpl('./templates/prompt.template')
	return reprompt
}

// // is_path_in_selected_dirs recursively checks subdirectories for selected items
// fn (wsp Workspace) is_path_in_selected_dirs(path string, dirs []&HeropromptChild) bool {
// 	for dir in dirs {
// 		if dir.path.cat != .dir {
// 			continue
// 		}
// 		if dir.path.path == path {
// 			return true
// 		}
// 		files := dir.children.filter(fn (item &HeropromptChild) bool {
// 			return item.path.cat == .file
// 		})
// 		for file in files {
// 			if file.path.path == path {
// 				return true
// 			}
// 		}
// 		child_dirs := dir.children.filter(fn (item &HeropromptChild) bool {
// 			return item.path.cat == .dir
// 		})
// 		if wsp.is_path_in_selected_dirs(path, child_dirs) {
// 			return true
// 		}
// 	}
// 	return false
// }

// @[params]
// pub struct AddDirParams {
// pub mut:
// 	path       string @[required]
// 	select_all bool
// }

// pub fn (mut wsp Workspace) add_dir(args_ AddDirParams) !&HeropromptChild {
// 	if args_.path.len == 0 {
// 		return error('The dir path is required')
// 	}
// 	if !os.exists(args_.path) {
// 		return error('The provided path does not exists')
// 	}
// 	abs_path := os.real_path(args_.path)
// 	parts := abs_path.split(os.path_separator)
// 	dir_name := parts[parts.len - 1]
// 	mut added := &HeropromptChild{
// 		path: pathlib.Path{
// 			path:  abs_path
// 			cat:   .dir
// 			exist: .yes
// 		}
// 		name: dir_name
// 	}
// 	if args_.select_all {
// 		added.select_all_files_and_dirs(abs_path)
// 	}
// 	wsp.children << added
// 	return added
// }

// // Metadata structures for selected files and directories
// struct SelectedFilesMetadata {
// 	content_length int    // File content length in characters
// 	extension      string // File extension
// 	name           string // File name
// 	path           string // Full file path
// }

// struct SelectedDirsMetadata {
// 	name           string                  // Directory name
// 	selected_files []SelectedFilesMetadata // Files in this directory
// }

// struct WorkspaceGetSelected {
// pub mut:
// 	dirs []SelectedDirsMetadata // All directories with their selected files
// }

// pub fn (wsp Workspace) get_selected() WorkspaceGetSelected {
// 	mut result := WorkspaceGetSelected{}
// 	for dir in wsp.children.filter(fn (c &HeropromptChild) bool {
// 		return c.path.cat == .dir
// 	}) {
// 		mut files := []SelectedFilesMetadata{}
// 		for file in dir.children.filter(fn (c &HeropromptChild) bool {
// 			return c.path.cat == .file
// 		}) {
// 			files << SelectedFilesMetadata{
// 				content_length: file.content.len
// 				extension:      get_file_extension(file.name)
// 				name:           file.name
// 				path:           file.path.path
// 			}
// 		}
// 		result.dirs << SelectedDirsMetadata{
// 			name:           dir.name
// 			selected_files: files
// 		}
// 	}
// 	return result
// }

// pub struct WorkspacePrompt {
// pub mut:
// 	text string
// }

// pub fn (wsp Workspace) prompt(args WorkspacePrompt) string {
// 	prompt := wsp.build_prompt(args.text)
// 	return prompt
// }

// // Placeholder function for future needs, in case we need to highlight the user_instructions block with some addtional messages
// fn (wsp Workspace) build_user_instructions(text string) string {
// 	return text
// }

// // build_file_tree creates a tree-like representation of directories and files
// fn build_file_tree(dirs []&HeropromptChild, prefix string) string {
// 	mut out := ''
// 	for i, dir in dirs {
// 		if dir.path.cat != .dir {
// 			continue
// 		}
// 		// Determine the correct tree connector
// 		connector := if i == dirs.len - 1 { '└── ' } else { '├── ' }
// 		// Directory name
// 		out += '${prefix}${connector}${dir.name}\n'
// 		// Calculate new prefix for children
// 		child_prefix := if i == dirs.len - 1 { prefix + '    ' } else { prefix + '│   ' }
// 		// Total children (files + subdirs)
// 		files := dir.children.filter(fn (c &HeropromptChild) bool {
// 			return c.path.cat == .file
// 		})
// 		subdirs := dir.children.filter(fn (c &HeropromptChild) bool {
// 			return c.path.cat == .dir
// 		})
// 		total_children := files.len + subdirs.len
// 		// Files in this directory
// 		for j, file in files {
// 			file_connector := if j == total_children - 1 { '└── ' } else { '├── ' }
// 			out += '${child_prefix}${file_connector}${file.name} *\n'
// 		}
// 		// Recurse into subdirectories
// 		for j, sub_dir in subdirs {
// 			sub_connector := if files.len + j == total_children - 1 {
// 				'└── '
// 			} else {
// 				'├── '
// 			}
// 			out += '${child_prefix}${sub_connector}${sub_dir.name}\n'
// 			sub_prefix := if files.len + j == total_children - 1 {
// 				child_prefix + '    '
// 			} else {
// 				child_prefix + '│   '
// 			}
// 			// Build content for this subdirectory directly without calling build_file_map again
// 			sub_files := sub_dir.children.filter(fn (c &HeropromptChild) bool {
// 				return c.path.cat == .file
// 			})
// 			sub_subdirs := sub_dir.children.filter(fn (c &HeropromptChild) bool {
// 				return c.path.cat == .dir
// 			})
// 			sub_total_children := sub_files.len + sub_subdirs.len
// 			for k, sub_file in sub_files {
// 				sub_file_connector := if k == sub_total_children - 1 {
// 					'└── '
// 				} else {
// 					'├── '
// 				}
// 				out += '${sub_prefix}${sub_file_connector}${sub_file.name} *\n'
// 			}
// 			if sub_subdirs.len > 0 {
// 				out += build_file_tree(sub_subdirs, sub_prefix)
// 			}
// 		}
// 	}
// 	return out
// }

// // build_file_content generates formatted content for all selected files
// fn (wsp Workspace) build_file_content() string {
// 	mut content := ''

// 	for dir in wsp.children.filter(fn (c &HeropromptChild) bool {
// 		return c.path.cat == .dir
// 	}) {
// 		for file in dir.children.filter(fn (c &HeropromptChild) bool {
// 			return c.path.cat == .file
// 		}) {
// 			if content.len > 0 {
// 				content += '\n\n'
// 			}
// 			content += '${file.path.path}\n'
// 			extension := get_file_extension(file.name)
// 			if file.content.len == 0 {
// 				content += '(Empty file)\n'
// 			} else {
// 				content += '```${extension}\n'
// 				content += file.content
// 				content += '\n```'
// 			}
// 		}
// 		content += wsp.build_dir_file_content(dir.children)
// 	}

// 	return content
// }

// // build_dir_file_content recursively processes subdirectories
// fn (wsp Workspace) build_dir_file_content(dirs []&HeropromptChild) string {
// 	mut content := ''
// 	for dir in dirs {
// 		if dir.path.cat != .dir {
// 			continue
// 		}
// 		for file in dir.children.filter(fn (c &HeropromptChild) bool {
// 			return c.path.cat == .file
// 		}) {
// 			if content.len > 0 {
// 				content += '\n\n'
// 			}
// 			content += '${file.path.path}\n'
// 			extension := get_file_extension(file.name)
// 			if file.content.len == 0 {
// 				content += '(Empty file)\n'
// 			} else {
// 				content += '```${extension}\n'
// 				content += file.content
// 				content += '\n```'
// 			}
// 		}
// 		let_subdirs := dir.children.filter(fn (c &HeropromptChild) bool {
// 			return c.path.cat == .dir
// 		})
// 		if let_subdirs.len > 0 {
// 			content += wsp.build_dir_file_content(let_subdirs)
// 		}
// 	}
// 	return content
// }

// pub struct HeropromptTmpPrompt {
// pub mut:
// 	user_instructions string
// 	file_map          string
// 	file_contents     string
// }

// // build_prompt generates the final prompt with metadata and file tree
// fn (wsp Workspace) build_prompt(text string) string {
// 	user_instructions := wsp.build_user_instructions(text)
// 	file_map := wsp.build_file_map()
// 	file_contents := wsp.build_file_content()

// 	prompt := HeropromptTmpPrompt{
// 		user_instructions: user_instructions
// 		file_map:          file_map
// 		file_contents:     file_contents
// 	}

// 	reprompt := $tmpl('./templates/prompt.template')
// 	return reprompt
// }

// // build_file_map creates a complete file map with base path and metadata
// fn (wsp Workspace) build_file_map() string {
// 	mut file_map := ''
// 	// Consider only top-level directories as roots
// 	mut roots := wsp.children.filter(fn (c &HeropromptChild) bool {
// 		return c.path.cat == .dir
// 	})
// 	if roots.len > 0 {
// 		base_path := roots[0].path.path
// 		parent_path := if base_path.contains('/') {
// 			base_path.split('/')[..base_path.split('/').len - 1].join('/')
// 		} else {
// 			base_path
// 		}
// 		selected_metadata := wsp.get_selected()
// 		mut total_files := 0
// 		mut total_content_length := 0
// 		mut file_extensions := map[string]int{}
// 		for dir_meta in selected_metadata.dirs {
// 			total_files += dir_meta.selected_files.len
// 			for file_meta in dir_meta.selected_files {
// 				total_content_length += file_meta.content_length
// 				if file_meta.extension.len > 0 {
// 					file_extensions[file_meta.extension] = file_extensions[file_meta.extension] + 1
// 				}
// 			}
// 		}
// 		mut extensions_summary := ''
// 		for ext, count in file_extensions {
// 			if extensions_summary.len > 0 {
// 				extensions_summary += ', '
// 			}
// 			extensions_summary += '${ext}(${count})'
// 		}
// 		file_map = '${parent_path}\n'
// 		file_map += '# Selected Files: ${total_files} | Total Content: ${total_content_length} chars'
// 		if extensions_summary.len > 0 {
// 			file_map += ' | Extensions: ${extensions_summary}'
// 		}
// 		file_map += '\n\n'
// 		file_map += build_file_tree(roots, '')
// 	}
// 	return file_map
// }

/// Generate a random name for the workspace
fn generate_random_workspace_name() string {
	adjectives := [
		'brave',
		'bright',
		'clever',
		'swift',
		'noble',
		'mighty',
		'fearless',
		'bold',
		'wise',
		'epic',
		'valiant',
		'fierce',
		'legendary',
		'heroic',
		'dynamic',
	]
	nouns := [
		'forge',
		'script',
		'ocean',
		'phoenix',
		'atlas',
		'quest',
		'shield',
		'dragon',
		'code',
		'summit',
		'path',
		'realm',
		'spark',
		'anvil',
		'saga',
	]

	// Seed randomness with time
	rand.seed([u32(time.now().unix()), u32(time.now().nanosecond)])

	adj := adjectives[rand.intn(adjectives.len) or { 0 }]
	noun := nouns[rand.intn(nouns.len) or { 0 }]
	number := rand.intn(100) or { 0 } // 0–99

	return '${adj}_${noun}_${number}'
}
