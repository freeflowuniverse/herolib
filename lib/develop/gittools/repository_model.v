module gittools


// GitRepo represents a single git repository.
@[heap]
pub struct GitRepo {
	// a git repo is always part of a git structure
mut:
	gs &GitStructure
	last_load int // epoch when last loaded
pub mut:
	provider     string // e.g., github.com
	account      string // Git account name
	name         string // Repository name
	deploysshkey string // SSH key for git operations
	config       GitRepoConfig
	status       GitStatus
}

// GitStatus holds the unified status information for a repository.
// It reflects the CURRENT state, not a desired state.
pub struct GitStatus {
pub mut:
	// Combined local & remote state (from fetch)
	branches map[string]string // All branch names -> commit hash
	tags     map[string]string // All tag names -> commit hash

	// Current local state
	branch   string // The current checked-out branch.
	tag      string // The current checked-out tag (if any).
	ahead    int    // Commits ahead of remote.
	behind   int    // Commits behind remote.

	// Combined status
	has_changes bool   // True if there are uncommitted local changes.
	error       string // Error message if any status update fails.
}

pub struct GitRepoConfig {
pub mut:
	remote_check_period int = 300 // seconds, 5 min
}

// // just some initialization mechanism
// fn (mut gitstructure GitStructure) repo_new_from_gitlocation(git_location GitLocation) !&GitRepo {
// 	mut repo := GitRepo{
// 		provider:      git_location.provider
// 		name:          git_location.name
// 		account:       git_location.account
// 		gs:            &gitstructure
// 		status_remote: GitRepoStatusRemote{}
// 		status_local:  GitRepoStatusLocal{}
// 		status_wanted: GitRepoStatusWanted{}
// 	}
// 	gitstructure.repos[repo.cache_key()] = &repo

// 	return &repo
// }
