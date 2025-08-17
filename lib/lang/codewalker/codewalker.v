module codewalker

import freeflowuniverse.herolib.core.pathlib

pub struct CodeWalker {
pub mut:
	source           string
	gitignore_patterns []string
	errors []Error
}

fn (cw CodeWalker) default_gitignore() []string {
	return [
		'__pycache__/',
		'*.py[cod]',
		'*\$py.class',
		'*.so',
		'.Python',
		'build/',
		'develop-eggs/',
		'dist/',
		'downloads/',
		'eggs/',
		'.eggs/',
		'lib/',
		'lib64/',
		'parts/',
		'sdist/',
		'var/',
		'wheels/',
		'*.egg-info/',
		'.installed.cfg',
		'*.egg',
		'.env',
		'.venv',
		'venv/',
		'.tox/',
		'.nox/',
		'.coverage',
		'.coveragerc',
		'coverage.xml',
		'*.cover',
		'*.gem',
		'*.pyc',
		'.cache',
		'.pytest_cache/',
		'.mypy_cache/',
		'.hypothesis/',
	]
}

pub fn (mut cw CodeWalker) walk() !FileMap {

	if cw.source == '' {
		return error('Source path is not set')
	}
	mut dir := pathlib.get(cw.source)
	if !dir.exists() {
		return error('Source directory "${cw.source}" does not exist')
	}
	
	mut files := dir.list(recursive: true)!

	mut fm := FileMap{
		source:cw.source
	}

	for mut file in files.paths {
		if file.is_file() {
			// Check if file should be ignored
			relpath := file.path_relative(cw.source)!
			mut should_ignore := false
			
			for pattern in cw.gitignore_patterns {
				if relpath.contains(pattern.trim_right('/')) || 
				   (pattern.ends_with('/') && relpath.starts_with(pattern)) {
					should_ignore = true
					break
				}
			}			
			if !should_ignore {
				content := file.read()!
				fm.content[relpath] = content
			}
		}
	}
	return fm
}

pub fn (mut cw CodeWalker) error(msg string,linenr int,category string, fail bool) ! {
	cw.errors << Error{
		message: msg
		linenr: linenr
		category: category
	}
	if fail {
		mut errormsg:= ""
		for e in cw.errors {
			errormsg += "${e.message} (line ${e.linenr}, category: ${e.category})\n"
		}
		return error(msg)
	}
}

fn (mut cw CodeWalker) filename_get(line string,linenr int) !string {
	parts := line.split('===')
	if parts.len < 2 {
		return cw.error("Invalid filename line: ${line}.",linenr, "filename_get", true)!
	}
	mut name:=parts[1].trim_space() or {panic("bug")}
	if name.len<2 {
		return cw.error("Invalid filename, < 2 chars: ${name}.",linenr, "filename_get", true)!
	}
	return name
}

enum ParseState {
	start
	blockfound
	in_block
	end
}

pub fn (mut cw CodeWalker) parse(content string) !FileMap {

	mut fm := FileMap{
		source: cw.source
	}

	mut filename := ""
	mut block := []string{}
	mut state := ParseState.start
	mut linenr:=0 

	//lets first cleanup	

	for line in content.split_into_lines() {

		mut line2 := line.trim_space()
		linenr+=1
		// Process each line and extract relevant information
		if state == .start && line2.starts_with('===') {
			filename=cw.filename_get(line,linenr)!
			if filename == "END" {
				cw.error("END found in ${line} at start not good.",linenr,"parse",true)!
			}
		}

		if ( state == .blockfound || state == .in_block ) && line2.starts_with('===')  && line2.ends_with('===') {
			filenamenew=cw.filename_get(line2,linenr)!
			if filenamenew == "END" {
				//we are at end of file
				state = .end
				fm.content[filename] = block.join_lines()
				continue
			}

			//means we now have new block
			state = .blockfound
			fm.content[filename] = block.join_lines()
			block = []string{}
			filename = filenamenew
			continue
		}

		if line2.starts_with('===') && line2.ends_with('===') {
			cw.error("=== found in ${line2} at wrong location.",linenr,"parse",true)!
		}

		if status == .in_block {
			output << line
		}

	}

	return fm
}