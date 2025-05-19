module site

import freeflowuniverse.herolib.core.playbook { PlayBook }
import time
import os


@[params]
pub struct PlayArgs {
pub mut:
	heroscript string // if filled in then plbook will be made out of it
	plbook     ?playbook.PlayBook
	reset      bool
}

pub fn play(args_ PlayArgs) ! {

	mut args := args_
	mut plbook := args.plbook or { playbook.new(text: args.heroscript)! }

	mut config := Config{}

	play_config(mut plbook, mut config)!
	play_collections(mut plbook, mut config)!
	play_menu(mut plbook, mut config)!
	play_footer(mut plbook, mut config)!

}

fn play_config(mut plbook PlayBook, mut config Config) ! {
	config_actions := plbook.find(filter: 'site.config')!
	for action in config_actions {
		mut p := action.params
		// Get optional name parameter or use base_url as fallback
		config.name = p.get_default('name', 'site')!
		config.title = p.get_default('title', 'Documentation Site')!
		config.description = p.get_default('description', 'Comprehensive documentation built with Docusaurus.')!
		config.tagline = p.get_default('tagline', 'Your awesome documentation')!
		config.favicon = p.get_default('favicon', 'img/favicon.png')!
		config.image = p.get_default('image', 'img/tf_graph.png')!
		config.copyright = p.get_default('copyright', '© ' + time.now().year.str() + ' Example Organization')!
	}
}

fn play_collections(mut plbook PlayBook, mut config Config) ! {
	import_actions := plbook.find(filter: 'site.collections')!
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
		mut import_ := CollectionsImport{
			url:     p.get('url')!
			path:    p.get_default('path', '')!
			dest:    p.get_default('dest', '')!
			replace: replace_map
			visible: p.get_default_false('visible')
		}
		config.import_collections << import_
	}
}

fn play_menu(mut plbook PlayBook, mut config Config) ! {
	menu_actions := plbook.find(filter: 'site.menu')!
	for action in menu_actions {
		mut p := action.params
		config.menu.title = p.get_default('title', config.title)!
	}

	menu_item_actions := plbook.find(filter: 'site.menu_item')!
	for action in menu_item_actions {
		mut p := action.params
		mut item := MenuItem{
			label:    p.get_default('label', 'Documentation')!
			href:     p.get_default('href', '/docs')!
			position: p.get_default('position', 'right')!
		}
		config.menu.items << item
	}
}

fn play_footer(mut plbook PlayBook, mut config Config) ! {
	footer_actions := plbook.find(filter: 'site.footer')!
	for action in footer_actions {
		mut p := action.params
		config.footer.style = p.get_default('style', 'dark')!
	}

	footer_item_actions := plbook.find(filter: 'site.footer_item')!
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
