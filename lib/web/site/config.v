module site

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
	footer         Footer
	menu           Menu
	import_collections     []CollectionsImport
	pages		 []Page
}

pub struct Page {
pub mut:
	name       string
	content    string
	title      string
	description string
	draft	   bool
	folder 	  string
	prio	   int
	src   string
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


// menu config structures
pub struct MenuItem {
pub mut:
	href     string
	label    string
	position string
}

pub struct Menu {
pub mut:
	title string
	items []MenuItem
}

pub struct CollectionsImport {
pub mut:
	url     string // http git url can be to specific path
	path    string
	dest    string            // location in the docs folder of the place where we will build docusaurus
	replace map[string]string // will replace ${NAME} in the imported content
	visible bool
}
