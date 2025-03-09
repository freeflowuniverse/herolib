module docusaurus

import json
import os


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
		eprintln("${main_config_path} is not in the right format please fix.")
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
