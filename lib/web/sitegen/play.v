module sitegen

import freeflowuniverse.herolib.core.playbook { PlayBook }
import freeflowuniverse.herolib.ui.console
import os



pub fn play(mut plbook PlayBook) ! {

	defaultdest = '${os.home_dir()}/hero/var/sitegen'

	//if only 1 doctree is specified, then we use that as the default doctree name
	mut doctreename := 'main'
	if plbook.exists(filter: 'site.doctree') {
		if plbook.exists_once(filter: 'site.doctree') {
			mut action := plbook.action_get(actor: 'site', name: 'doctree')!
			mut p := action.params
			doctreename = p.get('name') or { return error('need to specify name in site.doctree') }
		} else {
			return error("can't have more than one site.doctree")
		}
	}

	// !!site.page name:"atest" path:"crazy/sub" position:1
	// 	src:"marketplace_specs:tft_tfp_marketplace"
	// 	title:"Just a Page"
	// 	description:"A description not filled in"
	// 	draft:1 hide_title:1

	mut factory := new(path: defaultdest, flat: true)!

	// LETS FIRST DO THE CATEGORIES
	category_actions := plbook.find(filter: 'site.page_category')!
	mut section := Section{}
	for action in category_actions {
		// println(action)
		mut p := action.params
		sitename := p.get_default('sitename', args.sitename)!
		section.position = p.get_int_default('position', 20)!
		section.label = p.get('label') or {
			return error('need to specify label in site.page_category')
		}
		section.path = p.get('path') or {
			return error('need to specify path in site.page_category')
		}
		mut site := factory.site_get(sitename)!
		site.section_add(section)!
	}

	page_actions := plbook.find(filter: 'site.page')!
	mut mypage := Page{
		src:  ''
		path: ''
	}
	mut position_next := 1
	mut position := 0
	mut path := ''
	for action in page_actions {
		// println(action)
		mut p := action.params
		sitename := p.get_default('sitename', args.sitename)!
		pathnew := p.get_default('path', '')!
		if pathnew != '' {
			mypage.path = path
			if pathnew.ends_with('.md') {
				// means we fully specified the name
				mypage.path = pathnew
			} else {
				// only remember path if no .md file specified
				path = pathnew
				if !path.ends_with('/') {
					path += '/'
				}
				// println(' -- NEW PATH: ${path}')
				mypage.path = path
			}
		} else {
			mypage.path = path
		}
		position = p.get_int_default('position', 0)!
		if position == 0 {
			position = position_next
			position_next += 1
		} else {
			if position > position_next {
				position_next = position + 1
			}
		}
		mypage.position = position
		mypage.src = p.get('src') or { return error('need to specify src in site.page') }
		mypage.title = p.get_default('title', '')!
		mypage.description = p.get_default('description', '')!
		mypage.slug = p.get_default('slug', '')!
		mypage.draft = p.get_default_false('draft')
		mypage.hide_title = p.get_default_false('hide_title')
		mypage.title_nr = p.get_int_default('title_nr', 0)!
		mut site := factory.site_get(sitename)!
		site.page_add(mypage)!
	}
}
