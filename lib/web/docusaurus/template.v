module docusaurus

import freeflowuniverse.herolib.develop.gittools
import freeflowuniverse.herolib.osal
import freeflowuniverse.herolib.installers.web.bun
import freeflowuniverse.herolib.core.pathlib
import json
import os
import time

@[params]
struct TemplateInstallArgs {
	template_update bool = true
	install         bool = true
	delete          bool = true
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
	self.generate_docusaurus_config_ts()!
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

	// Only try to delete docs if it exists in the template
	if os.exists(os.join_path(template_path.path, 'docs')) {
		mut aa := template_path.dir_get('docs')!
		aa.delete()!
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

// Generate docusaurus.config.ts based on the configuration
fn (mut self DocusaurusFactory) generate_docusaurus_config_ts() ! {
	// Use config values with fallbacks
	title := if self.config.main.title != '' { self.config.main.title } else { 'Docusaurus Site' }
	tagline := if self.config.main.tagline != '' {
		self.config.main.tagline
	} else {
		'Documentation Site'
	}
	url := if self.config.main.url != '' { self.config.main.url } else { 'https://example.com' }
	base_url := if self.config.main.base_url != '' { self.config.main.base_url } else { '/' }
	favicon := if self.config.main.favicon != '' {
		self.config.main.favicon
	} else {
		'img/favicon.png'
	}

	// Define additional variables for the template
	// Variables `title`, `tagline`, `favicon`, `url`, `base_url` are already defined above (lines 181-193)
	projectName := self.config.main.name
	navbarTitle := self.config.navbar.title

	// Format navbar items from config
	mut navbar_items_list_temp := []string{}
	for item in self.config.navbar.items {
		navbar_items_list_temp << "{
			label: '${item.label}',
			href: '${item.href}',
			position: '${item.position}'
		}"
	}
	navbarItems := navbar_items_list_temp.join(',\n      ') // Matches ${navbarItems} in template

	// Generate footer links if available
	mut footer_links_list_temp := []string{}
	for link in self.config.footer.links {
		mut items_temp := []string{}
		for item in link.items {
			mut item_str := '{'
			if item.label != '' {
				item_str += "label: '${item.label}', "
			}
			if item.href != '' {
				item_str += "href: '${item.href}'"
			} else if item.to != '' {
				item_str += "to: '${item.to}'"
			} else {
				item_str += "to: '/docs'" // Default link
			}
			item_str += '}'
			items_temp << item_str
		}
		footer_links_list_temp << "{
			title: '${link.title}',
			items: [
				${items_temp.join(',\n          ')}
			]
		}"
	}
	footerLinks := footer_links_list_temp.join(',\n      ') // Matches ${footerLinks} in template

	// Year for copyright
	year := time.now().year.str()

	// Copyright string (variable `copyright` must be in scope for the template)
	// `title` is defined at line 181, `year` is defined above.
	copyright := if self.config.main.copyright != '' {
		self.config.main.copyright
	} else {
		'Copyright © ${year} ${title}'
	}

	// Load docusaurus.config.ts from template
	// All required variables (title, tagline, favicon, url, base_url,
	// projectName, navbarTitle, navbarItems, footerLinks, copyright)
	// are in scope for $tmpl.
	content := $tmpl('templates/docusaurus.config.ts')

	mut config_file := pathlib.get_file(
		path:   os.join_path(self.path_build.path, 'docusaurus.config.ts')
		create: true
	)!
	config_file.write(content)!
}
