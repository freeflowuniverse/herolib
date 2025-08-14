module heroprompt

import rand
import time
import os
import freeflowuniverse.herolib.core.pathlib

@[params]
struct NewWorkspaceParams {
mut:
	name string
	path string
}

/// Create a new workspace
/// If the name is not passed, we will generate a random one
fn (wsp HeropromptWorkspace) new(args_ NewWorkspaceParams) !&HeropromptWorkspace {
	mut args := args_
	if args.name.len == 0 {
		args.name = generate_random_workspace_name()
	}

	// Validate and set base path
	if args.path.len > 0 {
		if !os.exists(args.path) {
			return error('Workspace path does not exist: ${args.path}')
		}
		if !os.is_dir(args.path) {
			return error('Workspace path is not a directory: ${args.path}')
		}
	}

	mut workspace := &HeropromptWorkspace{
		name:      args.name
		base_path: os.real_path(args.path)
	}
	return workspace
}

// WorkspaceItem represents a file or directory in the workspace tree
pub struct WorkspaceItem {
pub mut:
	name         string          // Item name (file or directory name)
	path         string          // Full path to the item
	is_directory bool            // True if this is a directory
	is_file      bool            // True if this is a file
	size         i64             // File size in bytes (0 for directories)
	extension    string          // File extension (empty for directories)
	children     []WorkspaceItem // Child items (for directories)
	is_expanded  bool            // Whether directory is expanded in UI
	is_selected  bool            // Whether this item is selected for prompts
	depth        int             // Depth level in the tree (0 = root)
}

// WorkspaceList represents the complete hierarchical listing of a workspace
pub struct WorkspaceList {
pub mut:
	root_path   string          // Root path of the workspace
	items       []WorkspaceItem // Top-level items in the workspace
	total_files int             // Total number of files
	total_dirs  int             // Total number of directories
}

// list returns the complete hierarchical structure of the workspace
pub fn (wsp HeropromptWorkspace) list() WorkspaceList {
	mut result := WorkspaceList{
		root_path: wsp.base_path
	}

	if wsp.base_path.len == 0 || !os.exists(wsp.base_path) {
		return result
	}

	// Build the complete tree structure (ALL files and directories)
	result.items = wsp.build_workspace_tree(wsp.base_path, 0)
	wsp.calculate_totals(result.items, mut result)

	// Mark selected items
	wsp.mark_selected_items(mut result.items)

	return result
}

// build_workspace_tree recursively builds the workspace tree structure
fn (wsp HeropromptWorkspace) build_workspace_tree(path string, depth int) []WorkspaceItem {
	mut items := []WorkspaceItem{}

	entries := os.ls(path) or { return items }

	for entry in entries {
		full_path := os.join_path(path, entry)

		if os.is_dir(full_path) {
			mut dir_item := WorkspaceItem{
				name:         entry
				path:         full_path
				is_directory: true
				is_file:      false
				size:         0
				extension:    ''
				is_expanded:  false
				is_selected:  false
				depth:        depth
			}

			// Recursively get children
			dir_item.children = wsp.build_workspace_tree(full_path, depth + 1)
			items << dir_item
		} else if os.is_file(full_path) {
			file_info := os.stat(full_path) or { continue }
			extension := get_file_extension(entry)

			file_item := WorkspaceItem{
				name:         entry
				path:         full_path
				is_directory: false
				is_file:      true
				size:         file_info.size
				extension:    extension
				children:     []
				is_expanded:  false
				is_selected:  false
				depth:        depth
			}
			items << file_item
		}
	}

	// Sort: directories first, then files, both alphabetically
	items.sort_with_compare(fn (a &WorkspaceItem, b &WorkspaceItem) int {
		if a.is_directory && !b.is_directory {
			return -1
		}
		if !a.is_directory && b.is_directory {
			return 1
		}
		if a.name < b.name {
			return -1
		}
		if a.name > b.name {
			return 1
		}
		return 0
	})

	return items
}

// calculate_totals counts total files and directories in the workspace
fn (wsp HeropromptWorkspace) calculate_totals(items []WorkspaceItem, mut result WorkspaceList) {
	for item in items {
		if item.is_directory {
			result.total_dirs++
			wsp.calculate_totals(item.children, mut result)
		} else {
			result.total_files++
		}
	}
}

// mark_selected_items marks which items are currently selected for prompts
fn (wsp HeropromptWorkspace) mark_selected_items(mut items []WorkspaceItem) {
	for mut item in items {
		// Check if this item is selected by comparing paths
		item.is_selected = wsp.is_item_selected(item.path)

		// Recursively mark children
		if item.is_directory && item.children.len > 0 {
			wsp.mark_selected_items(mut item.children)
		}
	}
}

// is_item_selected checks if a specific path is selected in the workspace
fn (wsp HeropromptWorkspace) is_item_selected(path string) bool {
	for dir in wsp.dirs {
		// Check if this directory is selected
		if dir.path.path == path {
			return true
		}

		// Check if any file in this directory is selected
		for file in dir.files {
			if file.path.path == path {
				return true
			}
		}

		// Recursively check subdirectories
		if wsp.is_path_in_selected_dirs(path, dir.dirs) {
			return true
		}
	}
	return false
}

// is_path_in_selected_dirs recursively checks subdirectories for selected items
fn (wsp HeropromptWorkspace) is_path_in_selected_dirs(path string, dirs []&HeropromptDir) bool {
	for dir in dirs {
		if dir.path.path == path {
			return true
		}

		for file in dir.files {
			if file.path.path == path {
				return true
			}
		}

		if wsp.is_path_in_selected_dirs(path, dir.dirs) {
			return true
		}
	}
	return false
}

@[params]
pub struct AddDirParams {
pub mut:
	path       string @[required]
	select_all bool
}

pub fn (mut wsp HeropromptWorkspace) add_dir(args_ AddDirParams) !&HeropromptDir {
	if args_.path.len == 0 {
		return error('The dir path is required')
	}

	if !os.exists(args_.path) {
		return error('The provided path does not exists')
	}

	// Normalize absolute path
	abs_path := os.real_path(args_.path)

	parts := abs_path.split(os.path_separator)
	dir_name := parts[parts.len - 1]

	mut added_dir := &HeropromptDir{
		path: pathlib.Path{
			path:  abs_path
			cat:   .dir
			exist: .yes
		}
		name: dir_name
	}

	if args_.select_all {
		added_dir.select_all_files_and_dirs(abs_path)
	}

	wsp.dirs << added_dir
	return added_dir
}

// Metadata structures for selected files and directories
struct SelectedFilesMetadata {
	content_length int    // File content length in characters
	extension      string // File extension
	name           string // File name
	path           string // Full file path
}

struct SelectedDirsMetadata {
	name           string                  // Directory name
	selected_files []SelectedFilesMetadata // Files in this directory
}

struct HeropromptWorkspaceGetSelected {
pub mut:
	dirs []SelectedDirsMetadata // All directories with their selected files
}

pub fn (wsp HeropromptWorkspace) get_selected() HeropromptWorkspaceGetSelected {
	mut result := HeropromptWorkspaceGetSelected{}

	for dir in wsp.dirs {
		mut files := []SelectedFilesMetadata{}
		for file in dir.files {
			files << SelectedFilesMetadata{
				content_length: file.content.len
				extension:      get_file_extension(file.name)
				name:           file.name
				path:           file.path.path
			}
		}

		result.dirs << SelectedDirsMetadata{
			name:           dir.name
			selected_files: files
		}
	}

	return result
}

pub struct HeropromptWorkspacePrompt {
pub mut:
	text string
}

pub fn (wsp HeropromptWorkspace) prompt(args HeropromptWorkspacePrompt) string {
	prompt := wsp.build_prompt(args.text)
	return prompt
}

// Placeholder function for future needs, in case we need to highlight the user_instructions block with some addtional messages
fn (wsp HeropromptWorkspace) build_user_instructions(text string) string {
	return text
}

// build_file_tree creates a tree-like representation of directories and files
fn build_file_tree(dirs []&HeropromptDir, prefix string) string {
	mut out := ''

	for i, dir in dirs {
		// Determine the correct tree connector
		connector := if i == dirs.len - 1 { '└── ' } else { '├── ' }

		// Directory name
		out += '${prefix}${connector}${dir.name}\n'

		// Calculate new prefix for children
		child_prefix := if i == dirs.len - 1 { prefix + '    ' } else { prefix + '│   ' }

		// Count total children (files + subdirs) for proper tree formatting
		total_children := dir.files.len + dir.dirs.len

		// Files in this directory
		for j, file in dir.files {
			file_connector := if j == total_children - 1 { '└── ' } else { '├── ' }
			out += '${child_prefix}${file_connector}${file.name} *\n'
		}

		// Recurse into subdirectories
		for j, sub_dir in dir.dirs {
			sub_connector := if dir.files.len + j == total_children - 1 {
				'└── '
			} else {
				'├── '
			}
			out += '${child_prefix}${sub_connector}${sub_dir.name}\n'

			// Recursive call for subdirectory contents
			sub_prefix := if dir.files.len + j == total_children - 1 {
				child_prefix + '    '
			} else {
				child_prefix + '│   '
			}

			// Build content for this subdirectory directly without calling build_file_map again
			sub_total_children := sub_dir.files.len + sub_dir.dirs.len

			// Files in subdirectory
			for k, sub_file in sub_dir.files {
				sub_file_connector := if k == sub_total_children - 1 {
					'└── '
				} else {
					'├── '
				}
				out += '${sub_prefix}${sub_file_connector}${sub_file.name} *\n'
			}

			// Recursively handle deeper subdirectories
			if sub_dir.dirs.len > 0 {
				out += build_file_tree(sub_dir.dirs, sub_prefix)
			}
		}
	}

	return out
}

// build_file_content generates formatted content for all selected files
fn (wsp HeropromptWorkspace) build_file_content() string {
	mut content := ''

	for dir in wsp.dirs {
		// Process files in current directory
		for file in dir.files {
			if content.len > 0 {
				content += '\n\n'
			}

			// File path
			content += '${file.path.path}\n'

			// File content with syntax highlighting or empty file info
			extension := get_file_extension(file.name)
			if file.content.len == 0 {
				content += '(Empty file)\n'
			} else {
				content += '```${extension}\n'
				content += file.content
				content += '\n```'
			}
		}

		// Recursively process subdirectories
		content += wsp.build_dir_file_content(dir.dirs)
	}

	return content
}

// build_dir_file_content recursively processes subdirectories
fn (wsp HeropromptWorkspace) build_dir_file_content(dirs []&HeropromptDir) string {
	mut content := ''

	for dir in dirs {
		// Process files in current directory
		for file in dir.files {
			if content.len > 0 {
				content += '\n\n'
			}

			// File path
			content += '${file.path.path}\n'

			// File content with syntax highlighting or empty file info
			extension := get_file_extension(file.name)
			if file.content.len == 0 {
				content += '(Empty file)\n'
			} else {
				content += '```${extension}\n'
				content += file.content
				content += '\n```'
			}
		}

		// Recursively process subdirectories
		if dir.dirs.len > 0 {
			content += wsp.build_dir_file_content(dir.dirs)
		}
	}

	return content
}

pub struct HeropromptTmpPrompt {
pub mut:
	user_instructions string
	file_map          string
	file_contents     string
}

// build_prompt generates the final prompt with metadata and file tree
fn (wsp HeropromptWorkspace) build_prompt(text string) string {
	user_instructions := wsp.build_user_instructions(text)
	file_map := wsp.build_file_map()
	file_contents := wsp.build_file_content()

	prompt := HeropromptTmpPrompt{
		user_instructions: user_instructions
		file_map:          file_map
		file_contents:     file_contents
	}

	reprompt := $tmpl('./templates/prompt.template')
	return reprompt
}

// build_file_map creates a complete file map with base path and metadata
fn (wsp HeropromptWorkspace) build_file_map() string {
	mut file_map := ''
	if wsp.dirs.len > 0 {
		// Get the common base path from the first directory
		base_path := wsp.dirs[0].path.path
		// Find the parent directory of the base path
		parent_path := if base_path.contains('/') {
			base_path.split('/')[..base_path.split('/').len - 1].join('/')
		} else {
			base_path
		}

		// Calculate metadata
		selected_metadata := wsp.get_selected()
		mut total_files := 0
		mut total_content_length := 0
		mut file_extensions := map[string]int{}

		for dir_meta in selected_metadata.dirs {
			total_files += dir_meta.selected_files.len
			for file_meta in dir_meta.selected_files {
				total_content_length += file_meta.content_length
				if file_meta.extension.len > 0 {
					file_extensions[file_meta.extension] = file_extensions[file_meta.extension] + 1
				}
			}
		}

		// Build metadata summary
		mut extensions_summary := ''
		for ext, count in file_extensions {
			if extensions_summary.len > 0 {
				extensions_summary += ', '
			}
			extensions_summary += '${ext}(${count})'
		}

		// Build header with metadata
		file_map = '${parent_path}\n'
		file_map += '# Selected Files: ${total_files} | Total Content: ${total_content_length} chars'
		if extensions_summary.len > 0 {
			file_map += ' | Extensions: ${extensions_summary}'
		}
		file_map += '\n\n'
		file_map += build_file_tree(wsp.dirs, '')
	}

	return file_map
}

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
