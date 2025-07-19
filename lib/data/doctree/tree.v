module doctree

import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.data.doctree.collection
import freeflowuniverse.herolib.data.doctree.collection.data
import freeflowuniverse.herolib.core.texttools.regext

__global (
	doctrees shared map[string]&Tree
)

pub enum TreeState {
	init
	ok
	error
}

@[heap]
pub struct Tree {
pub:
	name          string
	fail_on_error bool
pub mut:
	collections map[string]&collection.Collection
	defs        map[string]&data.Page
	state       TreeState
	// context context.Context
	cid      string = '000'
	replacer ?regext.ReplaceInstructions
}

// the unique key to remember a tree .
// is unique per circle (based on cid)
pub fn (tree Tree) key() string {
	return '${tree.cid}__${tree.name}'
}

@[params]
pub struct TreeArgsGet {
pub mut:
	name          string = 'default'
	fail_on_error bool
}

// new creates a new tree and stores it in global map
pub fn new(args_ TreeArgsGet) !&Tree {
	mut args := args_
	args.name = texttools.name_fix(args.name)
	mut t := Tree{
		name:          args.name
		fail_on_error: args.fail_on_error
	}
	tree_set(t)
	return &t
}

// tree_get gets tree from global map
pub fn tree_get(name string) !&Tree {
	rlock doctrees {
		if name in doctrees {
			return doctrees[name] or { return error('Doctree ${name} not found') }
		}
	}
	return error("can't get doctree:'${name}'")
}

pub fn tree_exist(name string) bool {
	rlock doctrees {
		if name in doctrees {
			return true
		}
	}
	return false
}

pub fn tree_list() []string {
	rlock doctrees {
		return doctrees.keys()
	}
}


// tree_set stores tree in global map
pub fn tree_set(tree Tree) {
	lock doctrees {
		doctrees[tree.name] = &tree
	}
}
