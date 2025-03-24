module docusaurus

import freeflowuniverse.herolib.core.playbook { PlayBook }

@[params]
pub struct PlayArgs {
pub mut:
	heroscript string // if filled in then playbook will be made out of it
	plbook     ?PlayBook
	reset      bool
}

// Process the heroscript and return a filled Config object
pub fn play(args_ PlayArgs) ! {
	mut plbook := playbook.new(text: args_.heroscript)!
	mut config := Config{}

	play_config(mut plbook, mut config)!
	play_config_meta(mut plbook, mut config)!
	play_ssh_connection(mut plbook, mut config)!
	play_import_source(mut plbook, mut config)!
	play_build_dest(mut plbook, mut config)!
	play_navbar(mut plbook, mut config)!
	play_footer(mut plbook, mut config)!
}

fn play_config(mut plbook PlayBook, mut config Config) ! {
	config_actions := plbook.find(filter: 'docusaurus.config')!
	for action in config_actions {
		mut p := action.params
		config.main = Main{
			title:    p.get_default('title', 'Internet Geek')!
			tagline:  p.get_default('tagline', 'Internet Geek')!
			favicon:  p.get_default('favicon', 'img/favicon.png')!
			url:      p.get_default('url', 'https://friends.threefold.info')!
			url_home: p.get_default('url_home', 'docs/')!
			base_url: p.get_default('base_url', '/testsite/')!
			image:    p.get_default('image', 'img/tf_graph.png')!
		}
	}
}

fn play_config_meta(mut plbook PlayBook, mut config Config) ! {
	meta_actions := plbook.find(filter: 'docusaurus.config_meta')!
	for action in meta_actions {
		mut p := action.params
		config.main.metadata = MainMetadata{
			description: p.get_default('description', 'ThreeFold is laying the foundation for a geo aware Web 4, the next generation of the Internet.')!
			image:       p.get_default('image', 'https://threefold.info/something/img/tf_graph.png')!
			title:       p.get_default('title', 'ThreeFold Technology Vision')!
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
		config.navbar.title = p.get_default('title', 'Chief Executive Geek')!
	}

	navbar_item_actions := plbook.find(filter: 'docusaurus.navbar_item')!
	for action in navbar_item_actions {
		mut p := action.params
		mut item := NavbarItem{
			label:    p.get_default('label', 'ThreeFold Technology')!
			href:     p.get_default('href', 'https://threefold.info/tech')!
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
