module docusaurus

import freeflowuniverse.herolib.core.playbook { PlayBook }
import time
import os

@[params]
pub struct PlayArgs {
pub mut:
	heroscript     string // if filled in then playbook will be made out of it
	heroscript_path string // path to a file containing heroscript
	plbook         ?PlayBook
	reset          bool
}

// Process the heroscript and return a filled Config object
pub fn play(args_ PlayArgs) !Config {
	mut heroscript_text := args_.heroscript
	
	// If heroscript_path is provided, read the script from the file
	if args_.heroscript_path != '' && heroscript_text == '' {
		heroscript_text = os.read_file(args_.heroscript_path) or {
			return error('Failed to read heroscript from ${args_.heroscript_path}: ${err}')
		}
	}
	
	// If no heroscript is provided, return an empty config
	if heroscript_text == '' && args_.plbook == none {
	    return Config{}
	}
	
	// Create playbook from the heroscript text
	mut plbook := if pb := args_.plbook {
		pb
	} else {
		playbook.new(text: heroscript_text)!
	}
	
	mut config := Config{}

	play_config(mut plbook, mut config)!
	play_config_meta(mut plbook, mut config)!
	play_ssh_connection(mut plbook, mut config)!
	play_import_source(mut plbook, mut config)!
	play_build_dest(mut plbook, mut config)!
	play_navbar(mut plbook, mut config)!
	play_footer(mut plbook, mut config)!
	
	return config
}

fn play_config(mut plbook PlayBook, mut config Config) ! {
	config_actions := plbook.find(filter: 'docusaurus.config')!
	for action in config_actions {
		mut p := action.params
		// Get optional name parameter or use base_url as fallback
		name := p.get_default('name', 'docusaurus-site')!
		
		config.main = Main{
			name:      name
			title:     p.get_default('title', 'Documentation Site')!
			tagline:   p.get_default('tagline', 'Your awesome documentation')!
			favicon:   p.get_default('favicon', 'img/favicon.png')!
			url:       p.get_default('url', 'https://docs.example.com')!
			url_home:  p.get_default('url_home', 'docs/')!
			base_url:  p.get_default('base_url', '/')!
			image:     p.get_default('image', 'img/hero.png')!
			copyright: p.get_default('copyright', '© ' + time.now().year.str() + ' Example Organization')!
		}
	}
}

fn play_config_meta(mut plbook PlayBook, mut config Config) ! {
	meta_actions := plbook.find(filter: 'docusaurus.config_meta')!
	for action in meta_actions {
		mut p := action.params
		config.main.metadata = MainMetadata{
			description: p.get_default('description', 'Comprehensive documentation built with Docusaurus.')!
			image:       p.get_default('image', 'https://docs.example.com/img/social-card.png')!
			title:       p.get_default('title', 'Documentation | ' + config.main.title)!
		}
	}
}

fn play_ssh_connection(mut plbook PlayBook, mut config Config) ! {
	ssh_actions := plbook.find(filter: 'docusaurus.ssh_connection')!
	for action in ssh_actions {
		mut p := action.params
		mut ssh := SSHConnection{
			name:     p.get_default('name', 'main')!
			host:     p.get_default('host', 'info.ourworld.tf')!
			port:     p.get_int_default('port', 21)!
			login:    p.get_default('login', 'root')!
			key_path: p.get_default('key_path', '')!
			key:      p.get_default('key', '')!
		}
		config.ssh_connections << ssh
	}
}

fn play_import_source(mut plbook PlayBook, mut config Config) ! {
	import_actions := plbook.find(filter: 'docusaurus.import_source')!
	for action in import_actions {
		mut p := action.params
		mut replace_map := map[string]string{}
		if replace_str := p.get_default('replace', '') {
			parts := replace_str.split(',')
			for part in parts {
				kv := part.split(':')
				if kv.len == 2 {
					replace_map[kv[0].trim_space()] = kv[1].trim_space()
				}
			}
		}
		mut import_ := ImportSource{
			url:     p.get('url')!
			path:    p.get_default('path', '')!
			dest:    p.get_default('dest', '')!
			replace: replace_map
		}
		config.import_sources << import_
	}
}

fn play_build_dest(mut plbook PlayBook, mut config Config) ! {
	build_actions := plbook.find(filter: 'docusaurus.build_dest')!
	for action in build_actions {
		mut p := action.params
		mut build := BuildDest{
			ssh_name: p.get_default('ssh_name', 'main')!
			path:     p.get_default('path', '')!
		}
		config.build_destinations << build
	}
}

fn play_navbar(mut plbook PlayBook, mut config Config) ! {
	navbar_actions := plbook.find(filter: 'docusaurus.navbar')!
	for action in navbar_actions {
		mut p := action.params
		config.navbar.title = p.get_default('title', config.main.title)!
	}

	navbar_item_actions := plbook.find(filter: 'docusaurus.navbar_item')!
	for action in navbar_item_actions {
		mut p := action.params
		mut item := NavbarItem{
			label:    p.get_default('label', 'Documentation')!
			href:     p.get_default('href', '/docs')!
			position: p.get_default('position', 'right')!
		}
		config.navbar.items << item
	}
}

fn play_footer(mut plbook PlayBook, mut config Config) ! {
	footer_actions := plbook.find(filter: 'docusaurus.footer')!
	for action in footer_actions {
		mut p := action.params
		config.footer.style = p.get_default('style', 'dark')!
	}

	footer_item_actions := plbook.find(filter: 'docusaurus.footer_item')!
	mut links_map := map[string][]FooterItem{}

	for action in footer_item_actions {
		mut p := action.params
		title := p.get_default('title', 'Docs')!
		mut item := FooterItem{
			label: p.get_default('label', 'Introduction')!
			to:    p.get_default('to', '/docs')!
			href:  p.get_default('href', '')!
		}

		if title !in links_map {
			links_map[title] = []FooterItem{}
		}
		links_map[title] << item
	}

	// Convert map to footer links array
	for title, items in links_map {
		config.footer.links << FooterLink{
			title: title
			items: items
		}
	}
}
