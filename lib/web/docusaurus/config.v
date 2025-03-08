module docusaurus

import freeflowuniverse.herolib.core.pathlib
import json
import os


//THE FOLLOWING STRUCTS CAN BE SERIALIZED IN 
// main.json
// Main
// {
//   "title": "Internet Geek",
//   "tagline": "Internet Geek",
//   "favicon": "img/favicon.png",
//   "url": "https://friends.threefold.info",
//   "url_home": "docs/",
//   "baseUrl": "/kristof/",
//   "image": "img/tf_graph.png",
//   "metadata": {
//     "description": "ThreeFold is laying the foundation for a geo aware Web 4, the next generation of the Internet.",
//     "image": "https://threefold.info/kristof/img/tf_graph.png",
//     "title": "ThreeFold Technology Vision"
//   },
//   "buildDest":"root@info.ourworld.tf:/root/hero/www/info",
//   "buildDestDev":"root@info.ourworld.tf:/root/hero/www/infodev"
// }
//
// navbar.json
// Navbar:
// {
//   "title": "Kristof = Chief Executive Geek",
//   "items": [
//     {
//       "href": "https://threefold.info/kristof/",
//       "label": "ThreeFold Technology",
//       "position": "right"
//     },
//     {
//       "href": "https://threefold.io",
//       "label": "ThreeFold.io",
//       "position": "right"
//     }
//   ]
// }
//
// footer.json
// Footer:
// {
//   "style": "dark",
//   "links": [
//     {
//       "title": "Docs",
//       "items": [
//         {
//           "label": "Introduction",
//           "to": "/docs"
//         },
//         {
//           "label": "TFGrid V4 Docs",
//           "href": "https://docs.threefold.io/"
//         }
//       ]
//     },
//     {
//       "title": "Community",
//       "items": [
//         {
//           "label": "Telegram",
//           "href": "https://t.me/threefold"
//         },
//         {
//           "label": "X",
//           "href": "https://x.com/threefold_io"
//         }
//       ]
//     },
//     {
//       "title": "Links",
//       "items": [
//         {
//           "label": "ThreeFold.io",
//           "href": "https://threefold.io"
//         }
//       ]
//     }
//   ]
// }

// Combined config structure
pub struct Config {
pub mut:
	footer Footer
	main   Main
	navbar Navbar
	build_destinations []BuildDest
	import_sources []ImportSource
	ssh_connections []SSHConnection

}

// THE SUBELEMENTS

pub struct Main {
pub mut:
	name           string
	title          string
	tagline        string
	favicon        string
	url            string
	url_home       string
	base_url       string @[json: 'baseUrl']
	image          string
	metadata       MainMetadata
	build_dest []string
	build_dest_dev []string	
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
	copyright string = "someone"
	to_import []MyImport  @[json: 'import']
}

pub struct MyImport {
pub mut:
	url  string
	dest string
	visible bool
	replace map[string]string
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


pub struct SSHConnection {
pub mut:
	name string = 'main'
	login string = 'root' //e.g. 'root'
	host string // e.g. info.ourworld.tf
	port int = 21 //default is std ssh port
	key string
	key_path string //location of the key (private ssh key to be able to connect over ssh)
}

pub struct BuildDest {
pub mut:
	ssh_name string = 'main'
	path string //can be on the ssh root or direct path e.g. /root/hero/www/info
// load_config loads all configuration from the specified directory
pub fn load_config(cfg_dir string) !Config {
	// Ensure the config directory exists
	if !os.exists(cfg_dir) {
		return error('Config directory ${cfg_dir} does not exist')
	}

	// Load and parse footer config
	footer_content := os.read_file(os.join_path(cfg_dir, 'footer.json'))!
	footer := json.decode(Footer, footer_content) or {
		eprintln('footer.json in ${cfg_dir} is not in the right format please fix.\nError: ${err}')
		exit(99)
	}

	// Load and parse main config
	main_config_path := os.join_path(cfg_dir, 'main.json')
	main_content := os.read_file(main_config_path)!
	main := json.decode(Main, main_content) or {
		eprintln('main.json in ${cfg_dir} is not in the right format please fix.\nError: ${err}')
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

	// Load and parse navbar config
	navbar_content := os.read_file(os.join_path(cfg_dir, 'navbar.json'))!
	navbar := json.decode(Navbar, navbar_content) or {
		eprintln('navbar.json in ${cfg_dir} is not in the right format please fix.\nError: ${err}')
		exit(99)
	}

pub struct ImportSource {
pub mut:
	url string //http git url can be to specific path
	path string
	dest string //location in the docs folder of the place where we will build docusaurus
	replace map[string]string  //will replace ${NAME} in the imported content
}


// Export config as JSON files (main.json, navbar.json, footer.json)
pub fn (config Config) export_json(path string) ! {
	// Ensure directory exists
	os.mkdir_all(path)!

	// Export main.json
	os.write_file("${path}/main.json", json.encode_pretty(config.main))!

	// Export navbar.json
	os.write_file("${path}/navbar.json", json.encode_pretty(config.navbar))!

	// Export footer.json
	os.write_file("${path}/footer.json", json.encode_pretty(config.footer))!
}

pub fn (c Config) write(path string) ! {
	mut footer_file := pathlib.get_file(path: '${path}/footer.json', create: true)!
	footer_file.write(json.encode(c.footer))!
	mut main_file := pathlib.get_file(path: '${path}/main.json', create: true)!
	main_file.write(json.encode(c.main))!
	mut navbar_file := pathlib.get_file(path: '${path}/navbar.json', create: true)!
	navbar_file.write(json.encode(c.navbar))!
}