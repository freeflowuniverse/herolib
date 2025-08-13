// File: lib/clients/gitea_client/readme.md
# gitea_client

This library provides a client for interacting with the Gitea API.

## Configuration

You can configure the client using a HeroScript file:

```hero
!!gitea_client.configure
    name: 'default' // optional, 'default' is the default instance name
    url: 'https://git.ourworld.tf'
    secret: 'your-gitea-api-token'
```

Save this content in your project's configuration (e.g., `~/.config/hero/config.hcl`) or pass it to a playbook.

## Usage Example

Here's how to get the client and use its methods.

```vlang
import freeflowuniverse.herolib.clients.gitea_client
import freeflowuniverse.herolib.core.base

fn main() ! {
    // Make sure hero is initialized
    base.init()!

	// Example configuration (can also be loaded from file)
	heroscript_config := "!!gitea_client.configure url:'https://gitea.com' secret:'...your_token...'"
	mut plbook := playbook.new(text: heroscript_config)!
	gitea_client.play(mut plbook)!

	// Get the default configured client
	mut client := gitea_client.get()!

	// Get the authenticated user
	user := client.get_current_user()!
	println('Authenticated as: ${user.login}')

	// List repositories for the authenticated user
	repos := client.user_list_repos()!
	println('Found ${repos.len} repositories:')
	for repo in repos {
		println('- ${repo.full_name}')
	}

    // Get a specific repository's issues
    owner := 'gitea'
    repo_name := 'gitea'
    println('\nFetching issues for ${owner}/${repo_name}...')
    issues := client.list_repo_issues(owner, repo_name)!
    println('Found ${issues.len} issues.')
    for issue in issues[..5] { // print first 5 issues
        println('  #${issue.number}: ${issue.title}')
    }
}
