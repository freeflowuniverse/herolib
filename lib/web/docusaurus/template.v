module docusaurus

import freeflowuniverse.herolib.develop.gittools
import freeflowuniverse.herolib.osal
import freeflowuniverse.herolib.installers.web.bun
import os

@[params]
struct TemplateInstallArgs {
	template_update bool = true
	install         bool
	delete          bool = true
}

fn (mut self DocusaurusFactory) template_install(args TemplateInstallArgs) ! {
	mut gs := gittools.new()!

	mut r := gs.get_repo(
		url:  'https://github.com/freeflowuniverse/docusaurus_template.git'
		pull: args.template_update
	)!
	mut template_path := r.patho()!

	for item in ['package.json', 'sidebars.ts', 'tsconfig.json'] {
		mut aa := template_path.file_get(item)!
		aa.copy(dest: '${self.path_build.path}/${item}')!
	}

	// always start from template first
	for item in ['src', 'static'] {
		mut aa := template_path.dir_get(item)!
		aa.copy(dest: '${self.path_build.path}/${item}', delete: args.delete)!
	}

	for item in ['package.json', 'sidebars.ts', 'tsconfig.json', 'docusaurus.config.ts'] {
		src_path := os.join_path(template_path.path, item)
		dest_path := os.join_path(self.path_build.path, item)
		os.cp(src_path, dest_path) or {
			return error('Failed to copy ${item} to build path: ${err}')
		}
	}

	if args.install {
		// install bun
		mut installer := bun.get()!
		installer.install()!

		osal.exec(
			cmd: '
				${osal.profile_path_source_and()!} 
				export PATH=/tmp/docusaurus_build/node_modules/.bin:${os.home_dir()}/.bun/bin/:??PATH
				cd ${self.path_build.path}
				bun install
			'
		)!
	}

	mut aa := template_path.dir_get('docs') or { return }
	aa.delete()!
}
