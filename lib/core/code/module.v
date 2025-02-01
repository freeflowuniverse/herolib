module code

import freeflowuniverse.herolib.core.pathlib
import os
import log

pub struct Module {
pub mut:
	name       string
	files      []IFile
	folders    []IFolder
	modules []Module
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
		path: '${path}/${mod.name}'
		empty: options.overwrite
	)!

	if !options.overwrite && module_dir.exists() {
		return
	}

	for file in mod.files {
		file.write(module_dir.path, options)!
	}

	for folder in mod.folders {
		folder.write(module_dir.path, options)!
	}

	for mod_ in mod.modules {
		mod_.write(module_dir.path, options)!
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
		os.execute('v doc -f html -o ${module_dir.path}/docs ${module_dir.path}')
	}

}
