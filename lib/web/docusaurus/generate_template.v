module docusaurus

import freeflowuniverse.herolib.develop.gittools
import freeflowuniverse.herolib.osal
import freeflowuniverse.herolib.installers.web.bun


fn (mut self DocusaurusFactory) template_install(args TemplateInstallArgs) ! {
	mut gs := gittools.new()!

	mut r := gs.get_repo(
		url:  'https://github.com/freeflowuniverse/docusaurus_template.git'
		pull: args.template_update
	)!
	mut template_path := r.patho()!
	template_path.copy(dest: '${self.path_build.path}/template/', delete: args.delete)!

	if args.install {
		// install bun
		mut installer := bun.get()!
		installer.install()!
		osal.exec(
			//always stay in the context of the build directory
			cmd: '
				${osal.profile_path_source_and()!} 
				export PATH=${self.path_build}/node_modules/.bin::??{HOME}/.bun/bin/:??PATH
				cd ${self.path_build.path}
				bun install
			'
		)!
	}
}
