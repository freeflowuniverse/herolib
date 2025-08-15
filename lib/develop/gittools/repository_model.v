module gittools

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
	error       string            // Error message if remote status update fails
}

// GitRepoStatusLocal holds local status information for a repository.
pub struct GitRepoStatusLocal {
pub mut:
	branches map[string]string // Branch name -> commit hash
	branch   string            // the current branch
	tag      string            // If the local branch is not set, the tag may be set
	ahead    int               // Commits ahead of remote
	behind   int               // Commits behind remote
	error    string            // Error message if local status update fails
}

// GitRepoConfig holds repository-specific configuration options.
pub struct GitRepoConfig {
pub mut:
	remote_check_period int = 3600 * 24 * 7 // Seconds to wait between remote checks (0 = check every time), default 7 days
}

// just some initialization mechanism
fn (mut gitstructure GitStructure) repo_new_from_gitlocation(git_location GitLocation) !&GitRepo {
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
