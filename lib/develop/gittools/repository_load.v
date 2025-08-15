module gittools

import time
import freeflowuniverse.herolib.ui.console
import os

@[params]
pub struct StatusUpdateArgs {
	reset bool
}

pub fn (mut repo GitRepo) status_update(args StatusUpdateArgs) ! {
	repo.init()!

	// Skip remote checks if offline.
	if 'OFFLINE' in os.environ() || (repo.gs.config()!.offline) {
		console.print_debug('status update skipped (offline) for ${repo.path()}')
		return
	}

	current_time := int(time.now().unix())
	// Decide if a full load is needed.
	if args.reset || repo.last_load == 0
		|| current_time - repo.last_load >= repo.config.remote_check_period {
		repo.load_internal() or {
			// Persist the error state to the cache
			if repo.status_remote.error == '' {
				repo.status_remote.error = 'Failed to load repository: ${err}'
			}
			repo.cache_set()!
			return error('Failed to load repository ${repo.name}: ${err}')
		}
	}
}

// load_internal performs the expensive git operations to refresh the repository state.
// It should only be called by status_update().
fn (mut repo GitRepo) load_internal() ! {
	console.print_header('load ${repo.print_key()}')
	repo.init()!

	repo.exec('git fetch --all') or {
		repo.status_remote.error = 'Failed to fetch updates: ${err}'
		return error('Failed to fetch updates for ${repo.name} at ${repo.path()}: ${err}. Please check network connection and repository access.')
	}
	repo.load_branches()!
	repo.load_tags()! 

	// Reset ahead/behind counts before recalculating
	repo.status_local.ahead = 0
	repo.status_local.behind = 0

	// Get ahead/behind information for the current branch
	status_res := repo.exec('git status --porcelain=v2 --branch')!
	for line in status_res.split_into_lines() {
		if line.starts_with('# branch.ab') {
			parts := line.split(' ')
			if parts.len > 3 {
				ahead_str := parts[2]
				behind_str := parts[3]
				if ahead_str.starts_with('+') {
					repo.status_local.ahead = ahead_str[1..].int()
				}
				if behind_str.starts_with('-') {
					repo.status_local.behind = behind_str[1..].int()
				}
			}
			break // We only need this one line
		}
	}

	repo.last_load = int(time.now().unix())

	repo.has_changes = repo.detect_changes() or {
		repo.status_local.error = 'Failed to detect changes: ${err}'
		return error('Failed to detect changes in repository ${repo.name}: ${err}')
	}

	// Persist the newly loaded state to the cache.
	repo.cache_set()!
}

// Helper to load remote tags
fn (mut repo GitRepo) load_branches() ! {
	tags_result := repo.exec("git for-each-ref --format='%(objectname) %(refname:short)' refs/heads refs/remotes/origin") or {
		return error('Failed to get branch references: ${err}. Command: git for-each-ref')
	}
	for line in tags_result.split('\n') {
		line_trimmed := line.trim_space()
		// println(line_trimmed)
		if line_trimmed != '' {
			parts := line_trimmed.split(' ')
			if parts.len < 2 {
				// console.print_debug('Info: skipping malformed branch/tag line: ${line_trimmed}')
				continue
			}
			commit_hash := parts[0].trim_space()
			mut name := parts[1].trim_space()
			if name.contains('_archive') {
				continue
			} else if name == 'origin' {
				repo.status_remote.ref_default = commit_hash
			} else if name.starts_with('origin') {
				name = name.all_after('origin/').trim_space()
				// Update remote tags info
				repo.status_remote.branches[name] = commit_hash
			} else {
				repo.status_local.branches[name] = commit_hash
			}
		}
	}

	mybranch := repo.exec('git branch --show-current') or {
		return error('Failed to get current branch: ${err}')
	}.split_into_lines().filter(it.trim_space() != '')
	if mybranch.len == 1 {
		repo.status_local.branch = mybranch[0].trim_space()
	} else {
		return error('bug: git branch does not give branchname.\n${mybranch}')
	}
}

// Helper to load remote tags
fn (mut repo GitRepo) load_tags() ! {
	// CORRECTED: Use for-each-ref to get commit hashes for tags.
	tags_result := repo.exec("git for-each-ref --format='%(objectname) %(refname:short)' refs/tags") or {
		return error('Failed to list tags: ${err}. Please ensure git is installed and repository is accessible.')
	}

	for line in tags_result.split('\n') {
		line_trimmed := line.trim_space()
		if line_trimmed != '' {
			parts := line_trimmed.split(' ')
			if parts.len < 2 {
				continue // Skip malformed lines
			}
			commit_hash := parts[0].trim_space()
			// refname:short for tags is just the tag name itself.
			tag_name := parts[1].trim_space()

			// Update remote tags info
			repo.status_remote.tags[tag_name] = commit_hash
		}
	}
}

// Retrieves a list of unstaged changes in the repository.
//
// This function returns a list of files that are modified or untracked.
//
// Returns:
// - An array of strings representing file paths of unstaged changes.
// - Throws an error if the command execution fails.
pub fn (repo GitRepo) get_changes_unstaged() ![]string {
	unstaged_result := repo.exec('git ls-files --other --modified --exclude-standard') or {
		return error('Failed to check for unstaged changes: ${repo.path()}\n${err}')
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
		return error('Failed to check for staged changes: ${repo.path()}\n${err}')
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