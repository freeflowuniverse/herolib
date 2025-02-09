module docusaurus

import freeflowuniverse.herolib.develop.gittools
import freeflowuniverse.herolib.osal
import freeflowuniverse.herolib.installers.web.bun
import os

fn (mut site DocusaurusFactory) template_install(update bool) ! {
	mut gs := gittools.new()!

	mut r := gs.get_repo(
		url:  'https://github.com/freeflowuniverse/docusaurus_template.git'
		pull: update
	)!
	mut template_path := r.patho()!

	for item in ['package.json', 'sidebars.ts', 'tsconfig.json'] {
		mut aa := template_path.file_get(item)!
		aa.copy(dest: '${site.path_build.path}/${item}')!
	}

	// install bun
	mut installer := bun.get()!
	installer.install()!

	osal.exec(
		cmd: '
			${osal.profile_path_source_and()!} 
			export PATH=/tmp/docusaurus_build/node_modules/.bin:${os.home_dir()}/.bun/bin/:??PATH
			cd ${site.path_build.path}
			bun install
		'
	)!
}
