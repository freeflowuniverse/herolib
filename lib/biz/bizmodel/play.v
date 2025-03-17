module bizmodel

import arrays
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.core.playbook { PlayBook, Action }
import freeflowuniverse.herolib.ui.console
// import freeflowuniverse.herolib.core.texttools
// import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.biz.spreadsheet

const action_priorities = {
	0: ['revenue_define', 'costcenter_define', 'funding_define']
	1: ['cost_define', 'department_define', 'employee_define']
	2: ['sheet_wiki', 'graph_bar_row', 'graph_pie_row', 'graph_line_row', 'row_overview']
}

pub fn play(mut plbook PlayBook) ! {
	// group actions by which bizmodel they belong to
	actions_by_biz := arrays.group_by[string, &Action](
		plbook.actions_find(actor: 'bizmodel')!, 
		fn (a &Action) string {
			return a.params.get('bizname') or {'default'}
		}
	)

	// play actions for each biz in playbook
	for biz, actions in actions_by_biz {
		mut model := getset(biz)!
		model.play(mut plbook)!
	}
}

pub fn (mut m BizModel) play(mut plbook PlayBook) ! {
	mut actions := plbook.actions_find(actor: 'bizmodel')!


	for action in actions.filter(it.name in action_priorities[0]) {
		console.print_debug(action)
		m.act(*action)!
	}

	m.cost_total()!
	m.revenue_total()!
	m.funding_total()!

	for action in actions.filter(it.name in action_priorities[1]) {
		m.act(*action)!
	}

	for action in actions.filter(it.name in action_priorities[2]) {
		m.act(*action)!
	}
}