module docusaurus

import freeflowuniverse.herolib.osal.screen
import freeflowuniverse.herolib.develop.gittools
import os
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.web.site as sitemodule
import freeflowuniverse.herolib.osal.core as osal
import freeflowuniverse.herolib.ui.console
import time

@[params]
pub struct ImportParams {
	path string
	git_url string
	git_reset bool
	git_root string
	git_pull bool
}
pub fn (mut site DocSite) import(args ImportParams) ! {

	mypath := gittools.get_repo_path(
		git_pull:  args.git_pull
		git_reset: args.git_reset
		git_url:   args.git_url
		path: args.path
	)!

	println(site)
	if true{panic("3456789")}

	mut mypatho := pathlib.get(mypath)

	// mypatho.copy(dest: '${f.path_build.path}/docs/${item.dest}', delete: false)!

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
