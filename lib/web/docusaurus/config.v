module docusaurus

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
