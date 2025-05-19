module docusaurus

import freeflowuniverse.herolib.core.pathlib
import json
import os

// Combined config structure
pub struct Config {
pub mut:
	name           string
	title          string = 'My Documentation Site'
	description	   string
	tagline        string
	favicon        string = 'img/favicon.png'
	image          string = 'img/tf_graph.png'
	copyright      string = 'someone'
	footer             Footer
	navbar             Navbar
	import_sources     []ImportSource
}


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

pub struct ImportSource {
pub mut:
	url     string // http git url can be to specific path
	path    string
	dest    string            // location in the docs folder of the place where we will build docusaurus
	replace map[string]string // will replace ${NAME} in the imported content
	visible bool
}
