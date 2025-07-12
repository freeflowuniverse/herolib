module docusaurus

import freeflowuniverse.herolib.develop.gittools
import freeflowuniverse.herolib.core.pathlib
import json
import os
import freeflowuniverse.herolib.osal
import freeflowuniverse.herolib.ui.console

pub fn (mut site DocSite) generate() ! {
	console.print_header(' site generate: ${site.name} on ${site.factory.path_build.path}')
	console.print_header(' site source on ${site.path_src.path}')

	//lets make sure we remove the cfg dir so we rebuild
	cfg_path := os.join_path(site.factory.path_build.path, 'cfg')
	osal.rm(cfg_path)!

	mut gs := gittools.new()!

	template_path := gs.get_path(
		pull:  false
		reset: false
		url:   'https://github.com/freeflowuniverse/docusaurus_template/src/branch/main/template/'
	)!

	//we need to copy the template each time for these 2 items, otherwise there can be leftovers from other run
	for item in ["src","static"]{
		mut template_src_path:=pathlib.get_dir(path:"${template_path}/${item}",create:true)!
		template_src_path.copy(dest: '${site.factory.path_build.path}/${item}', delete: true)!
		//now copy the info which can be overruled from source in relation to the template
		if os.exists("${site.path_src.path}/${item}"){
			mut src_path:=pathlib.get_dir(path:"${site.path_src.path}/${item}",create:false)!
			src_path.copy(dest: '${site.factory.path_build.path}/${item}', delete: false)!
		}
	}

	mut main_file := pathlib.get_file(path: '${cfg_path}/main.json', create: true)!
	main_file.write(json.encode(site.config.main))!

	mut navbar_file := pathlib.get_file(path: '${cfg_path}/navbar.json', create: true)!
	navbar_file.write(json.encode(site.config.navbar))!

	mut footer_file := pathlib.get_file(path: '${cfg_path}/footer.json', create: true)!
	footer_file.write(json.encode(site.config.footer))!
	
	mut aa := site.path_src.dir_get("docs")!
	aa.copy(dest: '${site.factory.path_build.path}/docs', delete: true)!

	site.download_collections()!


}


pub fn (mut site DocSite) download_collections() ! {

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