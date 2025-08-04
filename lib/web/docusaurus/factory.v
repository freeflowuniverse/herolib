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
pub mut:
    path_build string
    path_publish string
    install bool
    reset bool
    template_update bool
}

pub fn factory_get(args_ DocSiteFactoryArgs) !DocSiteFactory {
    mut args:= args_
    mut f:= docusaurus_factory or {        
        mut factory:=factory_set(args)!
        factory
    }
	return f
}

pub fn factory_set(args_ DocSiteFactoryArgs) !DocSiteFactory {
    mut args:= args_
    if args.path_build == '' {
        args.path_build = '${os.home_dir()}/hero/var/docusaurus/build'
    }
    if args.path_publish == '' {
        args.path_publish = '${os.home_dir()}/hero/var/docusaurus/publish'
    }
    mut factory := DocSiteFactory{
        path_publish: pathlib.get_dir(path:args.path_publish,create:true)!
        path_build: pathlib.get_dir(path:args.path_build,create:true)!
    }

    if !os.exists('${args.path_build}/node_modules') {
        args.install = true
    }

    if args.install {
        factory.install(args.reset, args.template_update)!
    }
	return factory
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

