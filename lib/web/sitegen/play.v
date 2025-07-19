module sitegen

import freeflowuniverse.herolib.core.playbook { PlayBook }
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.data.doctree


@[params]
pub struct PlayArgs {
pub mut:

	heroscript string
	heroscript_path string
	plbook     ?PlayBook
}


pub fn play(args_ PlayArgs) ! {

	mut args := args_
	mut plbook := args.plbook or { playbook.new(text: args.heroscript,path:args.heroscript_path)! }

	mut doctreename:="default"
	if plbook.exists(filter: 'site.doctree'){
		if plbook.exists_once(filter: 'site.doctree'){
			mut action:=plbook.action_get(actor:'site',name:'doctree')!
			mut p := action.params		
			doctreename = p.get('name') or {return error("need to specify name in site.doctree")}
		}else{
			return error("can't have more than one site.doctree")
		}
	}

	mut tree := doctree.new(name: doctreename) or {
		return error("can't find doctree with name ${doctreename}")
	}

	// !!site.page name:"atest" path:"crazy/sub" position:1
	// 	src:"marketplace_specs:tft_tfp_marketplace" 
	// 	title:"Just a Page"
	// 	description:"A description not filled in"
	// 	draft:1 hide_title:1 

	mut factory:=new(mut tree)!

	page_actions := plbook.find(filter: 'site.page')!
	mut mypage:=Page{src:"",path:""}
	for action in page_actions {
		mut p := action.params		
		sitename := p.get('sitename') or { return error("need to specify name in site.page") }
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
}