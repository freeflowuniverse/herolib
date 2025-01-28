module blockchain

import freeflowuniverse.herolib.core.playbook { Actions }
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.data.paramsparser

// TODO: not implemented,

fn (mut c Controller) actions(actions_ Actions) ! {
	mut actions2 := actions_.filtersort(actor: '???')!
	for action in actions2 {
		if action.name == '???' {
		}
	}
}
