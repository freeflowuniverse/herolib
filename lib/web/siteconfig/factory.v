module siteconfig
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.core.texttools

__global (
	siteconfigs map[string]&SiteConfig
	siteconfigs_current string
)

@[params]
pub struct SiteConfigArgsGet {
pub mut:
	name          string
	path 		string
}

// new creates a new siteconfig and stores it in global map
pub fn new(args_ SiteConfigArgsGet) !&SiteConfig {
	mut args := args_
	if args.path != '' {
		if args.name != '' {
			return error('can not set name and path at the same time')
		}
		mut plbook := playbook.new(path: args.path)!
		// println('playbook: ${plbook} \nfor ${args.path}')
		play(plbook:plbook)!
	}
	mut i:=get(siteconfigs_current) or { panic(err) }
	
	args.name = texttools.name_fix(args.name)
	if args.name == '' {
		args.name = siteconfigs_current
	}		
	mut sc:=get(args.name)!
	return sc
}

// tree_get gets siteconfig from global map
pub fn get(name string) !&SiteConfig {
	if name in siteconfigs {
		return siteconfigs[name] or { return error('SiteConfig ${name} not found') }
	}
	return error("can't get siteconfig:'${name}'")
}

// tree_set stores siteconfig in global map
pub fn set(siteconfig SiteConfig) {
	siteconfigs[siteconfig.name] = &siteconfig
	siteconfigs_current = siteconfig.name
}
