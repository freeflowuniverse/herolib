module bizmodel

import os
import freeflowuniverse.herolib.web.docusaurus
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.core.pathlib

pub struct Export {
pub:
	path string
	overwrite bool
	format ExportFormat
}

pub enum ExportFormat {
	docusaurus
	mdbook
}

pub struct Report {
pub:
	name string
	title string
	description string
	path string
	sections []ReportSection
}

pub enum ReportSection {
	revenue_model
	cost_structure
	human_resources
}

pub fn (b BizModel) new_report(report Report) !Report {
	name := if report.name != '' {report.name} else { texttools.snake_case(report.title) }
	path := pathlib.get_dir(
		path: os.join_path(os.home_dir(), '/hero/var/bizmodel/reports/${name}')
	)!
	return Report {
		...report,
		name: name
		path: path.path
	}
	// b.export_summary()
	// b.export_business_description()
	// b.export_market_analysis()
	// b.export_business_model()
	// b.export_revenue_model(export)!
	// b.export_cost_structure(export)
	// b.export_operational_plan(export)!
	// b.export_fundraising(export)
}

pub fn (r Report) export(export Export) ! {
	match export.format {
		.docusaurus {
			mut factory := docusaurus.new()!
			mut site := factory.get(
				name: r.name
				path: r.path
				publish_path: export.path
				config: docusaurus.Config {} //TODO: is this needed
			)!
			site.build()!
		}
		.mdbook {panic('MDBook export not fully implemented')}
	}
}

pub fn (b BizModel) export_operational_plan(export Export) ! {
	mut hr_page := pathlib.get_file(path: '${export.path}/human_resources.md')!
	hr_page.template_write('./templates/human_resources.md', export.overwrite)!

	for key, employee in b.employees {
		mut employee_page := pathlib.get_file(path: '${export.path}/${texttools.snake_case(employee.name)}.md')!
		employee_page.template_write('./templates/employee.md', export.overwrite)!
	}
}

pub fn (b BizModel) export_revenue_model(export Export) ! {
	println('begin')
	mut overview_page := pathlib.get_file(path: '${export.path}/revenue_overview.md')!
	overview_page.template_write('./templates/overview.md', export.overwrite)!

	for key, product in b.products {
		mut product_page := pathlib.get_file(path: '${export.path}/${texttools.snake_case(product.name)}.md')!
		product_page.template_write('./templates/product.md', export.overwrite)!
	}
}