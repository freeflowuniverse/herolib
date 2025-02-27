module vfs_db

// str returns a formatted string of directory contents (non-recursive)
pub fn (mut fs DatabaseVFS) directory_print(dir Directory) string {
	mut result := '${dir.metadata.name}/\n'

	for child_id in dir.children {
		if entry := fs.load_entry(child_id) {
			if entry is Directory {
				result += '  📁 ${entry.metadata.name}/\n'
			} else if entry is File {
				result += '  📄 ${entry.metadata.name}\n'
			} else if entry is Symlink {
				result += '  🔗 ${entry.metadata.name} -> ${entry.target}\n'
			}
		}
	}
	return result
}

// printall prints the directory structure recursively
pub fn (mut fs DatabaseVFS) directory_printall(dir Directory, indent string) !string {
	mut result := '${indent}📁 ${dir.metadata.name}/\n'

	for child_id in dir.children {
		mut entry := fs.load_entry(child_id)!
		if mut entry is Directory {
			result += fs.directory_printall(entry, indent + '  ')!
		} else if mut entry is File {
			result += '${indent}  📄 ${entry.metadata.name}\n'
		} else if mut entry is Symlink {
			result += '${indent}  🔗 ${entry.metadata.name} -> ${entry.target}\n'
		}
	}
	return result
}
