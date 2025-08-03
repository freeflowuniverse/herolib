module docusaurus

import os
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.web.site
import freeflowuniverse.herolib.develop.gittools
import freeflowuniverse.herolib.osal.core as osal
import freeflowuniverse.herolib.installers.web.bun

__global (
	docusaurus_sites map[string]&DocSite
)

@[params]
pub struct AddArgs {
pub:
    site &site.Site
    path_src string
    path_build string
    path_publish string
    install bool
    reset bool
    template_update bool
}

pub fn add(args AddArgs) !&DocSite {
    site_name := texttools.name_fix(args.site.siteconfig.name)

    if site_name in docusaurus_sites {
        console.print_debug('Docusaurus site ${site_name} already exists, returning existing.')
        return docusaurus_sites[site_name]
    }

    console.print_debug('Adding docusaurus site ${site_name}')

    mut path_build_ := args.path_build
    if path_build_ == '' {
        path_build_ = '${os.home_dir()}/hero/var/docusaurus/build/${site_name}'
    }
    mut path_publish_ := args.path_publish
    if path_publish_ == '' {
        path_publish_ = '${os.home_dir()}/hero/var/docusaurus/publish/${site_name}'
    }

    // Install template if required
    install(path_build_, TemplateInstallArgs{
        install: args.install
        reset: args.reset
        template_update: args.template_update
    })!

    // Create the DocSite instance
    mut dsite := &DocSite{
        name:         site_name
        path_src:     pathlib.get_dir(path: args.path_src, create: false)!
        path_publish: pathlib.get_dir(path: path_publish_, create: true)!
        path_build:   pathlib.get_dir(path: path_build_, create: true)!
        config:       new_configuration(args.site.siteconfig)!
        site:         args.site
    }

    docusaurus_sites[site_name] = dsite
    return dsite
}

pub fn get(name_ string) !&DocSite {
    name := texttools.name_fix(name_)
    return docusaurus_sites[name] or {
        return error('docusaurus site with name "${name}" does not exist')
    }
}

@[params]
struct TemplateInstallArgs {
mut:
	install         bool
	reset           bool
	template_update bool
}

// copy template in build location
pub fn install(path_build_path string, args_ TemplateInstallArgs) ! {
	mut gs := gittools.new()!
	mut args := args_

	if args.reset {
		osal.rm(path_build_path)!
		osal.dir_ensure(path_build_path)!
	}

	template_path := gs.get_path(
		pull:  args.template_update
		reset: args.reset // Changed args.delete to args.reset
		url:   'https://github.com/freeflowuniverse/docusaurus_template/src/branch/main/template'
	)!

	mut template_path0 := pathlib.get_dir(path: template_path, create: false)!

	template_path0.copy(dest: path_build_path, delete: args.reset)! // Changed args.delete to args.reset

	if !os.exists('${path_build_path}/node_modules') {
		args.install = true
	}

	if args.install {
		// install bun
		mut installer := bun.get()!
		installer.install()!
		osal.exec(
			// always stay in the context of the build directory
			cmd: '
				${osal.profile_path_source_and()!} 
				export PATH=${path_build_path}/node_modules/.bin::${os.home_dir()}/.bun/bin/:\$PATH
				cd ${path_build_path}
				bun install
			'
		)!
	}
}