module heroprompt

// import freeflowuniverse.herolib.data.paramsparser
import freeflowuniverse.herolib.core.pathlib
import os

pub struct HeropromptFile {
pub mut:
	content string
	path    pathlib.Path
	name    string
}

// Utility function to get file extension with special handling for common files
pub fn get_file_extension(filename string) string {
	// Handle special cases for common files without extensions
	special_files := {
		'dockerfile':   'dockerfile'
		'makefile':     'makefile'
		'license':      'license'
		'readme':       'readme'
		'changelog':    'changelog'
		'authors':      'authors'
		'contributors': 'contributors'
		'copying':      'copying'
		'install':      'install'
		'news':         'news'
		'todo':         'todo'
		'version':      'version'
		'manifest':     'manifest'
		'gemfile':      'gemfile'
		'rakefile':     'rakefile'
		'procfile':     'procfile'
		'vagrantfile':  'vagrantfile'
	}

	// Convert to lowercase for comparison
	lower_filename := filename.to_lower()

	// Check if it's a special file without extension
	if lower_filename in special_files {
		return special_files[lower_filename]
	}

	// Handle dotfiles (files starting with .)
	if filename.starts_with('.') && !filename.starts_with('..') {
		// For files like .gitignore, .bashrc, etc.
		if filename.contains('.') && filename.len > 1 {
			parts := filename[1..].split('.')
			if parts.len >= 2 {
				return parts[parts.len - 1]
			} else {
				// Files like .gitignore, .bashrc (treat the whole name as extension type)
				return filename[1..]
			}
		} else {
			// Single dot files
			return filename[1..]
		}
	}

	// Regular files with extensions
	parts := filename.split('.')
	if parts.len < 2 {
		// Files with no extension - return empty string
		return ''
	}

	return parts[parts.len - 1]
}

// Read the file content
pub fn (fl HeropromptFile) read() !string {
	content := os.read_file(fl.path.path)!
	return content
}
