module docusaurus

import os
import strings

// clean removes temporary files and build artifacts from the site directory
pub fn (mut site DocSite) clean(args ...ErrorArgs) ! {
	toclean := '
		/node_modules

		babel.config.js

		# Production
		/build

		# Generated files
		.docusaurus
		.cache-loader

		# Misc
		.DS_Store
		.env.local
		.env.development.local
		.env.test.local
		.env.production.local

		npm-debug.log*
		yarn-debug.log*
		yarn-error.log*
		bun.lockb
		bun.lock

		yarn.lock

		build.sh
		build_dev.sh
		build-dev.sh		
		develop.sh
		install.sh

		package.json
		package-lock.json
		pnpm-lock.yaml

		sidebars.ts

		tsconfig.json
		'

	mut sb := strings.new_builder(200)
	for line in toclean.split_into_lines() {
		clean_line := line.trim_space()
		if clean_line == '' || clean_line.starts_with('#') {
			continue
		}

		// Remove leading slash if present to make path relative
		path_to_clean := if clean_line.starts_with('/') {
			clean_line[1..]
		} else {
			clean_line
		}

		full_path := os.join_path(site.path_src.path, path_to_clean)

		// Handle glob patterns (files ending with *)
		if path_to_clean.ends_with('*') {
			base_pattern := path_to_clean#[..-1] // Remove the * at the end
			base_dir := os.dir(full_path)
			if os.exists(base_dir) {
				files := os.ls(base_dir) or {
					sb.writeln('Failed to list directory ${base_dir}: ${err}')
					continue
				}
				for file in files {
					if file.starts_with(base_pattern) {
						file_path := os.join_path(base_dir, file)
						os.rm(file_path) or { sb.writeln('Failed to remove ${file_path}: ${err}') }
					}
				}
			}
			continue
		}

		// Handle regular files and directories
		if os.exists(full_path) {
			if os.is_dir(full_path) {
				os.rmdir_all(full_path) or {
					sb.writeln('Failed to remove directory ${full_path}: ${err}')
				}
			} else {
				os.rm(full_path) or { sb.writeln('Failed to remove file ${full_path}: ${err}') }
			}
		}
	}
}
