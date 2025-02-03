module gittools

import time
import freeflowuniverse.herolib.ui.console
import os

@[params]
pub struct StatusUpdateArgs {
	reload bool
}

pub fn (mut repo GitRepo) status_update(args StatusUpdateArgs) ! {
	// Check current time vs last check, if needed (check period) then load
	repo.cache_get() or { 
		return error('Failed to get cache for repo ${repo.name}: ${err}')
	} // Ensure we have the situation from redis
	repo.init() or {
		return error('Failed to initialize repo ${repo.name}: ${err}')
	}
	current_time := int(time.now().unix())
	if args.reload || repo.last_load == 0
		|| current_time - repo.last_load >= repo.config.remote_check_period {
		//console.print_debug('${repo.name} ${current_time}-${repo.last_load} (${current_time - repo.last_load >= repo.config.remote_check_period}): ${repo.config.remote_check_period}  +++')
		// if true{exit(0)}
		repo.load() or {
			return error('Failed to load repository ${repo.name}: ${err}')
		}
	}
}

// Load repo information
// Does not check cache, it is the callers responsibility to check cache and load accordingly.
fn (mut repo GitRepo) load() ! {
	console.print_header('load ${repo.cache_key()}')
	repo.init() or {
		return error('Failed to initialize repo during load operation: ${err}')
	}
	
	git_path := '${repo.path()}/.git'
	if os.exists(git_path) == false {
		return error('Repository not found: ${repo.path()} is not a valid git repository (missing .git directory)')
	}

	repo.exec('git fetch --all') or {
		return error('Failed to fetch updates for ${repo.name} at ${repo.path()}: ${err}. Please check network connection and repository access.')
	}

	repo.load_branches() or {
		return error('Failed to load branches for ${repo.name}: ${err}')
	}

	repo.load_tags() or {
		return error('Failed to load tags for ${repo.name}: ${err}')
	}

	repo.last_load = int(time.now().unix())

	repo.has_changes = repo.detect_changes() or {
		return error('Failed to detect changes in repository ${repo.name}: ${err}')
	}

	repo.cache_set() or {
		return error('Failed to update cache for repository ${repo.name}: ${err}')
	}
}

// Helper to load remote tags
fn (mut repo GitRepo) load_branches() ! {
	tags_result := repo.exec("git for-each-ref --format='%(objectname) %(refname:short)' refs/heads refs/remotes/origin") or {
		return error('Failed to get branch references: ${err}. Command: git for-each-ref')
	}
	for line in tags_result.split('\n') {
		line_trimmed := line.trim_space()
		//println(line_trimmed)
		if line_trimmed != '' {
			parts := line_trimmed.split(' ')
			if parts.len < 2 {
				//console.print_debug('Info: skipping malformed branch/tag line: ${line_trimmed}')
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
	}else{
	 	return error("bug: git branch does not give branchname.\n${mybranch}")
	}
}

// Helper to load remote tags
fn (mut repo GitRepo) load_tags() ! {
	tags_result := repo.exec('git tag --list') or {
		return error('Failed to list tags: ${err}. Please ensure git is installed and repository is accessible.')
	}

	for line in tags_result.split('\n') {
		line_trimmed := line.trim_space()
		if line_trimmed != '' {
			parts := line_trimmed.split(' ')
			if parts.len < 2 {
				console.print_debug('Skipping malformed tag line: ${line_trimmed}')
				continue
			}
			commit_hash := parts[0].trim_space()
			tag_name := parts[1].all_after('refs/tags/').trim_space()

			// Update remote tags info
			repo.status_remote.tags[tag_name] = commit_hash
		}
	}
}
