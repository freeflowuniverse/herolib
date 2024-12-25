module nodejs

import freeflowuniverse.herolib.osal
// import freeflowuniverse.herolib.ui.console
// import freeflowuniverse.herolib.core.texttools
// import freeflowuniverse.herolib.installers.base

@[params]
pub struct InstallArgs {
pub mut:
	reset bool
}

pub fn install(args_ InstallArgs) ! {
	_ := args_
	pl := osal.platform()
	if pl == .arch {
		osal.package_install('npm')!
	} else {
		return error('only support arch for now')
	}
}
