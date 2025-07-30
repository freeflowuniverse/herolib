module site

import freeflowuniverse.herolib.core.texttools

__global (
	websites  map[string]&Site
)

@[params]
pub struct FactoryArgs {
pub mut:
	name string = "default"
}

pub fn new(args FactoryArgs) !&Site {
	name := texttools.name_fix(args.name)
	websites[name] = &Site{
		siteconfig: SiteConfig{
			name: name
		}
	}
	return get(name:name)!
}

pub fn get(args FactoryArgs) !&Site {
	name := texttools.name_fix(args.name)
	mut sc := websites[name] or {
		return error('siteconfig with name "${name}" does not exist')
	}
	return sc
}

pub fn default() !&Site {
	if websites.len == 0 {
		return new(name:'default')!
	}
	return get()!
}
