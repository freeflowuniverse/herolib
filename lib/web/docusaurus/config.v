module docusaurus

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
	style string
	links []FooterLink
}

// Main config structure
pub struct MainMetadata {
pub mut:
	description string
	image       string
	title       string
}

pub struct Main {
pub mut:
	name		   string
	title          string
	tagline        string
	favicon        string
	url            string
	url_home       string
	base_url       string @[json: 'baseUrl']
	image          string
	metadata       MainMetadata
	build_dest     string @[json: 'buildDest']
	build_dest_dev string @[json: 'buildDestDev']
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
	main_content := os.read_file(os.join_path(cfg_dir, 'main.json'))!
	main := json.decode(Main, main_content)!

	// Load and parse navbar config
	navbar_content := os.read_file(os.join_path(cfg_dir, 'navbar.json'))!
	navbar := json.decode(Navbar, navbar_content)!

	return Config{
		footer: footer
		main: main
		navbar: navbar
	}
}
