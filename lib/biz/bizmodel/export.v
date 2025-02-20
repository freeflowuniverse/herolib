module bizmodel

import os
import freeflowuniverse.herolib.web.docusaurus
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.core.pathlib

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
		empty: true
	)!

	b.write_introduction(path.path)!
	b.write_operational_plan(path.path)!

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

pub fn (r Report) export(export Export) ! {
	match export.format {
		.docusaurus {
			mut dir := pathlib.get_dir(path: r.path)!
			dir.copy(dest: '${export.path}/docs', delete: true)!
			mut factory := docusaurus.new()!
			mut site := factory.get(
				name: r.name
				path: export.path
				publish_path: export.path
				init: true
				config: docusaurus.Config {
					main: docusaurus.Main {
						url_home: 'docs/introduction'
					}
				} //TODO: is this needed
			)!
			site.generate()!
		}
		.mdbook {panic('MDBook export not fully implemented')}
	}
}

pub fn (model BizModel) write_introduction(path string) ! {
	mut index_page := pathlib.get_file(path: '${path}/introduction.md')!
	// mut tmpl_index := $tmpl('templates/index.md')
	index_page.template_write($tmpl('templates/introduction.md'), true)!
}

pub fn (b BizModel) write_operational_plan(path string) ! {
	mut dir := pathlib.get_dir(path: '${path}/operational_plan')!
	mut hr_page := pathlib.get_file(path: '${dir.path}/human_resources.md')!
	hr_page.template_write('./templates/human_resources.md', true)!

	for key, employee in b.employees {
		mut employee_page := pathlib.get_file(path: '${dir.path}/${texttools.snake_case(employee.name)}.md')!
		employee_page.template_write('./templates/employee.md', true)!
	}
}

pub fn (b BizModel) export_revenue_model(export Export) ! {
	mut overview_page := pathlib.get_file(path: '${export.path}/revenue_overview.md')!
	overview_page.template_write('./templates/overview.md', export.overwrite)!

	for key, product in b.products {
		mut product_page := pathlib.get_file(path: '${export.path}/${texttools.snake_case(product.name)}.md')!
		product_page.template_write('./templates/product.md', export.overwrite)!
	}
}