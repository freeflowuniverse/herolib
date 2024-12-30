module bizmodel

import freeflowuniverse.herolib.core.playbook { Action }
import freeflowuniverse.herolib.core.texttools

fn (mut m BizModel) costcenter_define_action(action Action) ! {
	mut name := action.params.get_default('name', '')!
	mut descr := action.params.get_default('descr', '')!
	if descr.len == 0 {
		descr = action.params.get('description')!
	}
	mut department := action.params.get_default('department', '')!
	if name.len == 0 {
		// make name ourselves
		name = texttools.name_fix(descr) // TODO:limit len
	}
	mut cc := Costcenter{
		name:        name
		description: descr
		department:  department
	}
	m.costcenters[name] = &cc
}
