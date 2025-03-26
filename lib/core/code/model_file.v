module code

import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.core.pathlib
import os

pub interface IFile {
	name string
	write(string, WriteOptions) !
}

pub struct File {
pub mut:
	name      string
	extension string
	content   string
}

pub fn (f File) write(path string, params WriteOptions) ! {
	mut fd_file := pathlib.get_file(path: '${path}/${f.name}.${f.extension}')!
	fd_file.write(f.content)!
	if f.extension == 'ts' {
		return f.typescript(path, params)
	}
}

pub fn (f File) typescript(path string, params WriteOptions) ! {
	if params.format {
		os.execute('npx prettier --write ${path}')
	}
}

pub struct VFile {
pub mut:
	name    string
	mod     string
	imports []Import
	consts  []Const
	items   []CodeItem
	content string
}

pub fn new_file(config VFile) VFile {
	return VFile{
		...config
		mod:   texttools.name_fix(config.mod)
		items: config.items
	}
}

pub fn (mut file VFile) add_import(import_ Import) ! {
	for mut i in file.imports {
		if i.mod == import_.mod {
			i.add_types(import_.types)
			return
		}
	}
	file.imports << import_
}

pub fn (code VFile) write(path string, options WriteOptions) ! {
	filename := '${options.prefix}${texttools.name_fix(code.name)}.v'
	mut filepath := pathlib.get('${path}/${filename}')

	if !options.overwrite && filepath.exists() {
		return
	}

	imports_str := code.imports.map(it.vgen()).join_lines()

	code_str := if code.content != '' {
		code.content
	} else {
		vgen(code.items)
	}

	consts_str := if code.consts.len > 1 {
		stmts := code.consts.map('${it.name} = ${it.value}')
		'\nconst(\n${stmts.join('\n')}\n)\n'
	} else if code.consts.len == 1 {
		'\nconst ${code.consts[0].name} = ${code.consts[0].value}\n'
	} else {
		''
	}

	mut file := pathlib.get_file(
		path:   filepath.path
		create: true
	)!

	mod_stmt := if code.mod == '' {
		''
	} else {
		'module ${code.mod}'
	}

	file.write('${mod_stmt}\n${imports_str}\n${consts_str}${code_str}')!
	if options.format {
		os.execute('v fmt -w ${file.path}')
	}
}

pub fn (file VFile) get_function(name string) ?Function {
	functions := file.items.filter(it is Function).map(it as Function)
	target_lst := functions.filter(it.name == name)

	if target_lst.len == 0 {
		return none
	}
	if target_lst.len > 1 {
		panic('This should never happen')
	}
	return target_lst[0]
}

pub fn (mut file VFile) set_function(function Function) ! {
	function_names := file.items.map(if it is Function { it.name } else { '' })

	index := function_names.index(function.name)
	if index == -1 {
		return error('function not found')
	}
	file.items[index] = function
}

pub fn (file VFile) functions() []Function {
	return file.items.filter(it is Function).map(it as Function)
}

pub fn (file VFile) structs() []Struct {
	return file.items.filter(it is Struct).map(it as Struct)
}
