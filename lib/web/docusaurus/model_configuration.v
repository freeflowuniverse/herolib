module docusaurus

import os
import json
import freeflowuniverse.herolib.core.pathlib

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

pub fn load_configuration(cfg_path string) !Configuration {
	mut main_json := pathlib.get_file(path: os.join_path(cfg_path, 'main.json'))!
	mut navbar_json := pathlib.get_file(path: os.join_path(cfg_path, 'navbar.json'))!
	mut footer_json := pathlib.get_file(path: os.join_path(cfg_path, 'footer.json'))!
    mut cfg := Configuration{
        main:   json.decode(Main, main_json.read()!)!,
        navbar: json.decode(Navbar, navbar_json.read()!)!,
        footer: json.decode(Footer, footer_json.read()!)!
    }
    return cfg
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