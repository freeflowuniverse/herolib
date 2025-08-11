module docusaurus

import os
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.develop.gittools
import freeflowuniverse.herolib.web.site
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.osal.core as osal
import freeflowuniverse.herolib.core.playbook
// import freeflowuniverse.herolib.data.doctree

// Process playbook includes - extracted from playcmds.play_core to avoid circular imports
fn process_playbook_includes(mut plbook playbook.PlayBook) ! {
	// Track included paths to prevent infinite recursion
	mut included_paths := map[string]bool{}

	for action_ in plbook.find(filter: 'play.*')! {
		if action_.name == 'include' {
			mut action := *action_
			mut playrunpath := action.params.get_default('path', '')!
			if playrunpath.len == 0 {
				action.name = 'pull'
				playrunpath = gittools.get_repo_path(
					path:      action.params.get_default('path', '')!
					git_url:   action.params.get_default('git_url', '')!
					git_reset: action.params.get_default_false('git_reset')
					git_pull:  action.params.get_default_false('git_pull')
				)!
			}
			if playrunpath.len == 0 {
				return error("can't run a heroscript didn't find url or path.")
			}

			// Check for cycle detection
			if playrunpath in included_paths {
				continue
			}

			included_paths[playrunpath] = true
			plbook.add(path: playrunpath)!
		}
	}
}

// Central function to process site configuration from a path
// This is the single point of use for all site processing logic
// If sitename is empty, it will return the first available site
pub fn process_site_from_path(path string, sitename string) !&site.Site {
	// Create playbook from the config path and let it handle includes properly
	// This way !!play.include statements will be processed and imports will be included
	mut plbook := playbook.new(path: '${path}/cfg')!

	// Process includes first - this is crucial for getting the imported site.import actions
	process_playbook_includes(mut plbook)!

	site.play(mut plbook)!

	// Check what sites were created
	available_sites := site.list()

	if available_sites.len == 0 {
		return error('No sites were created from the configuration')
	}

	// Determine which site to return
	target_sitename := if sitename.len == 0 {
		available_sites[0] // Use the first (and likely only) site
	} else {
		sitename
	}

	mysite := site.get(name: target_sitename) or {
		return error('Failed to get site after playing playbook: ${target_sitename}. Available sites: ${available_sites}')
	}
	return mysite
}

@[params]
pub struct AddArgs {
pub mut:
	sitename     string // needs to exist in web.site module
	path         string // site of the docusaurus site with the config as is needed to populate the docusaurus site
	git_url      string
	git_reset    bool
	git_root     string
	git_pull     bool
	path_publish string
	play         bool = true
}

pub fn dsite_add(args_ AddArgs) !&DocSite {
	mut args := args_
	args.sitename = texttools.name_fix(args_.sitename)

	console.print_header('Add Docusaurus Site: ${args.sitename}')

	if args.sitename in docusaurus_sites {
		return error('Docusaurus site ${args.sitename} already exists, returning existing.')
	}

	mut path := gittools.path(
		path:       args.path
		git_url:    args.git_url
		git_reset:  args.git_reset
		git_root:   args.git_root
		git_pull:   args.git_pull
		currentdir: false
	)!
	args.path = path.path
	if !path.is_dir() {
		return error('path is not a directory')
	}

	if !os.exists('${args.path}/cfg') {
		return error('config directory for docusaurus does not exist in ${args.path}/cfg.\n${args}')
	}

	configpath := '${args.path}/cfg'
	if !os.exists(configpath) {
		return error("can't find config file for docusaurus in ${configpath}")
	}

	osal.rm('${args.path}/cfg/main.json')!
	osal.rm('${args.path}/cfg/footer.json')!
	osal.rm('${args.path}/cfg/navbar.json')!
	osal.rm('${args.path}/build.sh')!
	osal.rm('${args.path}/develop.sh')!
	osal.rm('${args.path}/sync.sh')!
	osal.rm('${args.path}/.DS_Store')!

	mut f := factory_get()!

	if args.path_publish == '' {
		args.path_publish = '${f.path_publish.path}/${args.sitename}'
	}

	path_build_ := '${f.path_build.path}/${args.sitename}'

	// get our website
	mut mysite := &site.Site{}
	if site.exists(name: args.sitename) {
		// Site already exists (likely processed by hero command), use existing site
		mysite = site.get(name: args.sitename)!
	} else {
		if !args.play {
			return error('Docusaurus site ${args.sitename} does not exist, please set play to true to create it.')
		}
		// Use the centralized site processing function
		mysite = process_site_from_path(args.path, args.sitename)!
	}

	// Create the DocSite instance
	mut dsite := &DocSite{
		name:         args.sitename
		path_src:     pathlib.get_dir(path: args.path, create: false)!
		path_publish: pathlib.get_dir(path: args.path_publish, create: true)!
		path_build:   pathlib.get_dir(path: path_build_, create: true)!
		config:       new_configuration(mysite.siteconfig)!
		website:      mysite
	}

	docusaurus_sites[args.sitename] = dsite
	return dsite
}
