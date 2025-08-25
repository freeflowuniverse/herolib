module herocontainers

import freeflowuniverse.herolib.osal.core as osal { exec }
import time
import freeflowuniverse.herolib.virt.utils
import freeflowuniverse.herolib.ui.console
// TODO: needs to be implemented for buildah, is still code from docker

@[heap]
pub struct Image {
pub mut:
	repo    string
	id      string
	id_full string
	tag     string
	digest  string
	size    int // size in MB
	created time.Time
	engine  &PodmanFactory @[skip; str: skip]
}

// delete podman image
pub fn (mut image Image) delete(force bool) ! {
	mut forcestr := ''
	if force {
		forcestr = '-f'
	}
	exec(cmd: 'podman rmi ${image.id} ${forcestr}', stdout: false)!
}

// export podman image to tar.gz
pub fn (mut image Image) export(path string) !string {
	exec(cmd: 'podman save ${image.id} > ${path}', stdout: false)!
	return ''
}
