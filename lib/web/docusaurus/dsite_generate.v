module docusaurus

import freeflowuniverse.herolib.develop.gittools
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.core.playbook
import json
import os
import freeflowuniverse.herolib.osal.core as osal
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.core.texttools.regext
// import freeflowuniverse.herolib.data.doctree
import freeflowuniverse.herolib.web.site as sitegen

pub fn (mut site DocSite) generate() ! {
	mut f := factory_get()!

	console.print_header(' site generate: ${site.name} on ${f.path_build.path}')
	console.print_header(' site source on ${site.path_src.path}')

	// lets make sure we remove the cfg dir so we rebuild
	cfg_path := os.join_path(f.path_build.path, 'cfg')
	osal.rm(cfg_path)!

	mut gs := gittools.new()!

	template_path := gs.get_path(
		pull:  false
		reset: false
		url:   'https://github.com/freeflowuniverse/docusaurus_template/src/branch/main/template/'
	)!

	// we need to copy the template each time for these 2 items, otherwise there can be leftovers from other run
	for item in ['src', 'static'] {
		mut template_src_path := pathlib.get_dir(path: '${template_path}/${item}', create: true)!
		template_src_path.copy(dest: '${f.path_build.path}/${item}', delete: true)!
		// now copy the info which can be overruled from source in relation to the template
		if os.exists('${site.path_src.path}/${item}') {
			mut src_path := pathlib.get_dir(path: '${site.path_src.path}/${item}', create: false)!
			src_path.copy(dest: '${f.path_build.path}/${item}', delete: false)!
		}
	}

	osal.rm('${f.path_build.path}/docs')!

	if os.exists('${site.path_src.path}/docs') {
		mut aa := site.path_src.dir_get('docs')!
		aa.copy(dest: '${f.path_build.path}/docs', delete: true)!
	}

	// now we need to process the pages, call the sitegen module, which will look for statements like
	// !!site.page sitename:'atest'
	// 		path:"crazy/sub.md" position:1
	// 		src:"marketplace_specs:tft_tfp_marketplace"
	// 		title:"Just a Page"
	// 		description:"A description not filled in"
	// 		draft:1 hide_title:1

	configpath := '${site.path_src.path}/cfg'

	// Create a playbook from the config path and run site processing
	mut plbook := playbook.new(path: configpath)!
	sitegen.play(mut plbook)!

	// Get the updated site object after processing
	mut website := sitegen.get(name: site.name)!


	mut main_file := pathlib.get_file(path: '${cfg_path}/main.json', create: true)!
	main_file.write(json.encode_pretty(site.config.main))!

	mut navbar_file := pathlib.get_file(path: '${cfg_path}/navbar.json', create: true)!
	navbar_file.write(json.encode_pretty(site.config.navbar))!

	mut footer_file := pathlib.get_file(path: '${cfg_path}/footer.json', create: true)!
	footer_file.write(json.encode_pretty(site.config.footer))!


	// Generate the actual docs content from the processed site configuration
	docs_path := '${f.path_build.path}/docs'

	//TODO: check site vs website
	website := site.website
	generate_docs(
		path: docs_path
		site: website
	)!

	site.process_imports()!
}

pub fn (mut site DocSite) process_imports() ! {
	mut gs := gittools.new()!
	mut f:=factory_get()!

	for item in site.website.siteconfig.imports {
		mypath := gs.get_path(
			pull:  false
			reset: false
			url:   item.url
		)!
		mut mypatho := pathlib.get(mypath)

		mypatho.copy(dest: '${f.path_build.path}/docs/${item.dest}', delete: false)!

		println(item)
		replace: {'NAME': 'MyName', 'URGENCY': 'red'}
		mut ri := regext.regex_instructions_new()
		for key, val in item.replace {
			ri.add_item('\{${key}\}', val)!
		}

		ri.replace_in_dir(
			path:       '${f.path_build.path}/docs/${item.dest}'
			extensions: [
				'md',
			]
		)!
	}
// }
