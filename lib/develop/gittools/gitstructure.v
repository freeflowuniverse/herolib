module gittools

import crypto.md5
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.core.redisclient
import os
import freeflowuniverse.herolib.ui.console
import json

pub struct GitStructureConfig {
pub mut:
	coderoot     string // just to be informative, its not used
	light        bool = true // If true, clones only the last history for all branches (clone with only 1 level deep)
	log          bool = true // If true, logs git commands/statements
	debug        bool = true
	ssh_key_name string
	ssh_key_path string
	offline      bool = false
}

// GitStructure holds information about repositories within a specific code root.
// This structure keeps track of loaded repositories, their configurations, and their status.
@[heap]
pub struct GitStructure {
mut:
	config_ ?GitStructureConfig // Configuration settings for the git structure.
pub mut:
	key      string              // Unique key representing the git structure (default is hash of $home/code).	
	repos    map[string]&GitRepo // Map of repositories
	coderoot pathlib.Path
}

//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////

// Loads all repository information from the filesystem and updates from remote if necessary.
// Use the reset argument to force reloading from the disk.
pub fn (mut gitstructure GitStructure) load(reset bool) ! {
	mut processed_paths := []string{} // Re-added initialization

	if reset {
		gitstructure.repos = map[string]&GitRepo{}
	}

	gitstructure.load_recursive(gitstructure.coderoot.path, mut processed_paths)!

	if reset {
		gitstructure.cache_reset()!
		$dbg;
	}

	for _, mut repo in gitstructure.repos {
		repo.status_update(reset: reset)!
	}
}

// Recursively loads repositories from the provided path, updating their statuses, does not check the status
//
// Args:
// - path (string): The path to search for repositories.
// - processed_paths ([]string): List of already processed paths to avoid duplication.
fn (mut gitstructure GitStructure) load_recursive(path string, mut processed_paths []string) ! {
	path_object := pathlib.get(path)
	relpath := path_object.path_relative(gitstructure.coderoot.path)!

	// Limit the recursion depth to avoid deep directory traversal.
	if relpath.count('/') > 4 {
		return
	}

	items := os.ls(path) or {
		return error('Cannot load gitstructure because directory not found: ${path}')
	}

	for item in items {
		current_path := os.join_path(path, item)

		if os.is_dir(current_path) {
			if os.exists(os.join_path(current_path, '.git')) {
				// Initialize the repository from the current path.
				mut repo := gitstructure.repo_init_from_path_(current_path)!
				// repo.status_update()!

				key_ := repo.cache_key()
				path_ := repo.path()

				if processed_paths.contains(key_) || processed_paths.contains(path_) {
					return error('Duplicate repository detected.\nPath: ${path_}\nKey: ${key_}')
				}

				processed_paths << path_
				processed_paths << key_
				gitstructure.repos[key_] = &repo
				continue
			}

			if item.starts_with('.') || item.starts_with('_') {
				continue
			}
			// Recursively search in subdirectories.
			gitstructure.load_recursive(current_path, mut processed_paths)!
		}
	}
}

@[params]
pub struct RepoInitParams {
	ssh_key_name string // name of ssh key to be used in repo
}

// Initializes a Git repository from a given path by locating the parent directory with `.git`.
//
// Args:
// - path (string): Path to initialize the repository from.
//
// Returns:
// - GitRepo: Reference to the initialized repository.
//
// Raises:
// - Error: If `.git` is not found in the parent directories.
fn (mut gitstructure GitStructure) repo_init_from_path_(path string, params RepoInitParams) !GitRepo {
	mypath := pathlib.get_dir(path: path, create: false)!
	mut parent_path := mypath.parent_find('.git') or {
		return error('Cannot find .git in parent directories starting from: ${path}')
	}

	if parent_path.path == '' {
		return error('Cannot find .git in parent directories starting from: ${path}')
	}

	// Retrieve GitLocation from the path.
	gl := gitstructure.gitlocation_from_path(mypath.path)!

	// Initialize and return a GitRepo struct.
	mut r := GitRepo{
		gs:            &gitstructure
		status_remote: GitRepoStatusRemote{}
		status_local:  GitRepoStatusLocal{}
		config:        GitRepoConfig{}
		provider:      gl.provider
		account:       gl.account
		name:          gl.name
		deploysshkey:  params.ssh_key_name
	}

	return r
}

// returns the git repository of the working directory by locating the parent directory with `.git`.
//
// Returns:
// - GitRepo: Reference to the initialized repository.
//
// Raises:
// - None: If `.git` is not found in the parent directories.
pub fn (mut gitstructure GitStructure) get_working_repo() ?GitRepo {
	curdir := pathlib.get_wd()
	return gitstructure.repo_init_from_path_(curdir.path) or { return none }
}

// key in redis used to store all config info
fn cache_key(coderoot string) string {
	key := md5.hexhash(coderoot)
	return 'git:${key}'
}

// key in redis used to store all config info
pub fn (mut self GitStructure) cache_key() string {
	return cache_key(self.coderoot.path)
}

// load from cache
pub fn (mut self GitStructure) cache_load() ! {
	// Retrieve the configuration from Redis.
	mut redis := redis_get()
	keys := redis.keys('${self.cache_key()}:repos')!
	self.repos = map[string]&GitRepo{} // reset
	for key in keys {
		data := redis.get(key)!
		mut r := json.decode(GitRepo, data)!
		self.repos[key] = &r
	}
}

// Reset all caches and configurations for all Git repositories.
pub fn (mut self GitStructure) cache_reset() ! {
	mut redis := redis_get()
	keys := redis.keys('${self.cache_key()}:**')!
	for key in keys {
		redis.del(key)!
	}
}

// Load config from redis
fn (mut self GitStructure) coderoot() !pathlib.Path {
	mut coderoot := pathlib.get_dir(path: self.coderoot.path, create: true)!
	return coderoot
}

////// CONFIG

// Load config from redis
pub fn (mut self GitStructure) config() !GitStructureConfig {
	mut config := self.config_ or {
		mut redis := redis_get()
		data := redis.get('${self.cache_key()}:config')!
		mut c := GitStructureConfig{}
		if data.len > 0 {
			c = json.decode(GitStructureConfig, data)!
		}
		c
	}

	return config
}

// Reset the configuration cache for Git structures.
pub fn (mut self GitStructure) config_reset() ! {
	mut redis := redis_get()
	redis.del('${self.cache_key()}:config')!
}

// save to the cache
pub fn (mut self GitStructure) config_save() ! {
	// Retrieve the configuration from Redis.
	mut redis := redis_get()
	datajson := json.encode(self.config()!)
	redis.set('${self.cache_key()}:config', datajson)!
}
