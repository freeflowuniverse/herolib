module gitresolver

// GitUrlResolver interface defines the contract for resolving git URLs to local paths
pub interface GitUrlResolver {
	// get_repo_path resolves a git URL to a local repository path
	// and optionally pulls/resets the repository
	get_repo_path(url string, pull bool, reset bool) !string
}

// Global registry for git URL resolver implementation
__global (
	git_resolver ?GitUrlResolver
)

// register_resolver sets the global git URL resolver implementation
pub fn register_resolver(resolver GitUrlResolver) {
	git_resolver = resolver
}

// get_resolver returns the registered git URL resolver
pub fn get_resolver() !GitUrlResolver {
	if resolver := git_resolver {
		return resolver
	} else {
		return error('No git URL resolver has been registered. Make sure to import and initialize the gittools module.')
	}
}

// resolve_git_url is a convenience function that uses the registered resolver
pub fn resolve_git_url(url string, pull bool, reset bool) !string {
	resolver := get_resolver()!
	return resolver.get_repo_path(url, pull, reset)
}
