module playbook

import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.data.paramsparser
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.develop.gittools // Added import for gittools

// Include external playbook actions (from git repo or local path)
// based on actions defined as `!!play.include`.
// Parameters:
//   git_url   – git repository URL (optional)
//   git_pull  – pull latest changes (bool, default false)
//   git_reset – reset local copy (bool, default false)
//   path      – local path to include (optional)
pub fn (mut plbook PlayBook) include() ! {
    // Find all include actions in the playbook
    mut inc_actions := plbook.find(filter: 'play.include')!
    if inc_actions.len == 0 {
        return
    }

    for mut inc in inc_actions {
        mut p := inc.params

        // Extract parameters with sensible defaults
        git_url := p.get_default('git_url', '')!
        git_pull := p.get_default_false('git_pull')
        git_reset := p.get_default_false('git_reset')
        path := p.get_default('path', '')!

        // Resolve the path to include
        mut includepath := ''
        if git_url != '' {
            // Resolve a git repository path (may clone / pull)
            includepath = gittools.path(
                git_url: git_url,
                path: path,
                git_pull: git_pull,
                git_reset: git_reset,
            )!.path
        } else {
            includepath = path
        }

        // Add the found content (files / directories) to the current playbook.
        // `add` will handle reading files, recursing into directories, etc.
        if includepath != '' {
            plbook.add(path: includepath)!
        }

        // Mark this include action as processed
        inc.done = true
    }
}
