module gittools

import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.osal
import os

// GitRepo holds information about a single Git repository.
@[heap]
pub struct GitRepo {
pub mut:
	gs            &GitStructure @[skip; str: skip] // Reference to the parent GitStructure
	provider      string              // e.g., github.com, shortened to 'github'
	account       string              // Git account name
	name          string              // Repository name
	status_remote GitRepoStatusRemote // Remote repository status
	status_local  GitRepoStatusLocal  // Local repository status
	status_wanted GitRepoStatusWanted // what is the status we want?
	config        GitRepoConfig       // Repository-specific configuration
	last_load     int                 // Epoch timestamp of the last load from reality
	deploysshkey  string              // to use with git
	has_changes   bool
}

// this is the status we want, we need to work towards off
pub struct GitRepoStatusWanted {
pub mut:
	branch   string
	tag      string
	url      string // Remote repository URL, is basically the one we want	
	readonly bool   // if read only then we cannot push or commit, all changes will be reset when doing pull
}

// GitRepoStatusRemote holds remote status information for a repository.
pub struct GitRepoStatusRemote {
pub mut:
	ref_default string            // is the default branch hash
	branches    map[string]string // Branch name -> commit hash
	tags        map[string]string // Tag name -> commit hash
}

// GitRepoStatusLocal holds local status information for a repository.
pub struct GitRepoStatusLocal {
pub mut:
	branches map[string]string // Branch name -> commit hash
	branch   string            // the current branch
	tag      string            // If the local branch is not set, the tag may be set
}

// GitRepoConfig holds repository-specific configuration options.
pub struct GitRepoConfig {
pub mut:
	remote_check_period int = 3600 * 24 * 3 // Seconds to wait between remote checks (0 = check every time), default 3 days
}

// just some initialization mechanism
pub fn (mut gitstructure GitStructure) repo_new_from_gitlocation(git_location GitLocation) !&GitRepo {
	mut repo := GitRepo{
		provider:      git_location.provider
		name:          git_location.name
		account:       git_location.account
		gs:            &gitstructure
		status_remote: GitRepoStatusRemote{}
		status_local:  GitRepoStatusLocal{}
		status_wanted: GitRepoStatusWanted{}
	}
	gitstructure.repos[repo.cache_key()] = &repo

	return &repo
}

//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////

// Commit the staged changes with the provided commit message.
pub fn (mut repo GitRepo) commit(msg string) ! {
	repo.status_update()!
	if repo.need_commit()! {
		if msg == '' {
			return error('Commit message is empty.')
		}
		repo_path := repo.path()
		repo.exec('git add . -A') or {
			return error('Cannot add to repo: ${repo_path}. Error: ${err}')
		}
		repo.exec('git commit -m "${msg}"') or {
			return error('Cannot commit repo: ${repo_path}. Error: ${err}')
		}
		console.print_green('Changes committed successfully.')
		repo.load()!
	} else {
		console.print_debug('No changes to commit.')
	}
}

// Push local changes to the remote repository.
pub fn (mut repo GitRepo) push() ! {
	repo.status_update()!
	if repo.need_push_or_pull()! {
		url := repo.get_repo_url()!
		console.print_header('Pushing changes to ${url}')
		// We may need to push the locally created branches
		repo.exec('git push --set-upstream origin ${repo.status_local.branch}')!
		console.print_green('Changes pushed successfully.')
		repo.load()!
	} else {
		console.print_header('Everything is up to date.')
	}
}

@[params]
pub struct PullCheckoutArgs {
pub mut:
	submodules bool // if we want to pull for submodules
}

// Pull remote content into the repository.
pub fn (mut repo GitRepo) pull(args_ PullCheckoutArgs) ! {
	repo.status_update()!
	if repo.need_checkout() {
		repo.checkout()!
	}

	repo.exec('git pull') or { return error('Cannot pull repo: ${repo.path()}. Error: ${err}') }

	if args_.submodules {
		repo.update_submodules()!
	}

	repo.load()!
	console.print_green('Changes pulled successfully.')
}

// Checkout a branch in the repository.
pub fn (mut repo GitRepo) checkout() ! {
	repo.status_update()!
	if repo.status_wanted.readonly {
		repo.reset()!
	}
	if repo.need_commit()! {
		return error('Cannot checkout branch due to uncommitted changes in ${repo.path()}.')
	}
	if repo.status_wanted.tag.len > 0 {
		repo.exec('git checkout tags/${repo.status_wanted.tag}')!
	}
	if repo.status_wanted.branch.len > 0 {
		repo.exec('git checkout ${repo.status_wanted.branch}')!
	}
	repo.cache_last_load_clear()!
}

// Create a new branch in the repository.
pub fn (mut repo GitRepo) branch_create(branchname string) ! {
	repo.exec('git branch -c ${branchname}') or {
		return error('Cannot Create branch: ${repo.path()} to ${branchname}\nError: ${err}')
	}
	repo.cache_last_load_clear()!
	console.print_green('Branch ${branchname} created successfully.')
}

pub fn (mut repo GitRepo) branch_switch(branchname string) ! {
	repo.exec('git switch ${branchname}') or {
		return error('Cannot switch branch: ${repo.path()} to ${branchname}\nError: ${err}')
	}
	console.print_green('Branch ${branchname} switched successfully.')
	repo.status_local.branch = branchname
	repo.status_local.tag = ''
	repo.pull()!
}

// Create a new branch in the repository.
pub fn (mut repo GitRepo) tag_create(tagname string) ! {
	repo_path := repo.path()
	repo.exec('git tag ${tagname}') or {
		return error('Cannot create tag: ${repo_path}. Error: ${err}')
	}
	console.print_green('Tag ${tagname} created successfully.')
}

pub fn (mut repo GitRepo) tag_switch(tagname string) ! {
	repo.exec('git checkout ${tagname}') or {
		return error('Cannot switch to tag: ${tagname}. Error: ${err}')
	}
	console.print_green('Tag ${tagname} activated.')
	repo.status_local.branch = ''
	repo.status_local.tag = tagname
	repo.pull()!
}

// Create a new branch in the repository.
pub fn (mut repo GitRepo) tag_exists(tag string) !bool {
	repo.exec('git show ${tag}') or { return false }
	return true
}

// Deletes the Git repository
pub fn (mut repo GitRepo) delete() ! {
	repo_path := repo.path()
	key := repo.cache_key()
	repo.cache_delete()!
	osal.rm(repo_path)!
	repo.gs.repos.delete(key) // Remove from GitStructure's repos map
}

// Create GitLocation from the path within the Git repository
pub fn (mut gs GitRepo) gitlocation_from_path(path string) !GitLocation {
	if path.starts_with('/') || path.starts_with('~') {
		return error('Path must be relative, cannot start with / or ~')
	}

	mut git_path := gs.patho()!
	repo_path := git_path.path
	abs_path := os.abs_path(path)

	// Check if path is inside git repo
	if !abs_path.starts_with(repo_path) {
		return error('Path ${path} is not inside the git repository at ${repo_path}')
	}

	// Get relative path in relation to root of gitrepo
	rel_path := abs_path[repo_path.len + 1..] // +1 to skip the trailing slash
	if !os.exists(abs_path) {
		return error('Path does not exist inside the repository: ${abs_path}')
	}

	mut branch_or_tag := gs.status_wanted.branch
	if gs.status_wanted.tag.len > 0 {
		branch_or_tag = gs.status_wanted.tag
	}

	return GitLocation{
		provider:      gs.provider
		account:       gs.account
		name:          gs.name
		branch_or_tag: branch_or_tag
		path:          rel_path // relative path in relation to git repo
	}
}

// Check if repo path exists and validate fields
pub fn (mut repo GitRepo) init() ! {
	path_string := repo.path()
	if repo.provider == '' {
		return error('Provider cannot be empty')
	}
	if repo.account == '' {
		return error('Account cannot be empty')
	}
	if repo.name == '' {
		return error('Name cannot be empty')
	}

	if !os.exists(path_string) {
		return error('Path does not exist: ${path_string}')
	}

	// Check if deploy key is set in repo config
	if repo.deploysshkey.len > 0 {
		git_config := repo.exec('git config --get core.sshCommand') or { '' }
		if !git_config.contains(repo.deploysshkey) {
			repo.set_sshkey(repo.deploysshkey)!
		}
	}

	// Check that either tag or branch is set on wanted, but not both
	if repo.status_wanted.tag.len > 0 && repo.status_wanted.branch.len > 0 {
		return error('Cannot set both tag and branch in wanted status. Choose one or the other.')
	}
}

// Set the ssh key on the repo
fn (mut repo GitRepo) set_sshkey(key_name string) ! {
	// will use this dir to find and set key from
	ssh_dir := os.join_path(os.home_dir(), '.ssh')
	key := osal.get_ssh_key(key_name, directory: ssh_dir) or {
		return error('SSH Key with name ${key_name} not found.')
	}

	private_key := key.private_key_path()!
	repo.exec('git config core.sshcommand "ssh -i ~/.ssh/${private_key.path}"')!
	repo.deploysshkey = key_name
}

// Removes all changes from the repo; be cautious
pub fn (mut repo GitRepo) remove_changes() ! {
	repo.status_update()!
	if repo.has_changes {
		console.print_header('Removing changes in ${repo.path()}')
		repo.exec('git reset HEAD --hard && git clean -xfd') or {
			return error("can't remove changes on repo: ${repo.path()}.\n${err}")
			// TODO: we can do this fall back later
			// console.print_header('Could not remove changes; will re-clone ${repo.path()}')
			// mut p := repo.patho()!
			// p.delete()! // remove path, this will re-clone the full thing
			// repo.load_from_url()!
		}
		repo.load()!
	}
}

// alias for remove changes
pub fn (mut repo GitRepo) reset() ! {
	return repo.remove_changes()
}

// Update submodules
fn (mut repo GitRepo) update_submodules() ! {
	repo.exec('git submodule update --init --recursive') or {
		return error('Cannot update submodules for repo: ${repo.path()}. Error: ${err}')
	}
}

fn (repo GitRepo) exec(cmd_ string) !string {
	repo_path := repo.path()
	cmd := 'cd ${repo_path} && ${cmd_}'
	// console.print_debug(cmd)
	r := os.execute(cmd)
	if r.exit_code != 0 {
		return error('Repo failed to exec cmd: ${cmd}\n${r.output})')
	}
	return r.output
}
