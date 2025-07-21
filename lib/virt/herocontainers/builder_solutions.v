module herocontainers

import freeflowuniverse.herolib.osal.core as osal
// import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.installers.lang.herolib
import freeflowuniverse.herolib.core.pathlib
import os
import json

// copies the hero from host into guest
pub fn (mut self Builder) install_zinit() ! {
	self.run(
		cmd: '
    	wget https://github.com/threefoldtech/zinit/releases/download/v0.2.5/zinit -O /sbin/zinit
    	chmod +x /sbin/zinit
		touch /etc/environment
		mkdir -p /etc/zinit/
		'
	)!

	self.set_entrypoint('/sbin/zinit init --container')!
}
