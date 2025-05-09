# how to use the playcmds

```v
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.core.base

mut s:=base.session_new(
    coderoot:'/tmp/code'
    interactive:true
)!


// Path to the code execution directory
path string

// Command text to execute (e.g., "ls -la")
text string

// Git repository URL for version control
git_url string

// Pull latest changes from git
git_pull bool

// Git branch to use
git_branch string

// Reset repository before pull
git_reset bool

// Execute command after setup
execute bool = true

// Optional session object for state management
session ?&base.Session

mut plbook := playbook.new(text: "....",session:s) or { panic(err) }





```