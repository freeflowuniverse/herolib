module ourdb

import os

// Embed the extension files directly into the binary
#embed_file extension_js_content := 'extension.js'
#embed_file package_json_content := 'package.json'
#embed_file readme_content := 'README.md'

// VSCodeExtension represents the OurDB VSCode extension
pub struct VSCodeExtension {
pub mut:
	extension_dir string
}

// new creates a new VSCodeExtension instance
pub fn new() !VSCodeExtension {
	// Determine the extension directory based on OS
	extension_dir := get_extension_dir()

	return VSCodeExtension{
		extension_dir: extension_dir
	}
}

// get_extension_dir determines the VSCode extension directory based on OS
fn get_extension_dir() string {
	home_dir := os.home_dir()

	// Extension directory path based on OS
	return os.join_path(home_dir, '.vscode', 'extensions', 'local-herolib.ourdb-viewer-0.0.1')
}

// install installs the OurDB VSCode extension
pub fn (mut ext VSCodeExtension) install() ! {
	// Check if already installed
	if ext.is_installed() {
		println('OurDB VSCode extension is already installed at: ${ext.extension_dir}')
		println('To reinstall, first uninstall using the uninstall() function')
		return
	}

	// Create extension directory if it doesn't exist
	os.mkdir_all(ext.extension_dir) or {
		return error('Failed to create extension directory: ${err}')
	}

	// Write embedded files to the extension directory
	// extension.js
	os.write_file(os.join_path(ext.extension_dir, 'extension.js'), extension_js_content.to_string()) or {
		return error('Failed to write extension.js: ${err}')
	}

	// package.json
	os.write_file(os.join_path(ext.extension_dir, 'package.json'), package_json_content.to_string()) or {
		return error('Failed to write package.json: ${err}')
	}

	// README.md
	os.write_file(os.join_path(ext.extension_dir, 'README.md'), readme_content.to_string()) or {
		return error('Failed to write README.md: ${err}')
	}

	println('OurDB Viewer extension installed to: ${ext.extension_dir}')
	println('Please restart VSCode for the changes to take effect.')
	println('After restarting, you should be able to open .ourdb files.')

	return
}

// uninstall removes the OurDB VSCode extension
pub fn (mut ext VSCodeExtension) uninstall() ! {
	if os.exists(ext.extension_dir) {
		os.rmdir_all(ext.extension_dir) or {
			return error('Failed to remove extension directory: ${err}')
		}

		println('OurDB Viewer extension uninstalled from: ${ext.extension_dir}')
		println('Please restart VSCode for the changes to take effect.')
	} else {
		println('Extension not found at: ${ext.extension_dir}')
	}

	return
}

// is_installed checks if the extension is installed
pub fn (ext VSCodeExtension) is_installed() bool {
	return os.exists(ext.extension_dir)
		&& os.exists(os.join_path(ext.extension_dir, 'extension.js'))
		&& os.exists(os.join_path(ext.extension_dir, 'package.json'))
}

// install_extension is a convenience function to install the extension
pub fn install_extension() ! {
	mut ext := new() or { return error('Failed to initialize extension: ${err}') }

	ext.install() or { return error('Failed to install extension: ${err}') }
}

// uninstall_extension is a convenience function to uninstall the extension
pub fn uninstall_extension() ! {
	mut ext := new() or { return error('Failed to initialize extension: ${err}') }

	ext.uninstall() or { return error('Failed to uninstall extension: ${err}') }
}
