module docusaurus

import freeflowuniverse.herolib.develop.gittools
import freeflowuniverse.herolib.core.pathlib
import json
import os
import freeflowuniverse.herolib.ui.console

@[params]
struct TemplateInstallArgs {
	template_update bool = true
	install         bool = true
	delete          bool = true
}

pub fn (mut site DocSite) generate() ! {
	console.print_header(' site generate: ${site.name} on ${site.path_build.path}')
	console.print_header(' site source on ${site.path_src.path}')
	site.check()!
	site.template_install()!

	site.config = fix_configuration(site.config)!

	cfg_path := os.join_path(site.path_build.path, 'cfg')

	mut main_file := pathlib.get_file(path: '${cfg_path}/main.json', create: true)!
	main_file.write(json.encode(site.config.main))!

	mut navbar_file := pathlib.get_file(path: '${cfg_path}/navbar.json', create: true)!
	navbar_file.write(json.encode(site.config.navbar))!

	mut footer_file := pathlib.get_file(path: '${cfg_path}/footer.json', create: true)!
	footer_file.write(json.encode(site.config.footer))!
	
	mut aa := site.path_src.dir_get("docs")!
	aa.copy(dest: '${site.path_build.path}/docs', delete: true)!

	// mut gs := gittools.new()!
	// for item in site.config.import_sources {
	// 	mypath := gs.get_path(
	// 		pull:  false
	// 		reset: false
	// 		url:   item.url
	// 	)!
	// 	mut mypatho := pathlib.get(mypath)
	// 	site.process_md(mut mypatho, item)!
	// }
}
