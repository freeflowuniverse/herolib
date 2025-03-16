module code

import freeflowuniverse.herolib.core.pathlib
import os

pub interface IFile {
	write(string, WriteOptions) !
	name string
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