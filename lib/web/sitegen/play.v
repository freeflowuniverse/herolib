module sitegen

import freeflowuniverse.herolib.core.playbook { PlayBook }
import freeflowuniverse.herolib.ui.console
import os

@[params]
pub struct PlayArgs {
pub mut:
	heroscript string
	heroscript_path string
	plbook     ?PlayBook
	dest 	 string
	flat bool //if flat then won't use sitenames as subdir's
}


pub fn play(args_ PlayArgs) ! {

	mut args := args_
	mut plbook := args.plbook or { playbook.new(text: args.heroscript,path:args.heroscript_path)! }

	if args.dest==""{
		args.dest = '${os.home_dir()}/hero/var/sitegen'
	}

	mut doctreename:="main"
	if plbook.exists(filter: 'site.doctree'){
		if plbook.exists_once(filter: 'site.doctree'){
			mut action:=plbook.action_get(actor:'site',name:'doctree')!
			mut p := action.params		
			doctreename = p.get('name') or {return error("need to specify name in site.doctree")}
		}else{
			return error("can't have more than one site.doctree")
		}
	}


	// !!site.page name:"atest" path:"crazy/sub" position:1
	// 	src:"marketplace_specs:tft_tfp_marketplace" 
	// 	title:"Just a Page"
	// 	description:"A description not filled in"
	// 	draft:1 hide_title:1 

	mut factory:=new(path:args.dest,flat:args.flat)!

	page_actions := plbook.find(filter: 'site.page')!
	mut mypage:=Page{src:"",path:""}
	for action in page_actions {
		// println(action)
		mut p := action.params		
		sitename := p.get('sitename') or { return error("need to specify sitename in site.page") }
		mypage.path = p.get_default('path', "")!
		pagename := mypage.path.split('/').last()
		mypage.position = p.get_int_default('position', 0)!
		mypage.src = p.get('src') or { return error("need to specify src in site.page") }
		mypage.title = p.get_default('title', pagename)!
		mypage.description = p.get_default('description', '')!
		mypage.draft = p.get_default_false('draft')
		mypage.hide_title = p.get_default_false('hide_title')
		mut site := factory.site_get(sitename)!
		site.page_add(mypage)!
	}	

	category_actions := plbook.find(filter: 'site.page_category')!
	mut section := Section{}
	for action in category_actions {
		println(action)
		mut p := action.params		
		sitename := p.get('sitename') or { return error("need to specify sitename in site.page") }
		section.position = p.get_int_default('position', 20)!
		section.label = p.get('label' ) or { return error("need to specify label in site.page_category") }
		section.path = p.get('path') or { return error("need to specify path in site.page_category") }
		mut site := factory.site_get(sitename)!
		site.section_add(section)!
	}	



}