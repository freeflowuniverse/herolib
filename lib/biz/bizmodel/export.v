module bizmodel

import freeflowuniverse.herolib.web.docusaurus

pub struct Export {
pub:
	build_path string
	format ExportFormat
}

pub enum ExportFormat {
	mdbook
	docusaurus
}

pub fn (b BizModel) export(export Export) ! {
	match export.format {
		.docusaurus {b.export_docusaurus(export)}
		.mdbook {panic('MDBook export not fully implemented')}
	}
}

pub fn (b BizModel) export_docusaurus(export Export) ! {
	factory := docusaurus.new(
		build_path: export.build_path
	)

	// b.export_summary()
	// b.export_business_description()
	// b.export_market_analysis()
	// b.export_business_model()
	b.export_revenue_model(export)
	b.export_cost_structure(export)
	b.export_operational_plan(export)!
	b.export_fundraising(export)
}

pub fn (b BizModel) export_operational_plan(export Export) ! {
	mut hr_page := pathlib.get_file(path: '${export.build_path}/human_resources.md')
	hr_page.template_write()

	for employee in b.employees {
		mut employee_page := pathlib.get_file(path: '${export.build_path}/${texttools.snake_case(employee.name)}.md')!
		employee_page.template_write(employee.md)!
	}
}

pub fn (b BizModel) export_revenue_model(export Export) ! {
	mut overview_page := pathlib.get_file(path: '${export.build_path}/revenue_overview.md')
	overview_page.template_write()

	mut overview_page := pathlib.get_file(path: '${export.build_path}/revenue_overview.md')
	overview_page.template_write()

	for employee in b.employees {
		mut employee_page := pathlib.get_file(path: '${export.build_path}/${texttools.snake_case(employee.name)}.md')!
		employee_page.template_write(employee.md)!
	}
}