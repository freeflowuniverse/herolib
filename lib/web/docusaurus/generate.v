module docusaurus

import freeflowuniverse.herolib.develop.gittools
import freeflowuniverse.herolib.osal
import freeflowuniverse.herolib.installers.web.bun
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
	generate_configuration(site.path_build.path, site.config)!
	generate_docusaurus_config_ts(site.path_build.path, site.config)!

	// Now copy all directories that exist in src to build
	for item in ['src', 'static', 'cfg'] {
		if os.exists('${site.path_src.path}/${item}') {
			mut aa := site.path_src.dir_get(item)!
			aa.copy(dest: '${site.path_build.path}/${item}')!
		}
	}
	for item in ['docs'] {
		if os.exists('${site.path_src.path}/${item}') {
			mut aa := site.path_src.dir_get(item)!
			aa.copy(dest: '${site.path_build.path}/${item}', delete: true)!
		}
	}

	mut gs := gittools.new()!

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

fn generate_configuration(path string, config Configuration) ! {
	cfg_path := os.join_path(path, 'cfg')

	mut main_file := pathlib.get_file(path: '${cfg_path}/main.json', create: true)!
	main_file.write(json.encode(config.main))!

	mut navbar_file := pathlib.get_file(path: '${cfg_path}/navbar.json', create: true)!
	navbar_file.write(json.encode(config.navbar))!

	mut footer_file := pathlib.get_file(path: '${cfg_path}/footer.json', create: true)!
	footer_file.write(json.encode(config.footer))!
}

fn generate_docusaurus_config_ts(path string, config Configuration) ! {
	mut config_file := pathlib.get_file(
		path:   os.join_path(path, 'docusaurus.config.ts')
		create: true
	)!
	content := $tmpl('templates/docusaurus.config.ts')
	config_file.write(content)!
}

fn (mut self DocusaurusFactory) template_install(args TemplateInstallArgs) ! {
	mut gs := gittools.new()!

	mut r := gs.get_repo(
		url:  'https://github.com/freeflowuniverse/docusaurus_template.git'
		pull: args.template_update
	)!
	mut template_path := r.patho()!

	// always start from template first for static assets and source files
	for item in ['src', 'static'] {
		mut aa := template_path.dir_get(item)!
		aa.copy(dest: '${self.path_build.path}/${item}', delete: args.delete)!
	}

	// Generate config files dynamically from config
	self.generate_package_json()!
	self.generate_tsconfig_json()!
	self.generate_sidebars_ts()!
	self.generate_gitignore()!

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
}

fn (mut self DocusaurusFactory) generate_gitignore() ! {
	mut gitignore := pathlib.get_file(
		path:   os.join_path(self.path_build.path, '.gitignore')
		create: true
	)!
	content := $tmpl('templates/.gitignore')
	gitignore.write(content)!
}

// Generate package.json based on the configuration
fn (mut self DocusaurusFactory) generate_package_json() ! {
	// Build package.json content as a structured JSON string
	mut name := 'docusaurus-site'
	if self.config.main.name != '' {
		name = self.config.main.name
	} else if self.config.navbar.title != '' {
		name = self.config.navbar.title.to_lower().replace(' ', '-')
	}

	// Load package.json from template
	// The 'name' variable is defined in this function's scope and will be used by $tmpl.
	content := $tmpl('templates/package.json')
	mut package_file := pathlib.get_file(
		path:   os.join_path(self.path_build.path, 'package.json')
		create: true
	)!
	package_file.write(content)!
}

// Generate tsconfig.json based on the configuration
fn (mut self DocusaurusFactory) generate_tsconfig_json() ! {
	// Load tsconfig.json from template
	content := $tmpl('templates/tsconfig.json')
	mut tsconfig_file := pathlib.get_file(
		path:   os.join_path(self.path_build.path, 'tsconfig.json')
		create: true
	)!
	tsconfig_file.write(content)!
}

// Generate sidebars.ts based on the configuration
fn (mut self DocusaurusFactory) generate_sidebars_ts() ! {
	// Load sidebars.ts from template
	content := $tmpl('templates/sidebars.ts')
	mut sidebars_file := pathlib.get_file(
		path:   os.join_path(self.path_build.path, 'sidebars.ts')
		create: true
	)!
	sidebars_file.write(content)!
}

// // Generate docusaurus.config.ts based on the configuration
// fn (mut self DocusaurusFactory) generate_docusaurus_config_ts() ! {
// 	// Use config values with fallbacks
// 	title := if self.config.main.title != '' { self.config.main.title } else { 'Docusaurus Site' }

// 	// Format navbar items from config
// 	mut navbar_items_list_temp := []string{}
// 	for item in self.config.navbar.items {
// 		navbar_items_list_temp << "{
// 			label: '${item.label}',
// 			href: '${item.href}',
// 			position: '${item.position}'
// 		}"
// 	}

// 	// Generate footer links if available
// 	mut footer_links_list_temp := []string{}
// 	for link in self.config.footer.links {
// 		mut items_temp := []string{}
// 		for item in link.items {
// 			mut item_str := '{'
// 			if item.label != '' {
// 				item_str += "label: '${item.label}', "
// 			}
// 			if item.href != '' {
// 				item_str += "href: '${item.href}'"
// 			} else if item.to != '' {
// 				item_str += "to: '${item.to}'"
// 			} else {
// 				item_str += "to: '/docs'" // Default link
// 			}
// 			item_str += '}'
// 			items_temp << item_str
// 		}
// 		footer_links_list_temp << "{
// 			title: '${link.title}',
// 			items: [
// 				${items_temp.join(',\n          ')}
// 			]
// 		}"
// 	}

// 	// Year for copyright
// 	year := time.now().year.str()

// 	// Copyright string (variable `copyright` must be in scope for the template)
// 	// `title` is defined at line 181, `year` is defined above.
// 	copyright := if self.config.main.copyright != '' {
// 		self.config.main.copyright
// 	} else {
// 		'Copyright © ${year} ${title}'
// 	}

// 	// Load docusaurus.config.ts from template
// 	// All required variables (title, tagline, favicon, url, base_url,
// 	// projectName, navbarTitle, navbarItems, footerLinks, copyright)
// 	// are in scope for $tmpl.
// 	content := $tmpl('templates/docusaurus.config.ts')

// 	mut config_file := pathlib.get_file(
// 		path:   os.join_path(self.path_build.path, 'docusaurus.config.ts')
// 		create: true
// 	)!
// 	config_file.write(content)!
// }
