module pathlib

import os
// import freeflowuniverse.herolib.ui.console

// path needs to be existing
// linkpath is where the link will be (the symlink who points to path)
pub fn (mut path Path) link(linkpath string, delete_exists bool) !Path {
	if !path.exists() {
		return error('cannot link because source ${path.path} does not exist')
	}
	if !(path.cat == .file || path.cat == .dir) {
		return error('cannot link because source ${path.path} can only be dir or file')
	}

	if path_equal(path.path, linkpath) {
		return error('try to link to myself. Link dest & source same. ${linkpath}')
	}
	// TODO: add test to confirm existing faulty link also  are removed
	// os.exists for faulty links returns false so also checks if path is link
	if os.exists(linkpath) || os.is_link(linkpath) {
		if delete_exists {
			mut linkpath_obj := get(linkpath)
			linkpath_obj.delete()!
		} else {
			return error('cannot link ${path.path} to ${linkpath}, because dest exists.')
		}
	}

	mut origin_path := ''
	dest_dir := os.dir(linkpath)
	if !os.exists(dest_dir) {
		os.mkdir_all(dest_dir)!
	}
	if path.cat == .dir {
		origin_path = path_relative(dest_dir, path.path)!
	} else {
		origin_path = path_relative(dest_dir, path.path)!
	}
	// console.print_debug("${dest_dir} ::: ${origin_path} ::: ${linkpath}")	

	msg := 'link to origin (source): ${path.path}  \nthe link:${linkpath} \nlink rel: ${origin_path}'
	// TODO: figure out why os.symlink doesn't work for linking file into dir
	os.symlink(origin_path, linkpath) or { return error('cant symlink ${msg}\n${err}') }
	return get(linkpath)
}

// will make sure that the link goes from file with largest path to smallest
// good to make sure we have links always done in same way
pub fn (mut path Path) relink() ! {
	if !path.is_link() {
		return
	}

	link_abs_path := path.absolute() // symlink not followed
	link_real_path := path.realpath() // this is with the symlink resolved
	if compare_strings(link_abs_path, link_real_path) >= 0 {
		// means the shortest path is the target (or if same size its sorted and the first)
		return
	}
	// need to switch link with the real content
	path.unlink()! // make sure both are files now (the link is the file)
	path.link(link_real_path, true)! // re-link
	path.check()

	// TODO: in test script
}

// resolve link to the real content
// copy the target of the link to the link
pub fn (mut path Path) unlink() ! {
	if !path.is_link() {
		// nothing to do because not link, will not giver error
		return
	}
	if path.is_dir() {
		return error('Cannot unlink a directory: ${path.path}')
	}
	link_abs_path := path.absolute()
	link_real_path := path.realpath() // this is with the symlink resolved
	mut link_path := get(link_real_path)
	// $if debug {
	// 	console.print_header(' copy source file:'$link_real_path' of link to link loc:'$link_abs_path'")
	// }
	mut destpath := get(link_abs_path + '.temp') // lets first copy to the .temp location
	link_path.copy(dest: destpath.path)! // copy to the temp location
	path.delete()! // remove the file or dir which is link
	destpath.rename(path.name())! // rename to the new path
	path.path = destpath.path // put path back
	path.check()
	// TODO: in test script
}

// return string
pub fn (mut path Path) readlink() !string {
	// console.print_stdout('path: $path')
	if path.is_link() {
		// console.print_stdout('path2: $path')
		cmd := 'readlink ${path.path}'
		res := os.execute(cmd)
		if res.exit_code > 0 {
			return error('cannot define result for link of ${path} \n${error}')
		}
		return res.output.trim_space()
	} else {
		return error('can only read link info when the path is a filelink or dirlink. ${path}')
	}
}

// return path object which is the result of the link (path link points too)
pub fn (mut path Path) getlink() !Path {
	if path.is_link() {
		return get(path.realpath())
	} else {
		return error('can only get link when the path is a filelink or dirlink. ${path}')
	}
}
