module docusaurus

import os
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.develop.gittools
import freeflowuniverse.herolib.osal.core as osal
import freeflowuniverse.herolib.installers.web.bun


fn (mut f DocSiteFactory) install(reset bool, template_update bool) ! {
	mut gs := gittools.new()!

	if reset {
		osal.rm(f.path_build.path)!
		osal.dir_ensure(f.path_build.path)!
	}

	template_path := gs.get_path(
		pull:  template_update
		reset: reset // Changed args.delete to args.reset
		url:   'https://github.com/freeflowuniverse/docusaurus_template/src/branch/main/template'
	)!

	mut template_path0 := pathlib.get_dir(path: template_path, create: false)!

	template_path0.copy(dest: f.path_build.path, delete:reset)! // Changed args.delete to args.reset

    // install bun
    mut installer := bun.get()!
    installer.install()!
    osal.exec(
        // always stay in the context of the build directory
        cmd: '
            ${osal.profile_path_source_and()!} 
            export PATH=${f.path_build.path}/node_modules/.bin::${os.home_dir()}/.bun/bin/:\$PATH
            cd ${f.path_build.path}
            bun install
        '
    )!

}