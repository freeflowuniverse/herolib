#!/usr/bin/env -S v -cg -enable-globals run

import freeflowuniverse.herolib.develop.gittools
import freeflowuniverse.herolib.osal
import time


mut gs_default := gittools.new()!

println(gs_default)

// // Initializes the Git structure with the coderoot path.
// coderoot := '/tmp/code'
// mut gs_tmo := gittools.new(coderoot: coderoot)!

// // Retrieve the specified repository.
// mut repo := gs_default.get_repo(name: 'herolib')!

// println(repo)
