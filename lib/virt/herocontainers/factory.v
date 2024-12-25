module herocontainers

import freeflowuniverse.herolib.installers.virt.podman as podman_installer
import freeflowuniverse.herolib.installers.virt.buildah as buildah_installer
import freeflowuniverse.herolib.installers.lang.herolib
import freeflowuniverse.herolib.osal

@[params]
pub struct NewArgs {
pub mut:
	install     bool = true
	reset       bool
	herocompile bool
}

pub fn new(args_ NewArgs) !CEngine {
	mut args := args_

	if !osal.is_linux() {
		return error('only linux supported as host for now')
	}

	if args.install {
		mut podman_installer0 := podman_installer.get()!
		mut buildah_installer0 := buildah_installer.get()!
		podman_installer0.install()!
		buildah_installer0.install()!
	}

	if args.herocompile {
		herolib.check()! // will check if install, if not will do
		herolib.hero_compile(reset: true)!
	}

	mut engine := CEngine{}
	engine.init()!
	if args.reset {
		engine.reset_all()!
	}

	return engine
}
