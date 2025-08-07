module docusaurus

import freeflowuniverse.herolib.develop.gittools
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.core.playbook
import json
import os
import freeflowuniverse.herolib.osal.core as osal
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.data.doctree
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

	// We'll generate the configuration files after processing the site
	// This is moved to after sitegen.play() so we can use the processed site configuration

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
	// The site name in the config might be different from the docusaurus site name
	// Find the site with the most pages (should contain the processed page definitions)
	available_sites := sitegen.list()
	mut best_site := &sitegen.Site(unsafe { nil })
	mut max_pages := 0

	for site_name in available_sites {
		mut test_site := sitegen.get(name: site_name) or { continue }
		if test_site.pages.len > max_pages {
			max_pages = test_site.pages.len
			best_site = test_site
		}
	}

	if best_site == unsafe { nil } || max_pages == 0 {
		return error('No sites with pages found after processing playbook. Available sites: ${available_sites}')
	}

	mut updated_site := best_site

	// Generate the configuration files using the processed site configuration
	mut updated_config := new_configuration(updated_site.siteconfig)!

	mut main_file := pathlib.get_file(path: '${cfg_path}/main.json', create: true)!
	main_file.write(json.encode_pretty(updated_config.main))!

	mut navbar_file := pathlib.get_file(path: '${cfg_path}/navbar.json', create: true)!
	navbar_file.write(json.encode_pretty(updated_config.navbar))!

	mut footer_file := pathlib.get_file(path: '${cfg_path}/footer.json', create: true)!
	footer_file.write(json.encode_pretty(updated_config.footer))!

	// Fix the index.tsx redirect to handle baseUrl properly
	// When baseUrl is not '/', we need to use an absolute redirect path
	if updated_config.main.base_url != '/' {
		index_tsx_path := '${f.path_build.path}/src/pages/index.tsx'
		if os.exists(index_tsx_path) {
			// Create the corrected index.tsx content
			fixed_index_content := "import React from 'react';
import { Redirect } from '@docusaurus/router';
import main from '../../cfg/main.json';

export default function Home() {
  // Use absolute redirect path when baseUrl is not root
  const redirectPath = main.baseUrl + main.url_home;
  return <Redirect to={redirectPath} />;
}"

			mut index_file := pathlib.get_file(path: index_tsx_path, create: false)!
			index_file.write(fixed_index_content)!
		}
	}

	// Scan and export doctree collections to Redis before generating docs
	// This ensures the doctreeclient can access the collections when generating pages
	console.print_header(' scanning doctree collections for site: ${site.name}')

	// Find the collections directory relative to the source path
	// The collections should be in the parent directory of the ebooks
	mut collections_path := ''

	// Try to find collections directory by going up from the source path
	mut current_path := pathlib.get_dir(path: site.path_src.path)!
	for _ in 0 .. 5 { // Search up to 5 levels up
		collections_candidate := '${current_path.path}/collections'
		if os.exists(collections_candidate) {
			collections_path = collections_candidate
			break
		}
		parent := current_path.parent() or { break } // reached root or error
		if parent.path == current_path.path {
			break // reached root
		}
		current_path = parent
	}

	if collections_path != '' {
		// Create a doctree and scan the collections
		mut tree := doctree.new(name: site.name)!
		tree.scan(path: collections_path)!

		// Export to Redis and temporary location for doctreeclient access
		tree.export(
			destination:    '/tmp/doctree_export_${site.name}'
			reset:          true
			exclude_errors: false
		)!
	}

	// Generate the actual docs content from the processed site configuration
	docs_path := '${f.path_build.path}/docs'
	console.print_header(' generating docs from site pages to: ${docs_path}')

	generate_docs(
		path: docs_path
		site: updated_site
	)!
}
