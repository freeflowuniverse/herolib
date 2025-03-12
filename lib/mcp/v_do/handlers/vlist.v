module handlers

import os
import freeflowuniverse.herolib.mcp.v_do.logger

// list_v_files returns all .v files in a directory (non-recursive), excluding generated files ending with _.v
fn list_v_files(dir string) ![]string {
	files := os.ls(dir) or { 
		return error('Error listing directory: $err')
	}
	
	mut v_files := []string{}
	for file in files {
		if file.ends_with('.v') && !file.ends_with('_.v') {
			filepath := os.join_path(dir, file)
			v_files << filepath
		}
	}
	
	return v_files
}
