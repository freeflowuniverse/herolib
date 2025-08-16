module livekit

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook { PlayBook }
import freeflowuniverse.herolib.ui.console
import json

__global (
	livekit_global  map[string]&LivekitClient
	livekit_default string
)

/////////FACTORY

@[params]
pub struct ArgsGet {
pub mut:
	name   string = 'default'
	fromdb bool // will load from filesystem
	create bool // default will not create if not exist
}

pub fn new(args ArgsGet) !&LivekitClient {
	mut obj := LivekitClient{
		name: args.name
	}
	set(obj)!
	return &obj
}

pub fn get(args ArgsGet) !&LivekitClient {
	mut context := base.context()!
	livekit_default = args.name
	if args.fromdb || args.name !in livekit_global {
		mut r := context.redis()!
		if r.hexists('context:livekit', args.name)! {
			data := r.hget('context:livekit', args.name)!
			if data.len == 0 {
				return error('livekit with name: livekit does not exist, prob bug.')
			}
			mut obj := json.decode(LivekitClient, data)!
			set_in_mem(obj)!
		} else {
			if args.create {
				new(args)!
			} else {
				return error("LivekitClient with name 'livekit' does not exist")
			}
		}
		return get(name: args.name)! // no longer from db nor create
	}
	return livekit_global[args.name] or {
		return error('could not get config for livekit with name:livekit')
	}
}

// register the config for the future
pub fn set(o LivekitClient) ! {
	set_in_mem(o)!
	livekit_default = o.name
	mut context := base.context()!
	mut r := context.redis()!
	r.hset('context:livekit', o.name, json.encode(o))!
}

// does the config exists?
pub fn exists(args ArgsGet) !bool {
	mut context := base.context()!
	mut r := context.redis()!
	return r.hexists('context:livekit', args.name)!
}

pub fn delete(args ArgsGet) ! {
	mut context := base.context()!
	mut r := context.redis()!
	r.hdel('context:livekit', args.name)!
}

@[params]
pub struct ArgsList {
pub mut:
	fromdb bool // will load from filesystem
}

// if fromdb set: load from filesystem, and not from mem, will also reset what is in mem
pub fn list(args ArgsList) ![]&LivekitClient {
	mut res := []&LivekitClient{}
	mut context := base.context()!
	if args.fromdb {
		// reset what is in mem
		livekit_global = map[string]&LivekitClient{}
		livekit_default = ''
	}
	if args.fromdb {
		mut r := context.redis()!
		mut l := r.hkeys('context:livekit')!

		for name in l {
			res << get(name: name, fromdb: true)!
		}
		return res
	} else {
		// load from memory
		for _, client in livekit_global {
			res << client
		}
	}
	return res
}

// only sets in mem, does not set as config
fn set_in_mem(o LivekitClient) ! {
	mut o2 := obj_init(o)!
	livekit_global[o.name] = &o2
	livekit_default = o.name
}

// switch instance to be used for livekit
pub fn switch(name string) {
	livekit_default = name
}

pub fn play(mut plbook PlayBook) ! {
	mut install_actions := plbook.find(filter: 'livekit.configure')!
	if install_actions.len > 0 {
		for install_action in install_actions {
			heroscript := install_action.heroscript()
			mut obj2 := heroscript_loads(heroscript)!
			set(obj2)!
		}
	}
}
