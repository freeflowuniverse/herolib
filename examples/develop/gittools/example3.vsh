#!/usr/bin/env -S v -n -w -no-retry-compilation -d use_openssl -enable-globals run
//#!/usr/bin/env -S v -n -w -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run
//-parallel-cc
import os
import freeflowuniverse.herolib.develop.gittools
// import freeflowuniverse.herolib.develop.performance

mut silent := false

coderoot := if 'CODEROOT' in os.environ() {
	os.environ()['CODEROOT']
} else {
	os.join_path(os.home_dir(), 'code')
}

// timer := performance.new('gittools')


mut gs := gittools.get()!
if coderoot.len > 0 {
	// is a hack for now
	gs = gittools.new(coderoot: coderoot)!
}

mypath := gs.do(
	recursive: true
	cmd:       'list'
)!

// timer.timeline()
