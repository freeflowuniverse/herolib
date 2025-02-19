module docusaurus

import freeflowuniverse.herolib.core.pathlib
import json
import os

// Footer config structures
pub struct FooterItem {
pub mut:
	label string
	to    string
	href  string
}

pub struct FooterLink {
pub mut:
	title string
	items []FooterItem
}

pub struct Footer {
pub mut:
	style string = 'dark'
	links []FooterLink
}

// Main config structure
pub struct MainMetadata {
pub mut:
	description string = 'Docusaurus'
	image       string = 'Docusaurus'
	title       string = 'Docusaurus'
}

pub struct Main {
pub mut:
	name           string
	title          string = 'Docusaurus'
	tagline        string
	favicon        string = 'img/favicon.png'
	url            string = 'http://localhost'
	url_home       string
	base_url       string = '/' @[json: 'baseUrl']
	image          string = 'img/tf_graph.png' @[required]
	metadata       MainMetadata
	build_dest     []string @[json: 'buildDest']
	build_dest_dev []string @[json: 'buildDestDev']
}

// Navbar config structures
pub struct NavbarItem {
pub mut:
	href     string
	label    string
	position string
}

pub struct Navbar {
pub mut:
	title string
	items []NavbarItem
}

// Combined config structure
pub struct Config {
pub mut:
	footer Footer
	main   Main
	navbar Navbar
}

// load_config loads all configuration from the specified directory
pub fn load_config(cfg_dir string) !Config {
	// Ensure the config directory exists
	if !os.exists(cfg_dir) {
		return error('Config directory ${cfg_dir} does not exist')
	}

	// Load and parse footer config
	footer_content := os.read_file(os.join_path(cfg_dir, 'footer.json'))!
	footer := json.decode(Footer, footer_content)!

	// Load and parse main config
	main_config_path := os.join_path(cfg_dir, 'main.json')
	main_content := os.read_file(main_config_path)!
	main := json.decode(Main, main_content) or {
		eprintln('${main_config_path} is not in the right format please fix.\nError: ${err}')
		println('

## EXAMPLE OF A GOOD ONE:

- note the list for buildDest and buildDestDev
- note its the full path where the html is pushed too

{
  "title": "ThreeFold Web4",
  "tagline": "ThreeFold Web4",
  "favicon": "img/favicon.png",
  "url": "https://docs.threefold.io",
  "url_home": "docs/introduction",
  "baseUrl": "/",
  "image": "img/tf_graph.png",
  "metadata": {
    "description": "ThreeFold is laying the foundation for a geo aware Web 4, the next generation of the Internet.",
    "image": "https://threefold.info/kristof/img/tf_graph.png",
    "title": "ThreeFold Docs"
  },
  "buildDest":["root@info.ourworld.tf:/root/hero/www/info/tfgrid4"],
  "buildDestDev":["root@info.ourworld.tf:/root/hero/www/infodev/tfgrid4"]
  
}
		')
		exit(99)
	}

	// Load and parse navbar config
	navbar_content := os.read_file(os.join_path(cfg_dir, 'navbar.json'))!
	navbar := json.decode(Navbar, navbar_content)!

	return Config{
		footer: footer
		main:   main
		navbar: navbar
	}
}

pub fn (c Config) write(path string) ! {
	mut footer_file := pathlib.get_file(path: '${path}/footer.json', create: true)!
	footer_file.write(json.encode(c.footer))!
	mut main_file := pathlib.get_file(path: '${path}/main.json', create: true)!
	main_file.write(json.encode(c.main))!
	mut navbar_file := pathlib.get_file(path: '${path}/navbar.json', create: true)!
	navbar_file.write(json.encode(c.navbar))!
}