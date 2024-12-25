module generic

import freeflowuniverse.herolib.ui.console
import os
import freeflowuniverse.herolib.core.pathlib



// will ask questions & create the .heroscript
pub fn ask(args_ GenerateArgs) ! {
	mut myconsole := console.new()
	mut args := args_

	if args.model.name == '' {
		args.model.name = os.base(args.path)
	}

	console.clear()
	console.print_header('Configure generation of code for a module on path:')
	console.print_green('Path: ${args.path}')
	console.lf()

	if args.path.contains("clients"){
		args.model.cat == .client
	}else{
		args.model.cat == .installer
	}

	args.model.classname = myconsole.ask_question(
		description: 'Class name of the ${args.model.cat}'
		question:    'What is the class name of the generator e.g. MyClass ?'
		warning:     'Please provide a valid class name for the generator'
		minlen:      4
	)!

	args.model.title = myconsole.ask_question(
		description: 'Title of the ${args.model.cat} (optional)'
	)!

	args.model.singleton = !myconsole.ask_yesno(
		description: 'Can there be multiple instances (normally yes)?'
	)!

	if args.model.cat == .installer {
		args.model.templates = myconsole.ask_yesno(
			description: 'Will there be templates available for your installer?'
		)!

		args.model.startupmanager = myconsole.ask_yesno(
			description: 'Is this an installer which will be managed by a startup mananger?'
		)!

		args.model.build = myconsole.ask_yesno(
			description: 'Are there builders for the installers (compilation)'
		)!
	}

	gen_model_set(args.model)!

}

