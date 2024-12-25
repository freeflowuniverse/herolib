module generic

import freeflowuniverse.herolib.ui.console
import os

@[params]
pub struct GenerateArgs {
pub mut:
	reset               bool     // regenerate all, dangerous !!!
	interactive         bool 	 //if we want to ask
	path                string
	model 				GenModel
}


// will ask questions when not in force mode
// & generate the module
pub fn generate(args_ GenerateArgs) ! {
	mut args := args_

	if args.path == '' {
		args.path = os.getwd()
	}

	if args.model.name == '' {
		args.model.name = os.base(args.path)
	}

	console.print_header('Generate code for path: ${args.path} (reset:${args.reset}, interactive:${args.interactive})')
	console.print_debug(args)

	if args.interactive{
		ask(args)!
	}

	args.model = gen_model_get(args.path)!

	generate(args)!
}
