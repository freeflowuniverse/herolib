module gittools

// FUNCITONS TO GET INFO FROM REALITY

// Retrieves a list of unstaged changes in the repository.
//
// This function returns a list of files that are modified or untracked.
//
// Returns:
// - An array of strings representing file paths of unstaged changes.
// - Throws an error if the command execution fails.
pub fn (repo GitRepo) get_changes_unstaged() ![]string {
	unstaged_result := repo.exec('git ls-files --other --modified --exclude-standard') or {
		return error('Failed to check for unstaged changes: ${err}')
	}

	// Filter out any empty lines from the result.
	return unstaged_result.split('\n').filter(it.len > 0)
}

// Retrieves a list of staged changes in the repository.
//
// This function returns a list of files that are staged and ready to be committed.
//
// Returns:
// - An array of strings representing file paths of staged changes.
// - Throws an error if the command execution fails.
pub fn (repo GitRepo) get_changes_staged() ![]string {
	staged_result := repo.exec('git diff --name-only --staged') or {
		return error('Failed to check for staged changes: ${err}')
	}
	// Filter out any empty lines from the result.
	return staged_result.split('\n').filter(it.len > 0)
}

// Check if there are any unstaged or untracked changes in the repository.
pub fn (mut repo GitRepo) detect_changes() !bool {
	r0 := repo.get_changes_unstaged()!
	r1 := repo.get_changes_staged()!
	if r0.len + r1.len > 0 {
		return true
	}
	return false
}

// Check if there are staged changes to commit.
pub fn (mut repo GitRepo) need_commit() !bool {
	return repo.has_changes
}

// Check if the repository has changes that need to be pushed (is against the cached info).
pub fn (mut repo GitRepo) need_push_or_pull() !bool {
	repo.status_update()!
	last_remote_commit := repo.get_last_remote_commit() or {
		return error('Failed to get last remote commit: ${err}')
	}
	last_local_commit := repo.get_last_local_commit() or {
		return error('Failed to get last local commit: ${err}')
	}
	// println('commit status: ${repo.name} ${last_local_commit} ${last_remote_commit}')
	return last_local_commit != last_remote_commit
}

// Determine if the repository needs to checkout to a different branch or tag
fn (mut repo GitRepo) need_checkout() bool {
	if repo.status_wanted.branch.len > 0 {
		if repo.status_wanted.branch != repo.status_local.branch {
			return true
		}
	} else if repo.status_wanted.tag.len > 0 {
		if repo.status_wanted.tag != repo.status_local.tag {
			return true
		}
	}
	// it could be empty since the status_wanted are optional.
	// else{
	// 	panic("bug, should never be empty ${repo.status_wanted.branch}, ${repo.status_local.branch}")
	// }
	return false
}

fn (mut repo GitRepo) get_remote_default_branchname() !string {
	if repo.status_remote.ref_default.len == 0 {
		return error('ref_default cannot be empty for ${repo}')
	}

	return repo.status_remote.branches[repo.status_remote.ref_default] or {
		return error("can't find ref_default in branches for ${repo}")
	}
}

// is always the commit for the branch as known remotely, if not known will return ""
pub fn (self GitRepo) get_last_remote_commit() !string {
	if self.status_local.branch in self.status_remote.branches {
		return self.status_remote.branches[self.status_local.branch]
	}

	return ''
}

// get commit for branch, will return '' if local branch doesn't exist remotely
pub fn (self GitRepo) get_last_local_commit() !string {
	if self.status_local.branch in self.status_local.branches {
		return self.status_local.branches[self.status_local.branch]
	}

	return error("can't find branch: ${self.status_local.branch} in local branches:\n${self.status_local.branches}")
}
