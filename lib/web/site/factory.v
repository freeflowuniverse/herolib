module site
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.core.texttools

__global (
	doctrees shared map[string]&SiteConfig
)

@[params]
pub struct SiteConfigArgsGet {
pub mut:
	name          string = 'default'
	path 		string
}

// new creates a new siteconfig and stores it in global map
pub fn new(args_ SiteConfigArgsGet) !&SiteConfig {
	mut args := args_
	args.name = texttools.name_fix(args.name)
	mut t := SiteConfig{
		name:          args.name
	}
	set(t)
	if args.path != '' {
		mut plbook := playbook.new(path: args.path)!
		play(plbook:plbook)!
	}
	return &t
}

// tree_get gets siteconfig from global map
pub fn get(name string) !&SiteConfig {
	rlock doctrees {
		if name in doctrees {
			return doctrees[name] or { return error('SiteConfig ${name} not found') }
		}
	}
	return error("can't get siteconfig:'${name}'")
}

// tree_set stores siteconfig in global map
pub fn set(siteconfig SiteConfig) {
	lock doctrees {
		doctrees[siteconfig.name] = &siteconfig
	}
}
