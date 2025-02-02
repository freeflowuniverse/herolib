module docusaurus

import freeflowuniverse.herolib.osal
import os
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.develop.gittools
import json

@[heap]
pub struct DocSite {
pub mut:
	name         string
	url          string
	path_src	 pathlib.Path
	path_build   pathlib.Path
	// path_publish pathlib.Path
	args         DSiteNewArgs
	errors       []SiteError
	config Config
}

@[params]
pub struct DSiteNewArgs {
pub mut:
	name         string
	nameshort    string 
	path         string
	url          string	
	// publish_path string
	build_path   string	
	production   bool
}

pub fn (mut f DocusaurusFactory) build_dev(args_ DSiteNewArgs) !&DocSite {
	mut s:=f.add(args_)!
	s.generate()!
	osal.exec(
		cmd: '	
			cd ${s.path_build.path}
			bash build_dev.sh
			'
		retry: 0
	)!	
	return s
}

pub fn (mut f DocusaurusFactory) build(args_ DSiteNewArgs) !&DocSite {
	mut s:=f.add(args_)!
	s.generate()!
	osal.exec(
		cmd: '	
			cd ${s.path_build.path}
			bash build.sh
			'
		retry: 0
	)!		
	return s
}

pub fn (mut f DocusaurusFactory) dev(args_ DSiteNewArgs) !&DocSite {
	mut s:=f.add(args_)!
	s.generate()!
	osal.exec(
		cmd: '	
			cd ${s.path_build.path}
			bash develop.sh
			'
		retry: 0
	)!		
	return s
}


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////


pub fn (mut f DocusaurusFactory) add(args_ DSiteNewArgs) !&DocSite {
	console.print_header(' Docusaurus: ${args_.name}')
	mut args := args_

	if args.build_path.len == 0 {
		args.build_path = '${f.path_build.path}'
	}
	// if args.publish_path.len == 0 {
	// 	args.publish_path = '${f.path_publish.path}/${args.name}'
	

	if args.url.len>0{

		mut gs := gittools.new()!
		args.path = gs.get_path(url: args.url)!
		
	}

	if args.path.len==0{
		return error("Can't get path from docusaurus site, its not specified.")

	}

	mut myconfig:=load_config("${args.path}/cfg")!

	if myconfig.main.name.len==0{
		myconfig.main.name = myconfig.main.base_url.trim_space().trim("/").trim_space()
	}


	if args.name == '' {
		args.name = myconfig.main.name
	}			

	if args.nameshort.len == 0 {
		args.nameshort = args.name
	}		
	args.nameshort = texttools.name_fix(args.nameshort)



	mut ds := DocSite{
		name: args.name
		url: args.url
		path_src: pathlib.get_dir(path: args.path, create: false)!
		path_build: f.path_build
		// path_publish: pathlib.get_dir(path: args.publish_path, create: true)!
		args: args
		config:myconfig
	}

	f.sites << &ds

	return &ds
}

@[params]
pub struct ErrorArgs {
pub mut:
	path string
	msg  string
	cat  ErrorCat
}

pub fn (mut site DocSite) error(args ErrorArgs) {
	path2 := pathlib.get(args.path)
	e := SiteError{
		path: args.path
		msg:  args.msg
		cat:  args.cat
	}
	site.errors << e
	console.print_stderr(args.msg)
}

pub fn (mut site DocSite) generate() ! {
	console.print_header(' site generate: ${site.name} on ${site.path_build.path}')
	site.template_install()!
	// osal.exec(
	// 	cmd: '	
	// 		cd ${site.path_build.path}
	// 		#Docusaurus build --dest-dir ${site.path_publish.path}
	// 		'
	// 	retry: 0
	// )!
	for item in ["src","static","cfg","docs"]{
		if os.exists("${site.path_src.path}/${item}"){
			mut aa:= site.path_src.dir_get(item)!
			aa.copy(dest:"${site.path_build.path}/${item}")!
		}
	}

}

fn (mut site DocSite) template_install() ! {
	mut gs := gittools.new()!

	mut r := gs.get_repo(url: 'https://github.com/freeflowuniverse/docusaurus_template.git')!
	mut template_path := r.patho()!

	//always start from template first
	for item in ["src","static","cfg"]{
		mut aa:= template_path.dir_get(item)!
		aa.copy(dest:"${site.path_build.path}/${item}")!
	}

	for item in ['package.json', 'sidebars.ts', 'tsconfig.json','docusaurus.config.ts'] {
		mut aa:= template_path.file_get(item)!
		aa.copy(dest:"${site.path_build.path}/${item}")! //TODO: use normal os.copy
	}

	for item in ['.gitignore'] {
		mut aa:= template_path.file_get(item)!
		aa.copy(dest:"${site.path_src.path}/${item}")! //TODO: use normal os.copy
	}

	cfg := site.config

	develop := $tmpl('templates/develop.sh')
	build := $tmpl('templates/build.sh')
	build_dev := $tmpl('templates/build_dev.sh')

	mut develop_ := site.path_build.file_get_new("develop.sh")!
	develop_.template_write(develop,true)!
	develop_.chmod(0o700)!

	mut build_ := site.path_build.file_get_new("build.sh")!
	build_.template_write(build,true)!
	build_.chmod(0o700)!

	mut build_dev_ := site.path_build.file_get_new("build_dev.sh")!
	build_dev_.template_write(build_dev,true)!
	build_dev_.chmod(0o700)!

	mut develop2_ := site.path_src.file_get_new("develop.sh")!
	develop2_.template_write(develop,true)!
	develop2_.chmod(0o700)!

	mut build2_ := site.path_src.file_get_new("build.sh")!
	build2_.template_write(build,true)!
	build2_.chmod(0o700)!

	mut build_dev2_ := site.path_src.file_get_new("build_dev.sh")!
	build_dev2_.template_write(build_dev,true)!
	build_dev2_.chmod(0o700)!	



}

