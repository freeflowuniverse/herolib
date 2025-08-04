module playcmds

// import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.core.playbook { PlayBook }
import freeflowuniverse.herolib.data.doctree
import freeflowuniverse.herolib.biz.bizmodel
import freeflowuniverse.herolib.web.docusaurus
// import freeflowuniverse.herolib.hero.publishing
// import freeflowuniverse.herolib.threefold.grid4.gridsimulator
// import freeflowuniverse.herolib.installers.sysadmintools.daguserver
// import freeflowuniverse.herolib.threefold.grid4.farmingsimulator
// import freeflowuniverse.herolib.web.components.slides
// import freeflowuniverse.herolib.installers.base as base_install
// import freeflowuniverse.herolib.installers.infra.coredns
// import freeflowuniverse.herolib.virt.hetzner
// import freeflowuniverse.herolib.clients.b2

@[params]
pub struct PlayArgs {
pub mut:
	heroscript      string
	heroscript_path string
	plbook          ?PlayBook
	reset           bool
}

pub fn run(args_ PlayArgs) ! {
	mut args := args_

	mut plbook := args.plbook or {
		playbook.new(text: args.heroscript, path: args.heroscript_path)!
	}

	play_core(mut plbook)!
	play_git(mut plbook)!

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
	bizmodel.play(mut plbook)!
	doctree.play(mut plbook)!
	docusaurus.play(mut plbook)!

	// slides.play(mut plbook)!
	// base_install(play(mut plbook)!
	// coredns.play(mut plbook)!

	// plbook.empty_check()!
}
