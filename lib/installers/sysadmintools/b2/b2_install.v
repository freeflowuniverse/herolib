module b2

import freeflowuniverse.herolib.osal
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.lang.python
// import os


pub fn installll(args_ InstallArgs) ! {
	mut args := args_

	if args.reset == false && osal.done_exists('install_b2') {
		return
	}

	console.print_header('install b2')

	mut py := python.new(name: 'default')! // a python env with name test
	py.update()!
	py.pip('b2')!

	osal.done_set('install_b2', 'OK')!

	return
}
