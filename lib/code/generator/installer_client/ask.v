module installer_client

import freeflowuniverse.herolib.ui.console
import os
import freeflowuniverse.herolib.core.pathlib



// will ask questions & create the .heroscript
pub fn ask(path string) ! {
	mut myconsole := console.new()

    mut model:= gen_model_get(path, false)!

	console.clear()
	console.print_header('Configure generation of code for a module on path:')
	console.print_green('Path: ${path}')
	console.lf()

	model.classname = myconsole.ask_question(
		description: 'Class name of the ${model.cat}'
		question:    'What is the class name of the generator e.g. MyClass ?'
		warning:     'Please provide a valid class name for the generator'
		default:	 model.classname
		minlen:      4
	)!

	model.title = myconsole.ask_question(
		description: 'Title of the ${model.cat} (optional)'
		default:	 model.title
	)!

	model.hasconfig = !myconsole.ask_yesno(
		description: 'Is there a config (normally yes)?'
		default:	 model.hasconfig
	)!


	if model.hasconfig {
		model.singleton = !myconsole.ask_yesno(
			description: 'Can there be multiple instances (normally yes)?'
			default:	 !model.singleton
		)!
		if model.cat == .installer {
			model.templates = myconsole.ask_yesno(
				description: 'Will there be templates available for your installer?'
				default:	 model.templates
			)!
		}
	}else{
		model.singleton = true
	}

	if model.cat == .installer {

		model.startupmanager = myconsole.ask_yesno(
			description: 'Is this an installer which will be managed by a startup mananger?'
			default:	 model.startupmanager
		)!

		model.build = myconsole.ask_yesno(
			description: 'Are there builders for the installers (compilation)'
			default:	 model.build
		)!
	}

	// if true{
	// 	println(model)
	// 	panic("Sdsd")
	// }


	gen_model_set(GenerateArgs{model: model, path: path})!

}
