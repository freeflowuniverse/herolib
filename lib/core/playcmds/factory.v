module playcmds

// import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.core.playbook { PlayBook }
import freeflowuniverse.herolib.data.doctree
import freeflowuniverse.herolib.biz.bizmodel
// import freeflowuniverse.herolib.hero.publishing
// import freeflowuniverse.herolib.threefold.grid4.gridsimulator
// import freeflowuniverse.herolib.installers.sysadmintools.daguserver
// import freeflowuniverse.herolib.threefold.grid4.farmingsimulator
// import freeflowuniverse.herolib.web.components.slides
// import freeflowuniverse.herolib.installers.base as base_install
// import freeflowuniverse.herolib.installers.infra.coredns
// import freeflowuniverse.herolib.virt.hetzner
// import freeflowuniverse.herolib.clients.b2


pub fn run(args_ PlayArgs) !PlayBook {

	mut args := args_

	mut plbook := args.plbook or {
		playbook.new(text: args.heroscript, path: args.heroscript_path)!
	}
	play_core(mut playbook)!
	play_git(mut playbook)!

	// play_ssh(mut plbook)!
	// play_publisher(mut plbook)!
	// play_zola(mut plbook)!
	// play_caddy(mut plbook)!
	// play_juggler(mut plbook)!
	// play_luadns(mut plbook)!
	// hetzner.heroplay(mut plbook)!
	// b2.heroplay(mut plbook)!

	// plbook = farmingsimulator.play(mut plbook)!
	// plbook = gridsimulator.play(mut plbook)!
	plbook = bizmodel.play(mut playbook)!
	plbook = doctree.play(mut playbook)!
	
	// slides.play(mut plbook)!
	// base_install(play(mut plbook)!
	// coredns.play(mut plbook)!

	// plbook.empty_check()!


	return plbook
}
