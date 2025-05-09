module playcmds

import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.core.playbook
// import freeflowuniverse.herolib.virt.hetzner
// import freeflowuniverse.herolib.clients.b2
import freeflowuniverse.herolib.biz.bizmodel
// import freeflowuniverse.herolib.hero.publishing
import freeflowuniverse.herolib.threefold.grid4.gridsimulator
// import freeflowuniverse.herolib.installers.sysadmintools.daguserver
import freeflowuniverse.herolib.threefold.grid4.farmingsimulator
// import freeflowuniverse.herolib.web.components.slides
// import freeflowuniverse.herolib.installers.base as base_install
// import freeflowuniverse.herolib.installers.infra.coredns

pub fn run(mut plbook playbook.PlayBook, dagu bool) ! {
	if dagu {
		hscript := plbook.str()
		scheduler(hscript)!
	}

	play_core(mut plbook)!
	play_ssh(mut plbook)!
	play_git(mut plbook)!
	// play_publisher(mut plbook)!
	// play_zola(mut plbook)!
	// play_caddy(mut plbook)!
	// play_juggler(mut plbook)!
	// play_luadns(mut plbook)!
	// hetzner.heroplay(mut plbook)!
	// b2.heroplay(mut plbook)!

	farmingsimulator.play(mut plbook)!
	gridsimulator.play(mut plbook)!
	bizmodel.play(mut plbook)!
	// slides.play(mut plbook)!
	// base_install(play(mut plbook)!
	// coredns.play(mut plbook)!

	// plbook.empty_check()!

	console.print_header('Actions concluded succesfully.')
}
