module imagemagick

import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.osal.core as osal
import freeflowuniverse.herolib.ui.console
import os

@[params]
struct DownsizeArgsInternal {
	backup      bool
	backup_root string
	backup_dest string
	redo        bool
	convertpng  bool
}

// will downsize to reasonable size based on x
pub fn (mut image Image) downsize(args DownsizeArgsInternal) ! {
	if image.path.is_link() {
		return error('cannot downsize if path is link.\n${image}')
	}
	image.init_()!
	if image.skip() {
		return
	}
	// $if debug{console.print_header(' downsize $image.path')}
	if image.is_png() {
		image.identify_verbose()!
	} else {
		image.identify()!
	}
	// check in params
	if args.backup {
		image.path.backup(dest: args.backup_dest, root: args.backup_root)!
	}

	if image.is_png() {
		if image.size_kbyte > 500 && image.size_x > 2400 {
			image.size_kbyte = 0
			console.print_debug('   - resize 50%: ${image.path.path}')
			cmd := "convert '${image.path.path}' -resize 50% '${image.path.path}'"
			osal.execute_silent(cmd) or {
				return error('could not convert to png --resize 50%.\n${cmd} .\n${error}')
			}
			// console.print_debug(image)
			image.init_()!
		} else if image.size_kbyte > 500 && image.size_x > 1600 {
			image.size_kbyte = 0
			console.print_debug('   - resize 75%: ${image.path.path}')
			cmd := "convert '${image.path.path}' -resize 75% '${image.path.path}'"
			osal.execute_silent(cmd) or {
				return error('could not convert to png --resize 75%.\n${cmd} \n${error}')
			}
			image.init_()!
		}
	}

	if image.is_png() && args.convertpng {
		if image.size_kbyte > 500 {
			if image.transparent && image.size_kbyte < 900 {
				console.print_header(' image ${image.path.path} sizekb:${image.size_kbyte} transparent so skip. ')
				return
			}
			path_dest := image.path.path_no_ext() + '.jpg'
			console.print_debug('   - convert to png: ${path_dest.str()}')
			cmd := "convert '${image.path.path}' '${path_dest}'"
			if os.exists(path_dest) {
				os.rm(path_dest)!
			}
			osal.execute_silent(cmd) or {
				return error('could not convert png to jpg.\n${cmd} \n${error}')
			}
			if os.exists(image.path.path) {
				os.rm(image.path.path)!
			}
			image.path = pathlib.get(path_dest)
		}
	}

	mut parent := image.path.parent()!
	mut p := parent.file_get_new('.done')!
	mut c := p.read()!
	if c.contains(image.path.name()) {
		console.print_debug(image.str())
		print_backtrace()
		panic('bug')
	}
	c += '${image.path.name()}\n'
	p.write(c)!
}
