#!/usr/bin/env -S v -cg -enable-globals run

import os
import freeflowuniverse.herolib.develop.gittools
import freeflowuniverse.herolib.develop.performance

mut silent := false

coderoot := if 'CODEROOT' in os.environ() {
	os.environ()['CODEROOT']
} else {os.join_path(os.home_dir(), 'code')}

mut gs := gittools.get()!
if coderoot.len > 0 {
	//is a hack for now 
	gs = gittools.new(coderoot: coderoot)!
}

mypath := gs.do(
	recursive: true
	cmd: 'list'
)!

timer := performance.new('gittools')
timer.timeline()