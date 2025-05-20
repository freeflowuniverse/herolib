module bizmodel

import os
import freeflowuniverse.herolib.web.docusaurus
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.core.pathlib

pub struct Report {
pub:
	name        string
	title       string
	description string
	path        string
	sections    []ReportSection
}

pub enum ReportSection {
	revenue_model
	cost_structure
	human_resources
}

pub fn (b BizModel) new_report(report Report) !Report {
	name := if report.name != '' { report.name } else { texttools.snake_case(report.title) }
	path := pathlib.get_dir(
		path:   os.join_path(os.home_dir(), '/hero/var/bizmodel/reports/${name}')
		create: true
		empty:  true
	)!

	b.write_introduction(path.path)!
	b.write_operational_plan(path.path)!
	b.write_revenue_model(path.path)!
	b.write_cost_structure(path.path)!

	return Report{
		...report
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
	path      string
	overwrite bool
	format    ExportFormat
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
				name:         r.name
				path:         export.path
				publish_path: export.path
				init:         true
				config:       docusaurus.Configuration{
					navbar: docusaurus.Navbar{
						title: 'Business Model'
						items: [
							docusaurus.NavbarItem{
								href:     'https://threefold.info/kristof/'
								label:    'ThreeFold Technology'
								position: 'right'
							},
							docusaurus.NavbarItem{
								href:     'https://threefold.io'
								label:    'Operational Plan'
								position: 'left'
							},
						]
					}
					main:   docusaurus.Main{
						url_home: 'docs/introduction'
					}
				} // TODO: is this needed
			)!
			site.generate()!
		}
		.mdbook {
			panic('MDBook export not fully implemented')
		}
	}
}

pub fn (model BizModel) write_introduction(path string) ! {
	mut index_page := pathlib.get_file(path: '${path}/introduction.md')!
	// mut tmpl_index := $tmpl('templates/index.md')
	index_page.template_write($tmpl('templates/introduction.md'), true)!
}

pub fn (model BizModel) write_operational_plan(path string) ! {
	mut dir := pathlib.get_dir(path: '${path}/operational_plan')!
	mut ops_page := pathlib.get_file(path: '${dir.path}/operational_plan.md')!
	ops_page.write('# Operational Plan')!

	mut hr_dir := pathlib.get_dir(path: '${dir.path}/human_resources')!
	mut hr_page := pathlib.get_file(path: '${hr_dir.path}/human_resources.md')!
	hr_page.template_write($tmpl('./templates/human_resources.md'), true)!

	for key, employee in model.employees {
		mut employee_page := pathlib.get_file(
			path: '${hr_dir.path}/${texttools.snake_case(employee.name)}.md'
		)!
		employee_cost_chart := model.sheet.line_chart(
			rowname: 'hr_cost_${employee.name}'
			unit:    .million
		)!.mdx()
		employee_page.template_write($tmpl('./templates/employee.md'), true)!
	}

	mut depts_dir := pathlib.get_dir(path: '${dir.path}/departments')!
	for key, department in model.departments {
		mut dept_page := pathlib.get_file(
			path: '${depts_dir.path}/${texttools.snake_case(department.name)}.md'
		)!
		// dept_cost_chart := model.sheet.line_chart(rowname:'hr_cost_${employee.name}', unit: .million)!.mdx()
		// println(employee_cost_chart)
		dept_page.template_write($tmpl('./templates/department.md'), true)!
	}
}

pub fn (model BizModel) write_revenue_model(path string) ! {
	mut dir := pathlib.get_dir(path: '${path}/revenue_model')!
	mut rm_page := pathlib.get_file(path: '${dir.path}/revenue_model.md')!
	rm_page.write('# Revenue Model')!

	mut products_dir := pathlib.get_dir(path: '${dir.path}/products')!
	mut products_page := pathlib.get_file(path: '${products_dir.path}/products.md')!
	products_page.template_write('# Products', true)!

	name1 := 'example'
	for key, product in model.products {
		mut product_page := pathlib.get_file(
			path: '${products_dir.path}/${texttools.snake_case(product.name)}.md'
		)!
		product_page.template_write($tmpl('./templates/product.md'), true)!
	}
}

pub fn (model BizModel) write_cost_structure(path string) ! {
	mut dir := pathlib.get_dir(path: '${path}/cost_structure')!
	mut cs_page := pathlib.get_file(path: '${dir.path}/cost_structure.md')!
	cs_page.write('# Cost Structure')!
}
