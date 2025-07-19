module sitegen

import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.web.doctreeclient
import os

pub struct SiteFactory {
pub mut:
	sites map[string]&Site
	path  pathlib.Path
	client &doctreeclient.DocTreeClient
	flat bool // if flat then won't use sitenames as subdir's
}

@[params]
pub struct SiteFactoryArgs {
pub mut:
	path string
	flat bool // if flat then won't use sitenames as subdir's
}



// new creates a new siteconfig and stores it in redis, or gets an existing one
pub fn new(args SiteFactoryArgs) !SiteFactory {
	mut path := args.path
	if path == '' {
		path = '${os.home_dir()}/hero/var/sitegen'
	}
	mut factory := SiteFactory{
		path: pathlib.get_dir(path: path, create: true)!
		client: doctreeclient.new()!
		flat:args.flat
	}
	return factory
}


pub fn (mut f SiteFactory) site_get(name string) !&Site {



	mut s := f.sites[name] or { 
		mut mypath:=f.path
		if !f.flat {
			mypath=f.path.dir_get_new(name)!
		}
		mut mysite:=&Site{
			path: mypath
			name: name
			client: f.client
		}
		mysite
	}
	return s
}
