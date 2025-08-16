module jina

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook { PlayBook }
import freeflowuniverse.herolib.ui.console
import json

__global (
	jina_global  map[string]&Jina
	jina_default string
)

/////////FACTORY

@[params]
pub struct ArgsGet {
pub mut:
	name   string = 'default'
	fromdb bool // will load from filesystem
	create bool // default will not create if not exist
}

pub fn new(args ArgsGet) !&Jina {
	mut obj := Jina{
		name: args.name
	}
	set(obj)!
	return &obj
}

pub fn get(args ArgsGet) !&Jina {
	mut context := base.context()!
	jina_default = args.name
	if args.fromdb || args.name !in jina_global {
		mut r := context.redis()!
		if r.hexists('context:jina', args.name)! {
			data := r.hget('context:jina', args.name)!
			if data.len == 0 {
				return error('jina with name: jina does not exist, prob bug.')
			}
			mut obj := json.decode(Jina, data)!
			set_in_mem(obj)!
		} else {
			if args.create {
				new(args)!
			} else {
				return error("Jina with name 'jina' does not exist")
			}
		}
		return get(name: args.name)! // no longer from db nor create
	}
	return jina_global[args.name] or {
		return error('could not get config for jina with name:jina')
	}
}

// register the config for the future
pub fn set(o Jina) ! {
	set_in_mem(o)!
	jina_default = o.name
	mut context := base.context()!
	mut r := context.redis()!
	r.hset('context:jina', o.name, json.encode(o))!
}

// does the config exists?
pub fn exists(args ArgsGet) !bool {
	mut context := base.context()!
	mut r := context.redis()!
	return r.hexists('context:jina', args.name)!
}

pub fn delete(args ArgsGet) ! {
	mut context := base.context()!
	mut r := context.redis()!
	r.hdel('context:jina', args.name)!
}

@[params]
pub struct ArgsList {
pub mut:
	fromdb bool // will load from filesystem
}

// if fromdb set: load from filesystem, and not from mem, will also reset what is in mem
pub fn list(args ArgsList) ![]&Jina {
	mut res := []&Jina{}
	mut context := base.context()!
	if args.fromdb {
		// reset what is in mem
		jina_global = map[string]&Jina{}
		jina_default = ''
	}
	if args.fromdb {
		mut r := context.redis()!
		mut l := r.hkeys('context:jina')!

		for name in l {
			res << get(name: name, fromdb: true)!
		}
		return res
	} else {
		// load from memory
		for _, client in jina_global {
			res << client
		}
	}
	return res
}

// only sets in mem, does not set as config
fn set_in_mem(o Jina) ! {
	mut o2 := obj_init(o)!
	jina_global[o.name] = &o2
	jina_default = o.name
}

// switch instance to be used for jina
pub fn switch(name string) {
	jina_default = name
}

pub fn play(mut plbook PlayBook) ! {
	mut install_actions := plbook.find(filter: 'jina.configure')!
	if install_actions.len > 0 {
		for install_action in install_actions {
			heroscript := install_action.heroscript()
			mut obj2 := heroscript_loads(heroscript)!
			set(obj2)!
		}
	}
}
