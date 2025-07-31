module docusaurus

import freeflowuniverse.herolib.develop.gittools
import freeflowuniverse.herolib.core.pathlib
import json
import os
import freeflowuniverse.herolib.osal.core as osal
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.core.texttools.regext
import freeflowuniverse.herolib.web.site

pub fn (mut self DocSite) generate() ! {
	console.print_header(' site generate: ${self.name} on ${self.path_build.path}')
	console.print_header(' site source on ${self.path_src.path}')

	// lets make sure we remove the cfg dir so we rebuild
	cfg_path := os.join_path(self.path_build.path, 'cfg')
	osal.rm(cfg_path)!

	mut gs := gittools.new()!

	template_path := gs.get_path(
		pull:  false
		reset: false
		url:   'https://github.com/freeflowuniverse/docusaurus_template/src/branch/main/template/'
	)!

	for item in ['src', 'static'] {
		mut template_src_path := pathlib.get_dir(path: '${template_path}/${item}', create: true)!
		template_src_path.copy(dest: '${self.path_build.path}/${item}', delete: true)!
		// now copy the info which can be overruled from source in relation to the template
		src_item_path := os.join_path(self.path_src.path, item)
		if os.exists(src_item_path) {
			mut src_path := pathlib.get_dir(path: src_item_path, create: false)!
			src_path.copy(dest: '${self.path_build.path}/${item}', delete: false)!
		}
	}

	mut main_file := pathlib.get_file(path: '${cfg_path}/main.json', create: true)!
	main_file.write(json.encode_pretty(self.config.main))!

	mut navbar_file := pathlib.get_file(path: '${cfg_path}/navbar.json', create: true)!
	navbar_file.write(json.encode_pretty(self.config.navbar))!

	mut footer_file := pathlib.get_file(path: '${cfg_path}/footer.json', create: true)!
	footer_file.write(json.encode_pretty(self.config.footer))!

	docs_dest := os.join_path(self.path_build.path, 'docs')
	osal.rm(docs_dest)!
	osal.dir_ensure(docs_dest)!

	// Generate pages defined in site.heroscript (!!site.page ...)
	self.site.generate(
		path: docs_dest
		flat: true
	)!

	self.process_imports()!
}

pub fn (mut self DocSite) process_imports() ! {
	mut gs := gittools.new()!
	// Use the imports from the generic site config
	for item in self.site.siteconfig.imports {
		mypath := gs.get_path(
			pull:  false
			reset: false
			url:   item.url
		)!
		mut mypatho := pathlib.get(mypath)

		dest_path := '${self.path_build.path}/docs/${item.dest}'
		mypatho.copy(dest: dest_path, delete: true)!

		mut ri := regext.regex_instructions_new()
		for key, val in item.replace {
			ri.add_item('\{${key}\}', val)!
		}

		ri.replace_in_dir(
			path:       dest_path
			extensions: ['md']
		)!
	}
}
