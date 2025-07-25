module playcmds
import freeflowuniverse.herolib.core.playbook

@[params]
pub struct PlayArgs {
pub mut:
	heroscript      string
	heroscript_path string
	plbook          ?playbook.PlayBook
	reset           bool
}
