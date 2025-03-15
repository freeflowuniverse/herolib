module developer

import freeflowuniverse.herolib.mcp
import os

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

// test runs v test on the specified file or directory
pub fn vtest(fullpath string) !string {
	logger.info('test $fullpath')
	if !os.exists(fullpath) {		
		return error('File or directory does not exist: $fullpath')
	}
	if os.is_dir(fullpath) {
		mut results:=""
		for item in list_v_files(fullpath)!{
			results += vtest(item)!
			results += '\n-----------------------\n'
		}
		return results
	}else{
		cmd := 'v -gc none -stats -enable-globals -show-c-output -keepc -n -w -cg -o /tmp/tester.c -g -cc tcc test ${fullpath}'
		logger.debug('Executing command: $cmd')
		result := os.execute(cmd)
		if result.exit_code != 0 {
			return error('Test failed for $fullpath with exit code ${result.exit_code}\n${result.output}')
		} else {
			logger.info('Test completed for $fullpath')
		}
		return 'Command: $cmd\nExit code: ${result.exit_code}\nOutput:\n${result.output}'
	}
}


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

// cmd := 'v -gc none -stats -enable-globals -show-c-output -keepc -n -w -cg -o /tmp/tester.c -g -cc tcc ${fullpath}'