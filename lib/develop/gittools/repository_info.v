module gittools


// Check if there are staged changes to commit.
pub fn (mut repo GitRepo) need_commit() !bool {
    // This function assumes `status_update` has already been called.
	return repo.has_changes
}

// Check if the repository has local changes that need to be pushed to remote
pub fn (mut repo GitRepo) need_push() !bool {
	// This function assumes `status_update` has already run to populate the status.

	// A new local branch that doesn't exist on the remote needs to be pushed.
	if repo.status_local.branch != '' && repo.get_last_remote_commit()! == '' {
		return true
	}
	// If the local branch is ahead of its remote counterpart, it needs to be pushed.
	return repo.status_local.ahead > 0
}

// Check if the repository needs to pull changes from remote
pub fn (mut repo GitRepo) need_pull() !bool {
	// This function assumes `status_update` has already run to populate the status.
	// If the local branch is behind its remote counterpart, it needs to be pulled.
	return repo.status_local.behind > 0
}

// Legacy function for backward compatibility
pub fn (mut repo GitRepo) need_push_or_pull() !bool {
	// This function relies on the simplified need_push() and need_pull() checks.
	return repo.need_push()! || repo.need_pull()!
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
		return error('ref_default cannot be empty for ${repo.path()}')
	}

	return repo.status_remote.branches[repo.status_remote.ref_default] or {
		return error("can't find ref_default in branches for ${repo.path()}")
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
	return ''
}
