module docusaurus

import freeflowuniverse.herolib.develop.gittools
import os
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.ui.console

@[params]
pub struct ImportParams {
	path      string
	git_url   string
	git_reset bool
	git_root  string
	git_pull  bool
	dest      string
}

pub fn (mut site DocSite) import() ! {
	for importparams in site.importparams {
		console.print_header('Importing: ${importparams.path} from ${importparams.git_url}')
		mut f := factory_get()!
		mut mypath := ''
		mut target_path := if os.is_abs_path(importparams.path) {
			importparams.path
		} else {
			os.abs_path(os.join_path(importparams.git_root, importparams.path))
		}

		// Use gittools to get/update the repo, then navigate to the specific path
		repo_path := gittools.get_repo_path(
			git_pull:  importparams.git_pull
			git_reset: importparams.git_reset
			git_url:   importparams.git_url
			path:      importparams.git_root
		)!

		mut mypatho := pathlib.get(repo_path)
		// TODO: We need to think about a better way to do it
		mypatho.path = repo_path + '/' + importparams.path.all_after('/')

		mut static_dest := '${f.path_build.path}/static'
		println('static_dest: ${static_dest}')

		if importparams.dest.len > 0 {
			static_dest = '${static_dest}/${importparams.dest}'
		}
		mypatho.copy(dest: static_dest, delete: false)!

		// println(item)
		// // replace: {'NAME': 'MyName', 'URGENCY': 'red'}
		// mut ri := regext.regex_instructions_new()
		// for key, val in item.replace {
		// 	ri.add_item('\{${key}\}', val)!
		// }
		// ri.replace_in_dir(
		// 	path:       '${f.path_build.path}/docs/${item.dest}'
		// 	extensions: [
		// 		'md',
		// 	]
		// )!
	}
}
