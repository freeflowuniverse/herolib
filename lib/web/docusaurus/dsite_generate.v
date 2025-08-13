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

	// lets make sure we remove the cfg dir so we rebuild
	cfg_path := os.join_path(f.path_build.path)
	osal.rm(cfg_path)!

	mut gs := gittools.new()!

	template_path := gs.get_path(
		pull:  false
		reset: false
		url:   'https://github.com/freeflowuniverse/docusaurus_template/src/branch/main/template/'
	)!

	osal.rm('${f.path_build.path}/docs')!

	mut main_file := pathlib.get_file(path: '${cfg_path}/main.json', create: true)!
	main_file.write(json.encode_pretty(site.config.main))!

	mut navbar_file := pathlib.get_file(path: '${cfg_path}/navbar.json', create: true)!
	navbar_file.write(json.encode_pretty(site.config.navbar))!

	mut footer_file := pathlib.get_file(path: '${cfg_path}/footer.json', create: true)!
	footer_file.write(json.encode_pretty(site.config.footer))!

	// Generate the actual docs content from the processed site configuration
	docs_path := '${f.path_build.path}/docs'

	// TODO: check site vs website
	website := site.website
	generate_docs(
		path: docs_path
		site: website
	)!

	site.import()!

}
