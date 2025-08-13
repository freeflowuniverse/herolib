module docusaurus

import freeflowuniverse.herolib.develop.gittools
import os
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.core.texttools.regext



pub fn (mut docsite DocSite) import() ! {
	for importparams in docsite.website.siteconfig.imports {

		console.print_header('Importing: path:${importparams.path} or url:${importparams.url}')
	
		// pub struct ImportItem {
		// 	name    string // will normally be empty
		// 	url     string // http git url can be to specific path
		// 	path    string
		// 	dest    string            // location in the docs folder of the place where we will build the documentation site e.g. docusaurus
		// 	replace map[string]string // will replace ${NAME} in the imported content
		// 	visible bool = true
		// }

		c:=config()!

		// Use gittools to get path of what we want to import
		import_path := gittools.get_repo_path(
			git_pull:  c.reset
			git_reset: c.reset
			git_url:   importparams.url
			git_root:  c.coderoot
			path:      importparams.path
		)!

		mut import_patho := pathlib.get(import_path)

		if importparams.dest.starts_with("/") {
			return error("Import path ${importparams.dest} must be relative, will be relative in relation to the build dir.")
		}

		import_patho.copy(dest: '${c.path_build.path}/${importparams.dest}', delete: false)!

		// println(importparams)
		// replace: {'NAME': 'MyName', 'URGENCY': 'red'}
		mut ri := regext.regex_instructions_new()
		for key, val in importparams.replace {
			ri.add_item('\{${key}\}', val)!
		}
		ri.replace_in_dir(
			path:       '${c.path_build.path}/docs/${importparams.dest}'
			extensions: [
				'md',
			]
		)!
	}
}
