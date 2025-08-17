module codewalker

import freeflowuniverse.herolib.core.pathlib

pub struct CodeWalker {
pub mut:
	gitignore_patterns []string
	errors []CWError
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


@[params]
pub struct FileMapArgs{
pub mut:
	path string
	content string
}

pub fn (mut cw CodeWalker) filemap_get(args FileMapArgs) !FileMap {
	if args.path != '' {
		return cw.filemap_get_from_path(args.path)!
	} else if args.content != '' {
		return cw.filemap_get_from_content(args.content)!
	} else {
		return error('Either path or content must be provided to get FileMap')
	}
}

//get the filemap from a path
fn (mut cw CodeWalker) filemap_get_from_path(path string) !FileMap {
	mut dir := pathlib.get(path)
	if !dir.exists() {
		return error('Source directory "${path}" does not exist')
	}
	
	mut files := dir.list(recursive: true)!
	mut fm := FileMap{
		source: path
	}

	for mut file in files.paths {
		if file.is_file() {
			// Check if file should be ignored
			relpath := file.path_relative(path)!
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

fn (mut cw CodeWalker) error(msg string,linenr int,category string, fail bool) ! {
	cw.errors << CWError{
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

//internal function to get the filename
fn (mut cw CodeWalker) parse_filename_get(line string,linenr int) !string {
	parts := line.split('===')
	if parts.len < 2 {
		cw.error("Invalid filename line: ${line}.",linenr, "filename_get", true)!
	}
	mut name:=parts[1].trim_space()
	if name.len<2 {
		cw.error("Invalid filename, < 2 chars: ${name}.",linenr, "filename_get", true)!
	}
	return name
}

enum ParseState {
	start
	in_block
}

//get file, is the parser
fn (mut cw CodeWalker) filemap_get_from_content(content string) !FileMap {
	mut fm := FileMap{}

	mut filename := ""
	mut block := []string{}
	mut state := ParseState.start
	mut linenr := 0

	for line in content.split_into_lines() {
		mut line2 := line.trim_space()
		linenr += 1
		
		match state {
			.start {
				if line2.starts_with('===FILE') && !line2.ends_with('===') {
					filename = cw.parse_filename_get(line2, linenr)!
					if filename == "END" {
						cw.error("END found at start, not good.", linenr, "parse", true)!
						return error("END found at start, not good.")
					}
					state = .in_block
				} else if line2.len > 0 {
					cw.error("Unexpected content before first file block: '${line}'.", linenr, "parse", false)!
				}
			}
			.in_block {
				if line2.starts_with('===FILE') {
					if line2 == '===END===' {
						fm.content[filename] = block.join_lines()
						filename = ""
						block = []string{}
						state = .start
					} else if line2.ends_with('===') {
						fm.content[filename] = block.join_lines()
						filename = cw.parse_filename_get(line2, linenr)!
						if filename == "END" {
							cw.error("Filename 'END' is reserved.", linenr, "parse", true)!
							return error("Filename 'END' is reserved.")
						}
						block = []string{}
						state = .in_block
					} else {
						block << line
					}
				} else {
					block << line
				}
			}
		}
	}

	if state == .in_block && filename != '' {
		fm.content[filename] = block.join_lines()
	}

	return fm
}