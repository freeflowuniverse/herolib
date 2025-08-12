module playcmds

import freeflowuniverse.herolib.core.playbook { PlayBook }
import freeflowuniverse.herolib.data.doctree
import freeflowuniverse.herolib.biz.bizmodel
import freeflowuniverse.herolib.web.site
import freeflowuniverse.herolib.web.docusaurus
import freeflowuniverse.herolib.clients.openai

// -------------------------------------------------------------------
// run – entry point for all HeroScript play‑commands
// -------------------------------------------------------------------

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

    // Core actions
    play_core(mut plbook)!
    // Git actions
    play_git(mut plbook)!

    // Business model (e.g. currency, bizmodel)
    bizmodel.play(mut plbook)!

    // OpenAI client
    openai.play(mut plbook)!

    // Website / docs
    site.play(mut plbook)!
    doctree.play(mut plbook)!
    docusaurus.play(mut plbook)!

    // Ensure we did not leave any actions un‑processed
    plbook.empty_check()!
}
