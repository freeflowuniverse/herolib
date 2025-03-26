module code

import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.core.pathlib
import os
import log

pub struct Module {
pub mut:
	name        string
	description string
	version     string = '0.0.1'
	license     string = 'apache2'
	vcs         string = 'git'
	files       []IFile
	folders     []IFolder
	modules     []Module
	in_src      bool // whether mod will be generated in src folder
}

pub fn new_module(mod Module) Module {
	return Module{
		...mod
		files: mod.files.map(if it is VFile {
			IFile(VFile{ ...it, mod: mod.name })
		} else {
			it
		})
	}
}

pub fn (mod Module) write(path string, options WriteOptions) ! {
	mut module_dir := pathlib.get_dir(
		path:  if mod.in_src { '${path}/src' } else { '${path}/${mod.name}' }
		empty: options.overwrite
	)!
	console.print_debug('write ${module_dir.path}')
	// pre:="v -n -w -enable-globals"
	pre := 'v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run'

	if !options.overwrite && module_dir.exists() {
		return
	}

	for file in mod.files {
		console.print_debug('mod file write ${file.name}')
		file.write(module_dir.path, options)!
	}

	for folder in mod.folders {
		console.print_debug('mod folder write ${folder.name}')
		folder.write('${path}/${mod.name}', options)!
	}

	for mod_ in mod.modules {
		console.print_debug('mod write ${mod_.name}')
		mod_.write('${path}/${mod.name}', options)!
	}

	if options.format {
		console.print_debug('format ${module_dir.path}')
		os.execute('v fmt -w ${module_dir.path}')
	}
	if options.compile {
		console.print_debug('compile shared ${module_dir.path}')
		os.execute_opt('${pre} -shared ${module_dir.path}') or { log.fatal(err.msg()) }
	}
	if options.test {
		console.print_debug('test ${module_dir.path}')
		os.execute_opt('${pre} test ${module_dir.path}') or { log.fatal(err.msg()) }
	}
	if options.document {
		docs_path := '${path}/${mod.name}/docs'
		console.print_debug('document ${module_dir.path}')
		os.execute('v doc -f html -o ${docs_path} ${module_dir.path}')
	}

	mut mod_file := pathlib.get_file(path: '${module_dir.path}/v.mod')!
	mod_file.write($tmpl('templates/v.mod.template'))!
}
