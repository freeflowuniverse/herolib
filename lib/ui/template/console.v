module template

import freeflowuniverse.herolib.ui.console

pub fn clear() {
	console.print_debug('\033[2J')
}
