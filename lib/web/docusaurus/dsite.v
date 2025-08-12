module docusaurus

import freeflowuniverse.herolib.osal.screen
import os
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.web.site as sitemodule
import freeflowuniverse.herolib.osal.core as osal
import freeflowuniverse.herolib.ui.console
import time

@[heap]
pub struct DocSite {
pub mut:
	name         string
	url          string
	// path_src     pathlib.Path
	path_publish pathlib.Path
	path_build   pathlib.Path
	errors       []SiteError
	config       Configuration
	website      sitemodule.Site
	importparams     []ImportParams
 }

pub fn (mut s DocSite) build() ! {
	s.generate()!
	osal.exec(
		cmd:   '
			cd ${s.path_build.path}
			bun run build
			'
		retry: 0
	)!
}

pub fn (mut s DocSite) build_dev_publish() ! {
	s.generate()!
	osal.exec(
		cmd:   '
			cd ${s.path_build.path}
			bun run build
			'
		retry: 0
	)!
}

pub fn (mut s DocSite) build_publish() ! {
	s.generate()!
	osal.exec(
		cmd:   '
			cd ${s.path_build.path}
			bun run build
			'
		retry: 0
	)!
}

@[params]
pub struct DevArgs {
pub mut:
	host          string = 'localhost'
	port          int    = 3000
	open          bool   = true  // whether to open the browser automatically
	watch_changes bool   = false // whether to watch for changes in docs and rebuild automatically
}

pub fn (mut s DocSite) open(args DevArgs) ! {
	// Print instructions for user
	console.print_item('open browser: https://${args.host}:${args.port}')
	osal.exec(cmd: 'open https://${args.host}:${args.port}')!
}

pub fn (mut s DocSite) dev(args DevArgs) ! {
	s.generate()!
	osal.exec(
		cmd:   '	
			cd ${s.path_build.path}
			bun run start -p ${args.port} -h ${args.host}
			'
		retry: 0
	)!
	s.open()!
}

@[params]
pub struct ErrorArgs {
pub mut:
	path string
	msg  string
	cat  ErrorCat
}

pub fn (mut site DocSite) error(args ErrorArgs) {
	// path2 := pathlib.get(args.path)
	e := SiteError{
		path: args.path
		msg:  args.msg
		cat:  args.cat
	}
	site.errors << e
	console.print_stderr(args.msg)
}
