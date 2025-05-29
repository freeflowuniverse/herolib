module docusaurus

import os
import json
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.web.siteconfig // For siteconfig.SiteConfig and siteconfig.new
// import strings // No longer needed as we are not concatenating
// import freeflowuniverse.herolib.core.playbook // No longer directly needed here

pub struct Configuration {
	pub mut:
		main Main
		navbar Navbar
		footer Footer
	}

pub struct Main {
	pub mut:
		title        string
		tagline      string
		favicon      string
		url          string
		base_url     string @[json: 'baseUrl']
		url_home     string
		image        string
		metadata     Metadata
		build_dest   []string @[json: 'buildDest']
		build_dest_dev []string @[json: 'buildDestDev']
		copyright    string
		name         string
	}

pub struct Metadata {
	pub mut:
		description string
		image       string
		title       string
	}

pub struct Navbar {
	pub mut:
		title  string
		logo   Logo
		items  []NavbarItem
	}

pub struct Logo {
	pub mut:
		alt      string
		src      string
		src_dark string @[json: 'srcDark']
	}

pub struct NavbarItem {
	pub mut:
		label    string
		href     string
		position string
		to       string
	}

pub struct Footer {
	pub mut:
		style  string
		links  []FooterLink
	}

pub struct FooterLink {
	pub mut:
		title string
		items []FooterItem
	}

pub struct FooterItem {
	pub mut:
		label string
		href  string
		to    string
	}

// Private helper function for JSON loading logic
fn load_configuration_from_json(cfg_path string) !Configuration {
	mut main_json_path := os.join_path(cfg_path, 'main.json')
	mut navbar_json_path := os.join_path(cfg_path, 'navbar.json')
	mut footer_json_path := os.join_path(cfg_path, 'footer.json')

	if !os.exists(main_json_path) || !os.exists(navbar_json_path) || !os.exists(footer_json_path) {
		return error('Missing one or more required JSON configuration files (main.json, navbar.json, footer.json) in ${cfg_path} and no primary HeroScript file was successfully processed.')
	}

	mut main_json_content := pathlib.get_file(path: main_json_path)!
	mut navbar_json_content := pathlib.get_file(path: navbar_json_path)!
	mut footer_json_content := pathlib.get_file(path: footer_json_path)!
	
	main_data := json.decode(Main, main_json_content.read()!)!
	navbar_data := json.decode(Navbar, navbar_json_content.read()!)!
	footer_data := json.decode(Footer, footer_json_content.read()!)!

	mut cfg := Configuration{
		main: main_data,
		navbar: navbar_data,
		footer: footer_data,
	}
	return cfg
}

pub fn load_configuration(cfg_path string) !Configuration {
	primary_heroscript_filename := 'config.heroscript' // Define the primary HeroScript file to look for
	hero_script_main_file_path := os.join_path(cfg_path, primary_heroscript_filename)

	if os.exists(hero_script_main_file_path) {
		println('Found primary HeroScript file: ${hero_script_main_file_path}. Attempting to load configuration.')
		
		// Use siteconfig.new from factory.v. This function handles PlayBook creation, playing, and Redis interaction.
		site_cfg_ref := siteconfig.new(cfg_path) or {
			eprintln('Error loading configuration from HeroScript file ${hero_script_main_file_path}: ${err}. Falling back to JSON.')
			return load_configuration_from_json(cfg_path) // Fallback to JSON private helper
		}
		
		site_cfg_from_heroscript := *site_cfg_ref // Dereference to get the actual SiteConfig struct

		// Transform siteconfig.SiteConfig to docusaurus.Configuration
		mut nav_items := []NavbarItem{}
		for item in site_cfg_from_heroscript.menu.items {
			nav_items << NavbarItem{
				label: item.label,
				href: item.href,
				position: item.position,
				to: item.to,
			}
		}

		mut footer_links := []FooterLink{}
		for link in site_cfg_from_heroscript.footer.links {
			mut footer_items_mapped := []FooterItem{}
			for item in link.items {
				footer_items_mapped << FooterItem{
					label: item.label,
					href: item.href,
					to: item.to,
				}
			}
			footer_links << FooterLink{
				title: link.title,
				items: footer_items_mapped,
			}
		}

		cfg := Configuration{
			main: Main{
				title: site_cfg_from_heroscript.title,
				tagline: site_cfg_from_heroscript.tagline,
				favicon: site_cfg_from_heroscript.favicon,
				copyright: site_cfg_from_heroscript.copyright,
				name: site_cfg_from_heroscript.name,
				// url, base_url, url_home, image, metadata, build_dest etc. from site_cfg_from_heroscript.main if available
				// or leave to fix_configuration. siteconfig.SiteConfig doesn't have a direct 'Main' substruct.
				// These fields are top-level in siteconfig.SiteConfig.
			},
			navbar: Navbar{
				title: site_cfg_from_heroscript.menu.title,
				// logo: site_cfg_from_heroscript.menu.logo, // siteconfig.Menu doesn't have a direct logo struct like docusaurus.Logo
				items: nav_items,
			},
			footer: Footer{
				style: site_cfg_from_heroscript.footer.style,
				links: footer_links,
			},
		}
		return cfg
	} else {
		println('Primary HeroScript file (${primary_heroscript_filename}) not found in ${cfg_path}. Falling back to JSON configuration.')
		return load_configuration_from_json(cfg_path)
	}
}

pub fn fix_configuration(config Configuration) !Configuration {
	return Configuration {
		...config,
		main: Main {
			...config.main,
			title: if config.main.title == "" { "Docusaurus" } else { config.main.title },
			favicon: if config.main.favicon == "" { "img/favicon.ico" } else { config.main.favicon },
			url: if config.main.url == "" { "https://example.com" } else { config.main.url },
			base_url: if config.main.base_url == "" { "/" } else { config.main.base_url },
		}
	}
}