module siteconfig

import freeflowuniverse.herolib.core.playbook { PlayBook }
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.core.base
import time
import json

@[params]
pub struct PlayArgs {
pub mut:
	heroscript string // if filled in then plbook will be made out of it
	plbook     ?PlayBook
	reset      bool
}

fn play_build_dest(mut plbook PlayBook, mut config SiteConfig) ! {
	build_dest_actions := plbook.find(filter: 'site.build_dest')!
	for action in build_dest_actions {
		mut p := action.params
		mut dest := BuildDest{
			path:     p.get('path')!
			ssh_name: p.get_default('ssh_name', '')!
		}
		config.build_dest << dest
	}
}

fn play_build_dest_dev(mut plbook PlayBook, mut config SiteConfig) ! {
	build_dest_dev_actions := plbook.find(filter: 'site.build_dest_dev')!
	for action in build_dest_dev_actions {
		mut p := action.params
		mut dest_dev := BuildDest{
			path:     p.get('path')!
			ssh_name: p.get_default('ssh_name', '')!
		}
		config.build_dest_dev << dest_dev
	}
}

pub fn play(args_ PlayArgs) ! {
	mut context := base.context()!
	mut redis := context.redis()!

	mut args := args_
	mut plbook := args.plbook or { playbook.new(text: args.heroscript)! }

	mut config := SiteConfig{}

	play_config(mut plbook, mut config)!
	play_collections(mut plbook, mut config)!
	play_menu(mut plbook, mut config)!
	play_footer(mut plbook, mut config)!
	play_pages(mut plbook, mut config)!
	play_build_dest(mut plbook, mut config)!
	play_build_dest_dev(mut plbook, mut config)!

	json_config := json.encode(config)
	redis.hset('siteconfigs', config.name, json_config)!
	redis.set('siteconfigs:current', config.name)!
}

fn play_config(mut plbook PlayBook, mut config SiteConfig) ! {
	// Process !!site.config
	config_actions := plbook.find(filter: 'site.config')!
	if config_actions.len == 0 {
		return error('no site.config directive found')
	}
	if config_actions.len > 1 {
		return error('multiple site.config directives found, only one is allowed')
	}
	for action in config_actions { // Should be only one
		mut p := action.params
		config.name = p.get('name')!
		config.name = texttools.name_fix(config.name)
		config.title = p.get_default('title', 'Documentation Site')!
		config.description = p.get_default('description', 'Comprehensive documentation built with Docusaurus.')!
		config.tagline = p.get_default('tagline', 'Your awesome documentation')!
		config.favicon = p.get_default('favicon', 'img/favicon.png')!
		config.image = p.get_default('image', 'img/tf_graph.png')!
		config.copyright = p.get_default('copyright', '© ' + time.now().year.str() +
			' Example Organization')!
		config.url = p.get_default('url', '')!
		config.base_url = p.get_default('base_url', '/')!
		config.url_home = p.get_default('url_home', '')!
	}

	// Process !!site.config_meta for specific metadata overrides
	meta_actions := plbook.find(filter: 'site.config_meta')!
	for action in meta_actions { // Should ideally be one
		mut p_meta := action.params
		// If 'title' is present in site.config_meta, it overrides. Otherwise, meta_title remains empty or uses site.config.title logic in docusaurus model.
		config.meta_title = p_meta.get_default('title', config.title)!
		// If 'image' is present in site.config_meta, it overrides. Otherwise, meta_image remains empty or uses site.config.image logic.
		config.meta_image = p_meta.get_default('image', config.image)!
		// 'description' from site.config_meta can also be parsed here if a separate meta_description field is added to SiteConfig
		// For now, config.description (from site.config) is used as the primary source or fallback.
	}
}

// Remove the old play_config content as it's now part of the new one above
/*
	config_actions := plbook.find(filter: 'site.config')!
	if config_actions.len == 0 {
		return error('no config found')
	}
	if config_actions.len > 1 {
		return error('multiple config found, not ok')
	}
	for action in config_actions {
		mut p := action.params
		// Get optional name parameter or use base_url as fallback
		config.name = p.get('name')!
		config.name = texttools.name_fix(config.name)
		config.title = p.get_default('title', 'Documentation Site')!
		config.description = p.get_default('description', 'Comprehensive documentation built with Docusaurus.')!
		config.tagline = p.get_default('tagline', 'Your awesome documentation')!
		config.favicon = p.get_default('favicon', 'img/favicon.png')!
		config.image = p.get_default('image', 'img/tf_graph.png')!
*/

fn play_collections(mut plbook PlayBook, mut config SiteConfig) ! {
	import_actions := plbook.find(filter: 'site.collections')!
	// println('import_actions: ${import_actions}')
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

fn play_menu(mut plbook PlayBook, mut config SiteConfig) ! {
	navbar_actions := plbook.find(filter: 'site.navbar')!
	if navbar_actions.len > 0 {
		for action in navbar_actions { // Should ideally be one, but loop for safety
			mut p := action.params
			config.menu.title = p.get_default('title', config.title)! // Use existing config.title as ultimate fallback
			config.menu.logo_alt = p.get_default('logo_alt', '')!
			config.menu.logo_src = p.get_default('logo_src', '')!
			config.menu.logo_src_dark = p.get_default('logo_src_dark', '')!
		}
	} else {
		// Fallback to site.menu for title if site.navbar is not found
		menu_actions := plbook.find(filter: 'site.menu')!
		for action in menu_actions {
			mut p := action.params
			config.menu.title = p.get_default('title', config.title)!
		}
	}

	mut menu_item_actions := plbook.find(filter: 'site.navbar_item')!
	if menu_item_actions.len == 0 {
		// Fallback to site.menu_item if site.navbar_item is not found
		menu_item_actions = plbook.find(filter: 'site.menu_item')!
	}

	for action in menu_item_actions {
		mut p := action.params
		mut item := MenuItem{
			label:    p.get_default('label', 'Documentation')!
			href:     p.get_default('href', '')!
			to:       p.get_default('to', '')!
			position: p.get_default('position', 'right')!
		}
		config.menu.items << item
	}
}

fn play_footer(mut plbook PlayBook, mut config SiteConfig) ! {
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
			href:  p.get_default('href', '')!
			to:    p.get_default('to', '')!
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

fn play_pages(mut plbook PlayBook, mut config SiteConfig) ! {
	page_actions := plbook.find(filter: 'site.page')!
	// println('page_actions: ${page_actions}')
	for action in page_actions {
		mut p := action.params

		mut page := Page{
			name:        p.get('name')!
			title:       p.get_default('title', '')!
			description: p.get_default('description', '')!
			content:     p.get_default('content', '')!
			src:         p.get_default('src', '')!
			draft:       p.get_default_false('draft')
			folder:      p.get_default('folder', '')!
			prio:        p.get_int_default('prio', 0)!
		}

		config.pages << page
	}
}
