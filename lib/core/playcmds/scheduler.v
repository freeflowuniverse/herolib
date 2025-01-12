module playcmds

import freeflowuniverse.herolib.installers.sysadmintools.daguserver

pub fn scheduler(heroscript string) ! {
	daguserver.play(
		heroscript: heroscript
	)!
}
