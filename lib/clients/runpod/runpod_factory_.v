module runpod

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook

__global (
	runpod_global  map[string]&RunPod
	runpod_default string
)

/////////FACTORY

// ArgsGet represents the arguments for getting a RunPod instance
@[params]
pub struct ArgsGet {
pub mut:
	name    string = 'default' // Name of the RunPod configuration
	api_key string // RunPod API key
}

// get_or_create gets an existing RunPod instance or creates a new one
pub fn get_or_create(args_ ArgsGet) !&RunPod {
	mut args := args_

	if args.name == '' {
		if runpod_default != '' {
			args.name = runpod_default
		} else {
			args.name = 'default'
		}
	}

	// Return existing instance if available
	if args.name in runpod_global {
		return runpod_global[args.name]
	}

	// Load from config if exists
	mut context := base.context()!
	if context.hero_config_exists('runpod', args.name) {
		mut heroscript := context.hero_config_get('runpod', args.name)!
		play(heroscript: heroscript)!
		return runpod_global[args.name] or { return error('Failed to load RunPod config') }
	}

	// Create new instance if API key provided
	if args.api_key != '' {
		mut rp := new(args.api_key)!
		rp.name = args.name
		runpod_global[args.name] = rp
		return rp
	}

	return error('RunPod API key is required for new instances')
}

// save_config saves the RunPod configuration
fn save_config(name string, api_key string) ! {
	mut context := base.context()!
	heroscript := "
	!!runpod.configure
	    name:'${name}'
	    api_key:'${api_key}'
	"
	context.hero_config_set('runpod', name, heroscript)!
}

// set stores a RunPod instance in the global map
fn set(rp &RunPod) ! {
	if rp.api_key == '' {
		return error('RunPod API key is required')
	}
	runpod_global[rp.name] = rp
	save_config(rp.name, rp.api_key)!
}

// PlayArgs represents arguments for playing a RunPod configuration
@[params]
pub struct PlayArgs {
pub mut:
	name       string = 'default'
	heroscript string // Heroscript configuration
	plbook     ?playbook.PlayBook
	api_key    string // RunPod API key
}

// play processes a RunPod configuration
pub fn play(args_ PlayArgs) ! {
	mut args := args_

	if args.heroscript == '' && args.api_key == '' {
		return error('Either heroscript or API key is required')
	}

	// If API key provided directly, create configuration
	if args.api_key != '' {
		save_config(args.name, args.api_key)!
		mut rp := new(args.api_key)!
		rp.name = args.name
		set(rp)!
		return
	}

	// Process heroscript configuration
	mut plbook := args.plbook or { playbook.new(text: args.heroscript)! }
	mut actions := plbook.find(filter: 'runpod.configure')!

	if actions.len == 0 {
		return error('No RunPod configuration found in heroscript')
	}

	for action in actions {
		mut params := action.params
		mut name := params.get_default('name', 'default')!
		mut api_key := params.get('api_key')!

		mut rp := new(api_key)!
		rp.name = name
		set(rp)!
	}
}

// switch instance to be used for runpod
pub fn switch(name string) {
	runpod_default = name
}
