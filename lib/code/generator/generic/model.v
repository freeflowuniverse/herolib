module generic

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
	cat Cat = .client
}


pub enum Cat {
	unknown
	installer
	client
}


pub fn gen_model_set(args GenModel) ! {
	heroscript_templ := $tmpl('templates/heroscript')
	pathlib.template_write(heroscript_templ, '${args.path}/templates/.heroscript', true)!
}


pub fn gen_model_get(path string) !GenModel {
	console.print_debug('play installer code for path: ${path}')

	mut config_path := pathlib.get_file(path: '${path}/.heroscript', create: false)!

	if !config_path.exists() {
		return error("can't find path with .heroscript in ${path}")
	}

	mut plbook := playbook.new(text: config_path.read()!)!

	mut install_actions := plbook.find(filter: 'hero_code.generate_installer')!
	if install_actions.len > 0 {
		for install_action in install_actions {
			mut p := install_action.params
			mut args := GenModel{
				name:                p.get('name')!
				classname:           p.get('classname')!
				title:               p.get_default('title', '')!
				default:             p.get_default_true('default')
				supported_platforms: p.get_list('supported_platforms')!
				singleton:           p.get_default_false('singleton')
				templates:           p.get_default_false('templates')
				reset:               p.get_default_false('reset')
				startupmanager:      p.get_default_true('startupmanager')
				hasconfig:           p.get_default_true('hasconfig')
				build:               p.get_default_false('build')
				cat:                 .installer
			}
			return args
		}
	}

	mut client_actions := plbook.find(filter: 'hero_code.generate_client')!
	if client_actions.len > 0 {
		for client_action in client_actions {
			mut p := client_action.params
			args := GenModel{
				name:      p.get('name')!
				classname: p.get('classname')!
				title:     p.get_default('title', '')!
				default:   p.get_default_true('default')
				singleton: p.get_default_false('singleton')
				reset:     p.get_default_false('reset')
				cat:       .client
			}
			return args
		}
	}
	return error("can't find hero_code.generate_client or hero_code.generate_installer in ${path}")
	// return GenModel{}
}
