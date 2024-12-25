module installer_client

import os
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.ui.console



pub struct GenModel {
pub mut:
	name                string
	classname           string
	default             bool = true // means user can just get the object and a default will be created
	title               string
	supported_platforms []string // only relevant for installers for now
	singleton           bool     // means there can only be one
	templates           bool     // means we will use templates in the installer, client doesn't do this'
	reset               bool     // regenerate all, dangerous !!!
	interactive         bool 	 //if we want to ask
	startupmanager      bool = true
	build               bool	
	hasconfig 				bool	
	cat Cat = .client
}


pub enum Cat {
	unknown
	client
	installer
}


pub fn gen_model_set(args GenerateArgs) ! {
	model := args.model
	heroscript_templ := $tmpl('templates/heroscript')

	//TODO: look in lib/code/generator/installer_client/templates/heroscript, don't use the if in template, use 2 templates, depending type use other template, and the args used should be set here in code 

	pathlib.template_write(heroscript_templ, '${args.path}/.heroscript', true)!
}


pub fn gen_model_get(path string, create: bool) !GenModel {
	console.print_debug('play installer code for path: ${path}')

	mut config_path := pathlib.get_file(path: '${path}/.heroscript', create: create)!

	mut plbook := playbook.new(text: config_path.read()! )!

	mut model := GenModel{}
	mut found := false

	mut install_actions := plbook.find(filter: 'hero_code.generate_installer')!
	if install_actions.len > 0 {
		for install_action in install_actions {
			if found {
				return error("cannot find more than one her_code.generate_installer ... in ${path}")
			}
			found = true
			mut p := install_action.params
			model = GenModel{
				name:                p.get_default('name','')!
				classname:           p.get_default('classname','')!
				title:               p.get_default('title', '')!
				default:             p.get_default_true('default')
				supported_platforms: p.get_list('supported_platforms')!
				singleton:           p.get_default_false('singleton')
				templates:           p.get_default_false('templates')
				startupmanager:      p.get_default_true('startupmanager')
				build:               p.get_default_false('build')
				hasconfig: 			 p.get_default_false('hasconfig')
				cat:                 .installer
			}
		}
	}

	mut client_actions := plbook.find(filter: 'hero_code.generate_client')!
	if client_actions.len > 0 {
		for client_action in client_actions {
			if found {
				return error("cannot find more than one her_code.generate_client ... in ${path}")
			}
			found = true			
			mut p := client_action.params
			model = GenModel{
				name:      p.get_default('name','')!
				classname: p.get_default('classname','')!
				title:     p.get_default('title', '')!
				default:   p.get_default_true('default')
				singleton: p.get_default_false('singleton')
				reset:     p.get_default_false('reset')
				hasconfig: p.get_default_false('hasconfig')
				cat:       .client
			}
		}
	}

	if model.cat == .unknown {
		if path.contains("clients") {
			model.cat = .client
		} else {
			model.cat = .installer
		}
	}

	if model.name == "" {
		model.name = os.base(path).to_lower()
	}

	return model
	// return GenModel{}
}
