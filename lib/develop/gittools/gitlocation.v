module gittools

import freeflowuniverse.herolib.core.pathlib

// GitLocation uniquely identifies a Git repository, its online URL, and its location in the filesystem.
@[heap]
pub struct GitLocation {
pub mut:
	provider      string // Git provider (e.g., GitHub)
	account       string // Account name
	name          string // Repository name
	branch_or_tag string // Branch name
	path          string // Path in the repository (not the filesystem)
	anker         string // Position in a file
}

//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////

// Get GitLocation from a path within the Git repository, doesn't read from fs, is just from path missing branch...
pub fn (mut gs GitStructure) gitlocation_from_path(path string) !GitLocation {
	mut full_path := pathlib.get(path)
	rel_path := full_path.path_relative(gs.coderoot.path)!

	// Validate the relative path
	mut parts := rel_path.split('/')
	if parts.len < 3 {
		return error("git: path is not valid, should contain provider/account/repository: '${rel_path}'")
	}

	// Extract provider, account, and repository name
	provider := parts[0]
	account := parts[1]
	name := parts[2]
	mut repo_path := if parts.len > 3 { parts[3..].join('/') } else { "" } //this is for relative path in repo

	return GitLocation{
		provider: provider
		account:  account
		name:     name
		path:     repo_path
	}
}

// Get GitLocation from a URL, doesn't go on filesystem just tries to figure out branch, ...
pub fn (mut gs GitStructure) gitlocation_from_url(url string) !GitLocation {
	mut urllower := url.trim_space()
	if urllower == '' {
		return error('url cannot be empty')
	}

	// Normalize URL
	urllower = normalize_url(urllower)

	// Split URL into parts
	mut parts := urllower.split('/')
	mut anchor := ''
	mut path := ''
	mut branch_or_tag := ''

	// Extract branch if available
	for i := 0; i < parts.len; i++ {
		if parts[i] == 'src' && i + 1 < parts.len && parts[i + 1] == 'branch' {
			if i + 2 < parts.len {
				branch_or_tag = parts[i + 2]
			}
			if i + 3 < parts.len {
				path = parts[(i + 3)..].join('/')
			}
			break
		} else if parts[i] == 'tree' {
			if i + 1 < parts.len {
				branch_or_tag = parts[i + 1]
			}
			if i + 2 < parts.len {
				path = parts[(i + 2)..].join('/')
			}
			break
		} else if parts[i] == 'refs' {
			if i + 1 < parts.len && (parts[i + 1] == 'heads' || parts[i + 1] == 'tags') {
				if i + 2 < parts.len {
					branch_or_tag = parts[i + 2]
				}
				if i + 3 < parts.len {
					path = parts[(i + 3)..].join('/')
				}
			} else if i + 1 < parts.len { // Fallback if no heads/tags
				branch_or_tag = parts[i + 1]
				if i + 2 < parts.len {
					path = parts[(i + 2)..].join('/')
				}
			}
			break
		}
	}

	// Deal with path and anchor
	if path.contains('#') {
		parts2 := path.split('#')
		if parts2.len == 2 {
			path = parts2[0]
			anchor = parts2[1]
		} else {
			return error("git: url badly formatted, more than 1 '#' in ${url}")
		}
	}

	// Validate parts
	if parts.len < 3 {
		return error("git: url badly formatted, not enough parts in '${urllower}' \nparts:\n${parts}")
	}

	// Extract provider, account, and name
	provider := if parts[0] == 'github.com' { 'github' } else { parts[0] }
	account := parts[1]
	name := parts[2].replace('.git', '')

	return GitLocation{
		provider:      provider
		account:       account
		name:          name
		branch_or_tag: branch_or_tag
		path:          path
		anker:         anchor
	}
}

// Normalize the URL for consistent parsing
fn normalize_url(url string) string {
	// Remove common URL prefixes
	if url.starts_with('ssh://') {
		return url[6..].replace(':', '/').replace('//', '/').trim('/')
	}
	if url.starts_with('git@') {
		return url[4..].replace(':', '/').replace('//', '/').trim('/')
	}
	if url.starts_with('http:/') {
		return url[6..].replace(':', '/').replace('//', '/').trim('/')
	}
	if url.starts_with('https:/') {
		return url[7..].replace(':', '/').replace('//', '/').trim('/')
	}
	if url.ends_with('.git') {
		return url[0..url.len - 4].replace(':', '/').replace('//', '/').trim('/')
	}
	return url.replace(':', '/').replace('//', '/').trim('/')
}
