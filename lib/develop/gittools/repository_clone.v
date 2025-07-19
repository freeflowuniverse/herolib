module gittools

import freeflowuniverse.herolib.ui.console
import os

@[params]
pub struct GitCloneArgs {
pub mut:
	//only url needed because is a clone
	url    string
	sshkey string
}

// Clones a new repository into the git structure based on the provided arguments.
pub fn (mut gitstructure GitStructure) clone(args GitCloneArgs) !&GitRepo {
	if args.url.len == 0 {
		return error('url needs to be specified when doing a clone.')
	}

	console.print_header('Git clone from the URL: ${args.url}.')
	//gitlocatin comes just from the url, not from fs of whats already there
	git_location := gitstructure.gitlocation_from_url(args.url)!


	mut repo := gitstructure.repo_new_from_gitlocation(git_location)!
	//TODO: this seems to be wrong, we should not set the url here
	// repo.status_wanted.url = args.url
	// repo.status_wanted.branch = git_location.branch_or_tag

	mut repopath := repo.patho()!
	if repopath.exists(){
		return error("can't clone on existing path, came from url, path found is ${repopath.path}.\n")
	}


	if args.sshkey.len > 0 {
		repo.set_sshkey(args.sshkey)!
	}

	parent_dir := repo.get_parent_dir(create: true)!

	cfg := gitstructure.config()!


	mut extra := ''
	if cfg.light {
		extra = '--depth 1 --no-single-branch '
	}

	//the url needs to be http if no agent, otherwise its ssh, the following code will do this
	mut cmd := 'cd ${parent_dir} && git clone ${extra} ${repo.get_repo_url_for_clone()!} ${repo.name}'


	mut sshkey_include := ''
	if cfg.ssh_key_path.len > 0 {
		sshkey_include = "GIT_SSH_COMMAND=\"ssh -i ${cfg.ssh_key_path}\" "
		cmd = 'cd ${parent_dir} && ${sshkey_include}git clone ${extra} ${repo.get_ssh_url()!} ${repo.name}'
	}

	console.print_debug(cmd)
	result := os.execute(cmd)
	if result.exit_code != 0 {
		return error('Cannot clone the repository due to: \n${result.output}')
	}

	repo.load()!
	if repo.need_checkout() {
		repo.checkout()!
	}

	console.print_green("The repository '${repo.name}' cloned into ${parent_dir}.")

	return repo
}
