module bizmodel

import freeflowuniverse.herolib.core.playbook { Action }

// revenue_total calculates and aggregates the total revenue and cost of goods sold (COGS) for the business model
fn (mut sim BizModel) revenue_total() ! {

	mut sheet:= sim.sheet

	mut revenue_total := sheet.group2row(name:"revenue_total", include:['rev'], tags:"total", descr:'total revenue.')!
	mut cogs_total := sheet.group2row(name:"cogs_total", include:['cogs'], tags:"total", descr:'total cogs.')!


}


fn (mut sim BizModel) revenue_name_total(action Action) !Action {

	mut r := get_action_descr(action)!
	mut product := sim.products[r.name]

	mut sheet:= sim.sheet

	mut revenue_total := sheet.group2row(name:"${r.name}_revenue_total", include:['rev:${r.name}'], tags:"name:${r.name}", descr:'total revenue for ${r.name}.')!
	mut cogs_total := sheet.group2row(name:"${r.name}_cogs_total", include:['cogs:${r.name}'], tags:"name:${r.name}", descr:'total cogs for ${r.name}.')!

	return action
}
