module heroprompt

import rand
import time
import os
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.develop.codewalker

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

// Update this workspace (name and/or base_path)
@[params]
pub struct UpdateParams {
pub mut:
	name      string
	base_path string
}

pub fn (wsp &Workspace) update_workspace(args UpdateParams) !&Workspace {
	mut updated := Workspace{
		name:      if args.name.len > 0 { args.name } else { wsp.name }
		base_path: if args.base_path.len > 0 { args.base_path } else { wsp.base_path }
		children:  wsp.children
		created:   wsp.created
		updated:   time.now()
		is_saved:  true
	}
	// if name changed, delete old key first
	if updated.name != wsp.name {
		delete(name: wsp.name)!
	}
	set(updated)!
	return get(name: updated.name)!
}

// @[params]
// pub struct UpdateParams {
// pub mut:
// 	name string
// 	base_path string
// 	// Update only the name and the base path for now
// }

// // Delete this workspace from the store
// pub fn (wsp &Workspace) update_workspace(args_ UpdateParams) ! {
// 	delete(name: wsp.name)!
// }

// List workspaces (wrapper over factory list)
pub fn list_workspaces() ![]&Workspace {
	return list(fromdb: false)!
}

pub fn list_workspaces_fromdb() ![]&Workspace {
	return list(fromdb: true)!
}

// List entries in a directory relative to this workspace base or absolute
@[params]
pub struct ListArgs {
pub mut:
	path string // if empty, will use workspace.base_path
}

pub struct ListItem {
pub:
	name string
	typ  string @[json: 'type']
}

pub fn (wsp &Workspace) list() ![]ListItem {
	mut dir := wsp.base_path
	if dir.len == 0 {
		return error('workspace base_path not set')
	}

	if !os.is_abs_path(dir) {
		dir = os.join_path(wsp.base_path, dir)
	}

	entries := os.ls(dir) or { return error('cannot list directory') }
	mut out := []ListItem{}
	for e in entries {
		full := os.join_path(dir, e)
		if os.is_dir(full) {
			out << ListItem{
				name: e
				typ:  'directory'
			}
		} else if os.is_file(full) {
			out << ListItem{
				name: e
				typ:  'file'
			}
		}
	}
	return out
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

// Save the workspace
fn (wsp &Workspace) save() !&Workspace {
	mut tmp := wsp
	tmp.updated = time.now()
	tmp.is_saved = true
	set(tmp)!
	return get(name: wsp.name)!
}

// Generate a random name for the workspace
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
