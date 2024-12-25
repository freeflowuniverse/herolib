module installer_client

import os
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.ui.console

@[params]
pub struct ScannerArgs {
pub mut:
	reset               bool     // regenerate all, dangerous !!!
	interactive         bool 	 //if we want to ask
	path                string
}

// scan over a set of directories call the play where
pub fn scan(args ScannerArgs) ! {

	if args.path == "" {
		scan(path:"${os.home_dir()}/code/github/freeflowuniverse/herolib/lib/installers")
		scan(path:"${os.home_dir()}/code/github/freeflowuniverse/herolib/lib/clients")
		return
	}

	console.print_header('Scan for generation of code for ${args.path}')

	// now walk over all directories, find .heroscript
	mut pathroot := pathlib.get_dir(path: args.path, create: false)!
	mut plist := pathroot.list(
		recursive:     true
		ignoredefault: false
		regex:         ['.heroscript']
	)!

	for mut p in plist.paths {
		pparent := p.parent()!
		path_module := pparent.path
		if os.exists("${path_module}/.heroscript"){
			do(interactive:args.interactive,path:path_module,reset:args.reset)!
		}
	}

}
