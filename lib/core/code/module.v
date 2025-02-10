module code

import freeflowuniverse.herolib.core.pathlib
import os
import log

pub struct Module {
pub mut:
	name       string
	description string
	version string = '0.0.1'
	license string = 'apache2'
	vcs string = 'git'
	files      []IFile
	folders    []IFolder
	modules []Module
	in_src bool // whether mod will be generated in src folder
	// model   VFile
	// methods VFile
}

pub fn new_module(mod Module) Module {
	return Module {
		...mod
		files: mod.files.map(
			if it is VFile {
				IFile(VFile{...it, mod: mod.name})
			} else {it}
		)
	}
}

pub fn (mod Module) write(path string, options WriteOptions) ! {
	mut module_dir := pathlib.get_dir(
		path: if mod.in_src { '${path}/${mod.name}/src' } else { '${path}/${mod.name}' }
		empty: options.overwrite
	)!

	if !options.overwrite && module_dir.exists() {
		return
	}

	for file in mod.files {
		file.write(module_dir.path, options)!
	}

	for folder in mod.folders {
		folder.write('${path}/${mod.name}', options)!
	}

	for mod_ in mod.modules {
		mod_.write('${path}/${mod.name}', options)!
	}

	if options.format {
		os.execute('v fmt -w ${module_dir.path}')
	}
	if options.compile {
		os.execute_opt('v -n -w -enable-globals -shared ${module_dir.path}') or {
			log.fatal(err.msg())
		}
	}
	if options.test {
		os.execute_opt('v -n -w -enable-globals test ${module_dir.path}') or {
			log.fatal(err.msg())
		}
	}
	if options.document {
		docs_path := '${path}/${mod.name}/docs'
		os.execute('v doc -f html -o ${docs_path} ${module_dir.path}')
	}

	mut mod_file := pathlib.get_file(path: '${module_dir.path}/v.mod')!
	mod_file.write($tmpl('templates/v.mod.template'))!
}
