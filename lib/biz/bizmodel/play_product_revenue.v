module bizmodel

import freeflowuniverse.herolib.core.playbook { Action }
import freeflowuniverse.herolib.core.texttools

// see lib/biz/bizmodel/docs/revenue.md
fn (mut m BizModel) revenue_action(action Action) !Action {

	mut r := get_action_descr(action)!

	mut product := Product{
		name:        r.name
		title:       action.params.get_default('title', r.name)!
		description: r.description
	}
	m.products[r.name] = &product

	mut nr_months_recurring := action.params.get_int_default('nr_months_recurring', 60)!
	product.nr_months_recurring = nr_months_recurring

	mut revenue := m.sheet.row_new(
		name:        '${r.name}_revenue'
		growth:      action.params.get_default('revenue', '0:0')!
		tags:        'rev rev:${r.name} name:${r.name}'
		descr:       'Revenue items for ${r.name}'
		extrapolate: action.params.get_default_false('extrapolate')
	)!

	mut cogs_param := m.sheet.row_new(
		name:        '${r.name}_cogs_param'
		growth:      action.params.get_default('cogs', '0:0')!
		tags:        'name:${r.name}'
		descr:       'COGS for ${r.name}'
		extrapolate: action.params.get_default_false('extrapolate')
	)!

	mut cogs_perc := m.sheet.row_new(
		name:          '${r.name}_cogs_perc'
		growth:        action.params.get_default('cogs_percent', '0')!
		tags:          'name:${r.name}'
		descr:         'COGS as percent of revenue for ${r.name}'
		aggregatetype: .avg
	)!

	// cogs as percentage of revenue
	mut cogs_percent_temp := cogs_perc.action(
		action: .multiply
		rows:   [revenue]
		name:   '${r.name}_cogs_percent_temp'
	)!
	cogs_percent_temp.delay(action.params.get_int_default('cogs_delay', 0)!)!

	cogs_percent_temp.delete()

	mut cogs := cogs_param.action(
		action: .add
		rows:   [cogs_percent_temp]
		name:   '${r.name}_cogs'
		tags:   'cogs  cogs:${r.name} name:${r.name}'
	)!

	if revenue.max() > 0 {
		product.has_revenue = true
	}

	return action
}