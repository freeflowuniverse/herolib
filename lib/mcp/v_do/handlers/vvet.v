module handlers

import os
import freeflowuniverse.herolib.mcp.v_do.logger

// vvet runs v vet on the specified file or directory
pub fn vvet(fullpath string) !string {
	logger.info('vet $fullpath')
	if !os.exists(fullpath) {
		return error('File or directory does not exist: $fullpath')
	}

	if os.is_dir(fullpath) {
		mut results := ""
		files := list_v_files(fullpath) or {
			return error('Error listing V files: $err')
		}
		for file in files {
			results += vet_file(file) or {
				logger.error('Failed to vet $file: $err')
				return error('Failed to vet $file: $err')
			}
			results += '\n-----------------------\n'
		}
		return results
	} else {
		return vet_file(fullpath)
	}
}

// vet_file runs v vet on a single file
fn vet_file(file string) !string {
	cmd := 'v vet -v -w ${file}'
	logger.debug('Executing command: $cmd')
	result := os.execute(cmd)
	if result.exit_code != 0 {
		return error('Vet failed for $file with exit code ${result.exit_code}\n${result.output}')
	} else {
		logger.info('Vet completed for $file')
	}
	return 'Command: $cmd\nExit code: ${result.exit_code}\nOutput:\n${result.output}'
}
