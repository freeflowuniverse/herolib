module docusaurus

import freeflowuniverse.herolib.develop.gittools
import freeflowuniverse.herolib.osal
import freeflowuniverse.herolib.installers.web.bun
import freeflowuniverse.herolib.core.pathlib
import os

@[params]
struct TemplateInstallArgs {
mut:
	template_update bool = true
	install         bool
	delete          bool
}

// copy template in build location
fn (mut self DocusaurusFactory) template_install(args_ TemplateInstallArgs) ! {
	mut gs := gittools.new()!
	mut args := args_

	template_path := gs.get_path(
		pull:  args.template_update
		reset: args.delete
		url:   'https://github.com/freeflowuniverse/docusaurus_template/src/branch/main/template'
	)!

	mut template_path0 := pathlib.get_dir(path: template_path, create: false)!

	template_path0.copy(dest: '${self.path_build.path}', delete: args.delete)!

	if !os.exists('${self.path_build.path}/node_modules') {
		args.install = true
	}

	if args.install {
		// install bun
		mut installer := bun.get()!
		installer.install()!
		osal.exec(
			// always stay in the context of the build directory
			cmd: '
				${osal.profile_path_source_and()!} 
				export PATH=${self.path_build.path}/node_modules/.bin::${os.home_dir()}/.bun/bin/:\$PATH
				cd ${self.path_build.path}
				bun install
			'
		)!
	}
}
