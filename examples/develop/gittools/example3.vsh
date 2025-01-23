#!/usr/bin/env -S v -n -w -gc none -cg -no-retry-compilation -cc tcc -d use_openssl -enable-globals run
// #!/usr/bin/env -S v -n -w -cg -no-retry-compilation -d use_openssl -enable-globals run
//-parallel-cc
import os
import freeflowuniverse.herolib.develop.gittools

mut gs := gittools.get(reload:false)!

gs.repos_print()!