module installer_client

import freeflowuniverse.herolib.ui.console
import os

@[params]
pub struct GenerateArgs {
pub mut:
	reset       bool // regenerate all, dangerous !!!
	interactive bool // if we want to ask
	path        string
	playonly bool
	model       ?GenModel
	cat         ?Cat
}

pub struct PlayArgs {
pub mut:
	name string
	modulepath        string
}


// the default to start with
//
// reset               bool     // regenerate all, dangerous !!!
// interactive         bool 	 //if we want to ask
// path                string
// model 				?GenModel
// cat 				?Cat
//
// will return the module path where we need to execute a play command as well as the name of 
pub fn do(args_ GenerateArgs) !  PlayArgs{
	mut args := args_

	console.print_header('Generate code for path: ${args.path} (reset:${args.reset}, interactive:${args.interactive})')

	mut create := true // to create .heroscript

	mut model := args.model or {
		create = false // we cannot create because model not given
		if args.path == '' {
			args.path = os.getwd()
		}
		mut m := gen_model_get(args.path, false)!
		m
	}

	if model.classname == '' {
		args.interactive = true
	}

	if create {
		if args.path == '' {
			return error('need to specify path fo ${args_} because we asked to create .heroscript ')
		}
		gen_model_set(args)! // persist it on disk
	} else {
		if args.path == '' {
			args.path = os.getwd()
		}
	}

	// if model.cat == .unknown {
	// 	model.cat = args.cat or { return error('cat needs to be specified for generator.') }
	// }

	if args.interactive {
		ask(args.path)!
		args.model = gen_model_get(args.path, false)!
	} else {
		args.model = model
	}

	console.print_debug(args)

	//only generate if playonly is false and there is a classname
	if !args.playonly && model.classname.len>0{
		generate(args)!
	}

	
	return PlayArgs{
		name: model.play_name
		modulepath: model.module_path		
	}

}
