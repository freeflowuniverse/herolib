module heroprompt

import rand
import time
import os
import freeflowuniverse.herolib.core.pathlib

@[heap]
pub struct HeropromptWorkspace {
pub mut:
	name string = 'default'
	dirs []&HeropromptDir
}

@[params]
pub struct NewWorkspaceParams {
pub mut:
	name string
}

/// Create a new workspace
/// If the name is not passed, we will generate a random one
fn (wsp HeropromptWorkspace) new(args_ NewWorkspaceParams) !&HeropromptWorkspace {
	mut args := args_
	if args.name.len == 0 {
		args.name = generate_random_workspace_name()
	}

	workspace := get(name: args.name)!
	return workspace
}

@[params]
pub struct AddDirParams {
pub mut:
	path string @[required]
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

	added_dir := &HeropromptDir{
		path: pathlib.Path{
			path:  abs_path
			cat:   .dir
			exist: .yes
		}
		name: dir_name
	}

	wsp.dirs << added_dir
	return added_dir
}

struct SelectedFilesMetadata {
	content_length int
	extension      string
	name           string
	path           string
}

struct SelectedDirsMetadata {
	name           string
	selected_files []SelectedFilesMetadata
}

struct HeropromptWorkspaceGetSelected {
pub mut:
	dirs []SelectedDirsMetadata
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

fn build_file_map(dirs []&HeropromptDir, prefix string) string {
	mut out := ''

	for i, dir in dirs {
		// Determine the correct tree connector
		connector := if i == dirs.len - 1 { '└── ' } else { '├── ' }

		// Directory name
		out += '${prefix}${connector}${dir.name}\n'

		// Files in this directory
		for j, file in dir.files {
			file_connector := if j == dir.files.len - 1 && dir.dirs.len == 0 {
				'└── '
			} else {
				'├── '
			}
			out += '${prefix}    ${file_connector}${file.name} *\n'
		}

		// Recurse into subdirectories
		if dir.dirs.len > 0 {
			new_prefix := if i == dirs.len - 1 { prefix + '    ' } else { prefix + '│   ' }
			out += build_file_map(dir.dirs, new_prefix)
		}
	}

	return out
}

fn (wsp HeropromptWorkspace) build_file_content() string {
	return ''
}

fn (wsp HeropromptWorkspace) build_prompt(text string) string {
	user_instructions := wsp.build_user_instructions(text)
	file_map := build_file_map(wsp.dirs, '')
	file_contents := wsp.build_file_content()

	// Handle reading the prompt file and parse it
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

fn get_file_extension(filename string) string {
	parts := filename.split('.')
	if parts.len < 2 {
		// Handle the files with no exe such as Dockerfile, LICENSE
		return ''
	}
	return parts[parts.len - 1]
}
