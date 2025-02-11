module gittools

import freeflowuniverse.herolib.core.redisclient
import time

// ReposGetArgs defines arguments to retrieve repositories from the git structure.
// It includes filters by name, account, provider, and an option to clone a missing repo.
@[params]
pub struct ReposGetArgs {
pub mut:
	filter        string // Optional filter for repository names
	name          string // Specific repository name to retrieve.
	account       string // Git account associated with the repository.
	provider      string // Git provider (e.g., GitHub).
	pull          bool   // Pull the last changes.
	reset         bool   // Reset the changes.
	status_clean  bool   // make sure each cache status is but on 0, if we also do status_update this will result in a reload
	status_update bool   // make sure each repo get's status updated
	url           string // Repository URL
}

// Retrieves a list of repositories from the git structure that match the provided arguments.
// if pull will force a pull, if it can't will be error, if reset will remove the changes
//
// Args:
//```
// ReposGetArgs {
// filter   string // Optional filter for repository names
// name     string // Specific repository name to retrieve.
// account  string // Git account associated with the repository.
// provider string // Git provider (e.g., GitHub).
//	pull     bool   // Pull the last changes.
//	reset    bool   // Reset the changes
// status_clean   bool   //make sure each cache status is but on 0, if we also do status_update this will result in a reload
// status_update bool //make sure each repo get's status updated
// url      string // Repository URL, used if cloning is needed.
//```
// Returns:
// - []&GitRepo: A list of repository references that match the criteria.
pub fn (mut gitstructure GitStructure) get_repos(args_ ReposGetArgs) ![]&GitRepo {
	mut args := args_

	mut res := []&GitRepo{}

	for _, repo in gitstructure.repos {
		if args.url.len > 0 {
			// if being mathed from url load repo info
			git_location := gitstructure.gitlocation_from_url(args.url)!
			args.account = git_location.account
			args.provider = git_location.provider
			args.name = git_location.name
		}

		if repo_match_check(repo, args)! {
			res << repo
		}
	}

	for mut repo in res {
		if args.status_clean {
			repo.cache_last_load_clear()!
		}
		if args.status_update {
			repo.status_update()!
		}
		if args.reset {
			repo.reset()!
		} else {
			if args.pull {
				repo.pull()!
			}
		}
	}

	return res
}

// Retrieves a single repository based on the provided arguments.
// if pull will force a pull, if it can't will be error, if reset will remove the changes
// If the repository does not exist, it will clone it
//
// Args:
//```
// ReposGetArgs {
// filter   string // Optional filter for repository names
// name     string // Specific repository name to retrieve.
// account  string // Git account associated with the repository.
// provider string // Git provider (e.g., GitHub).
// pull     bool   // Pull the last changes.
// reset    bool   // Reset the changes.
// url      string // Repository URL, used if cloning is needed.
//```
//
// Returns:
// - &GitRepo: Reference to the retrieved or cloned repository.
//
// Raises:
// - Error: If multiple repositories are found with similar names or if cloning fails.
pub fn (mut gitstructure GitStructure) get_repo(args_ ReposGetArgs) !&GitRepo {
	mut args := args_

	repositories := gitstructure.get_repos(args)!

	if repositories.len == 0 {
		if args.url.len == 0 {
			return error('Cannot clone the repository, no URL provided: ${args.url}')
		}
		return gitstructure.clone(url: args.url)!
	}

	if repositories.len > 1 {
		repos := repositories.map('- ${it} ${it.account}.${it.name}').join_lines()
		return error('Found more than one repository for \n${args}\n${repos}')
	}

	return repositories[0]
}

// Helper function to check if a repository matches the criteria (name, account, provider).
//
// Args:
// - repo (GitRepo): The repository to check.
// - args (ReposGetArgs): The criteria to match against.
//
// Returns:
// - bool: True if the repository matches, false otherwise.
fn repo_match_check(repo GitRepo, args ReposGetArgs) !bool {
	mut r := (args.name.len == 0 || repo.name == args.name)
		&& (args.account.len == 0 || repo.account == args.account)
		&& (args.provider.len == 0 || repo.provider == args.provider)
	relpath := repo.get_relative_path()!
	if r {
		if args.filter != '' && !(relpath.contains(args.filter)) {
			return false
		}
	}

	return r
}

// Retrieves a single repository path based on the provided arguments (goes inside repo).
// if pull will force a pull, if it can't will be error, if reset will remove the changes
// If the repository does not exist, it will clone it
//
// Args:
//```
// ReposGetArgs {
// name     string // Specific repository name to retrieve.
// account  string // Git account associated with the repository.
// provider string // Git provider (e.g., GitHub).
// pull     bool   // Pull the last changes.
// reset    bool   // Reset the changes.
// url      string // Repository URL, used if cloning is needed.
//```
//
// Returns:
// - &GitRepo: Reference to the retrieved or cloned repository.
//
// Raises:
// - Error: If multiple repositories are found with similar names or if cloning fails.
pub fn (mut gitstructure GitStructure) get_path(args_ ReposGetArgs) !string {
	mut args := args_
	if args.pull {
		args.status_clean = true
	}
	mut r := gitstructure.get_repo(args_)!
	mut mypath := r.get_path_of_url(args_.url)!
	return mypath
}
