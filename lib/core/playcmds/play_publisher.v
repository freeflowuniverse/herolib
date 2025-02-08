module playcmds

import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.hero.publishing

pub fn play_publisher(mut plbook playbook.PlayBook) ! {
	publishing.play(mut plbook)!
}
