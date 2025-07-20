module bizmodel

import arrays
import freeflowuniverse.herolib.core.playbook { PlayBook, Action }
import freeflowuniverse.herolib.ui.console

const action_priorities = {
	0: ['department_define', 'costcenter_define']
	1: ['revenue_define','funding_define','cost_define']
	2: ['employee_define']
	3: ['sheet_wiki', 'graph_bar_row', 'graph_pie_row', 'graph_line_row', 'row_overview']
}

@[params]
pub struct PlayArgs {
pub mut:
	heroscript      string
	heroscript_path string
	plbook          ?PlayBook
	reset           bool
}

pub fn play(args_ PlayArgs) ! {
	mut args := args_
	mut plbook := args.plbook or {
		playbook.new(text: args.heroscript, path: args.heroscript_path)!
	}
	// group actions by which bizmodel they belong to
	actions_by_biz := arrays.group_by[string, &Action](plbook.actions_find(actor: 'bizmodel')!,
		fn (a &Action) string {
		return a.params.get('bizname') or { 'default' }
	})

	// play actions for each biz in playbook
	for biz, actions in actions_by_biz {
		mut model := getset(biz)!
		model.play(mut plbook)!
	}
}

pub fn (mut m BizModel) play(mut plbook PlayBook) ! {
	mut actions := plbook.actions_find(actor: 'bizmodel')!

	for action in actions.filter(it.name in action_priorities[0]) {m.act(*action)!}
	for action in actions.filter(it.name in action_priorities[1]) {m.act(*action)!}

	m.cost_total()!
	m.revenue_total()!
	m.funding_total()!

	for action in actions.filter(it.name in action_priorities[2]) {m.act(*action)!}
	for action in actions.filter(it.name in action_priorities[3]) {m.act(*action)!}
}
