module docusaurus

import os
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.develop.gittools
import freeflowuniverse.herolib.osal.core as osal
import freeflowuniverse.herolib.installers.web.bun

__global (
	docusaurus_sites map[string]&DocSite
    docusaurus_factory ?DocSiteFactory
)

pub struct DocSiteFactory{
pub mut:
	path_publish pathlib.Path
	path_build pathlib.Path
}

@[params]
pub struct DocSiteFactoryArgs {
pub:
    path_build string
    path_publish string
    install bool
    reset bool
    template_update bool
}

pub fn factory_get(args_ DocSiteFactoryArgs) !DocSiteFactory {
    mut args:= args_
    mut f:= docusaurus_factory or {
        if args.path_build == '' {
            args.path_build = '${os.home_dir()}/hero/var/docusaurus/build/${site_name}'
        }
        if args.path_publish == '' {
            args.path_publish = '${os.home_dir()}/hero/var/docusaurus/publish/${site_name}'
        }
        mut factory := DocSiteFactory{
            path_publish: pathlib.get_dir(args.path_publish)!
            path_build: pathlib.get_dir(args.path_build)!
        }

        if !os.exists('${f.path_build.path}/node_modules') {
            args.install = true
        }

        if args.install {
            factory.install(args.reset, args.template_update)!
        }
        factory
    }
	return f
}

pub fn dsite_get(name_ string) !&DocSite {
    name := texttools.name_fix(name_)
    return docusaurus_sites[name] or {
        return error('docusaurus site with name "${name}" does not exist')
    }
}

pub fn dsite_exists(name_ string) !bool {
    name := texttools.name_fix(name_)
    d := docusaurus_sites[name] or {
        return false
    }
    return true
}

