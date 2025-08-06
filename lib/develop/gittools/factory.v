module gittools

import os
import json
import freeflowuniverse.herolib.core.pathlib

__global (
	gsinstances map[string]&GitStructure
)

@[params]
pub struct GetRepoArgs {
pub mut:
	path      string // if used will check if path exists if yes, just return
	git_url   string
	git_pull  bool
	git_reset bool
}

// get_repo_path implements the GitUrlResolver interface
pub fn get_repo_path(args GetRepoArgs) !string {
	if os.exists(args.path) {
		return args.path
	}
	mut gs := get()!
	mut repo := gs.get_repo(
		url:   args.git_url
		pull:  args.git_pull
		reset: args.git_reset
	)!
	return repo.path()
}

pub fn reset() {
	gsinstances = map[string]&GitStructure{} // they key is the redis_key (hash of coderoot)
}

@[params]
pub struct GitStructureArgsNew {
pub mut:
	coderoot     string
	light        bool = true // If true, clones only the last history for all branches (clone with only 1 level deep)
	log          bool = true // If true, logs git commands/statements
	debug        bool = true
	ssh_key_name string // name of ssh key to be used when loading the gitstructure
	ssh_key_path string
	reload       bool
	offline      bool = false
}

// Retrieve or create a new GitStructure instance with the given configuration.
pub fn new(args_ GitStructureArgsNew) !&GitStructure {
	mut args := args_
	if args.coderoot == '' {
		args.coderoot = '${os.home_dir()}/code'
	}
	mut cfg := GitStructureConfig{
		coderoot:     args.coderoot
		light:        args.light
		log:          args.log
		debug:        args.debug
		ssh_key_name: args.ssh_key_name
		ssh_key_path: args.ssh_key_path
		offline:      args.offline
	}

	return get(coderoot: args.coderoot, reload: args.reload, cfg: cfg)
}

@[params]
pub struct GitStructureArgGet {
pub mut:
	coderoot string
	reload   bool
	cfg      ?GitStructureConfig
}

// Retrieve a GitStructure instance based on the given arguments.
pub fn get(args_ GitStructureArgGet) !&GitStructure {
	mut args := args_
	if args.coderoot == '' {
		args.coderoot = '${os.home_dir()}/code'
	}

	// make sure coderoot exists
	if !os.exists(args.coderoot) {
		os.mkdir_all(args.coderoot)!
	}

	rediskey_ := cache_key(args.coderoot)

	// Return existing instance if already created.
	if rediskey_ in gsinstances {
		mut gs := gsinstances[rediskey_] or {
			panic('Unexpected error: key not found in gsinstances')
		}
		gs.load(args.reload)!
		return gs
	}

	// Create and load the GitStructure instance.
	mut gs := GitStructure{
		key:      rediskey_
		coderoot: pathlib.get_dir(path: args.coderoot, create: true)!
	}

	mut cfg := args.cfg or {
		mut cfg_ := GitStructureConfig{
			coderoot: 'SKIP'
		}
		cfg_
	}

	if cfg.coderoot != 'SKIP' {
		gs.config_ = cfg
		gs.config_save()!
		// println(gs.config()!)
	}

	gs.config()! // will load the config, don't remove

	gs.load(false)!

	if gs.repos.keys().len == 0 || args.reload {
		gs.load(true)!
	}

	gsinstances[rediskey_] = &gs

	return gsinstances[rediskey_] or { panic('bug') }
}

@[params]
pub struct GitPathGetArgs {
pub mut:
	path       string
	git_url    string
	git_reset  bool
	git_root   string
	git_pull   bool
	currentdir bool // can use currentdir
}

// return pathlib Path based on, will pull...
// params:
// 	path      string
// 	git_url   string
// 	git_reset bool
// 	git_root  string
// 	git_pull  bool
pub fn path(args_ GitPathGetArgs) !pathlib.Path {
	mut args := args_
	if args.path.trim_space() == '' && args.currentdir {
		args.path = os.getwd()
	}

	if args.git_url.len > 0 {
		mut gs := get(coderoot: args.git_root)!
		mut repo := gs.get_repo(
			url:   args.git_url
			pull:  args.git_pull
			reset: args.git_reset
		)!
		args.path = repo.get_path_of_url(args.git_url)!
	}
	if args.path.len == 0 {
		return error('Path needs to be provided.')
	}
	return pathlib.get(args.path)
}
