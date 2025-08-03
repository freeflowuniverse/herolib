module playcmds

import freeflowuniverse.herolib.core.playbook { PlayBook }
// import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.web.docusaurus

fn play(mut plbook PlayBook) ! {
	// Use the new docusaurus.play() function which handles the new API structure
	docusaurus.play(mut plbook)!
}
