module docusaurus

import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.web.doctreeclient
import freeflowuniverse.herolib.web.site { Page, Section, Site }
import freeflowuniverse.herolib.data.markdown.tools as markdowntools
// import freeflowuniverse.herolib.ui.console

// THIS CODE GENERATES A DOCUSAURUS SITE FROM A DOCTREECLIENT AND SITE DEFINITION

struct SiteGenerator {
mut:
	siteconfig_name string
	path            pathlib.Path
	client          &doctreeclient.DocTreeClient
	flat            bool // if flat then won't use sitenames as subdir's
	site            Site
}

@[params]
struct SiteGeneratorArgs {
mut:
	path string
	flat bool // if flat then won't use sitenames as subdir's
	site Site
}

// new creates a new siteconfig and stores it in redis, or gets an existing one
fn generate(args SiteGeneratorArgs) ! {
	mut path := args.path
	if args.path == '' {
		return error('Path must be provided to generate site')
	}
	mut gen := SiteGenerator{
		path:   pathlib.get_dir(path: path, create: true)!
		client: doctreeclient.new()!
		flat:   args.flat
		site:   args.site
	}

	for section in gen.site.sections {
		gen.section_generate(section)!
	}

	for page in gen.site.pages {
		gen.page_generate(page)!
	}
}

fn (mut mysite SiteGenerator) page_generate(args_ Page) ! {
	mut args := args_

	mut content := ['---']

	mut parts := args.src.split(':')
	if parts.len != 2 {
		return error("Invalid src format for page '${args.src}', expected format: collection:page_name")
	}
	collection_name := parts[0]
	page_name := parts[1]

	mut page_content := mysite.client.get_page_content(collection_name, page_name) or {
		return error("Couldn't find page '${page_name}' in collection '${collection_name}' using doctreeclient. Available pages:\n${mysite.client.list_markdown()!}\nError: ${err}")
	}

	if args.description.len == 0 {
		descnew := markdowntools.extract_title(page_content)
		if descnew != '' {
			args.description = descnew
		} else {
			args.description = page_name
		}
	}

	if args.title.len == 0 {
		descnew := markdowntools.extract_title(page_content)
		if descnew != '' {
			args.title = descnew
		} else {
			args.title = page_name
		}
	}
	content << "title: '${args.title}'"

	if args.description.len > 0 {
		content << "description: '${args.description}'"
	}

	if args.slug.len > 0 {
		content << "slug: '${args.slug}'"
	}

	if args.hide_title {
		content << 'hide_title: ${args.hide_title}'
	}

	if args.draft {
		content << 'draft: ${args.draft}'
	}

	if args.position > 0 {
		content << 'sidebar_position: ${args.position}'
	}

	content << '---'

	mut c := content.join('\n')

	if args.title_nr > 0 {
		// Set the title number in the page content
		page_content = markdowntools.set_titles(page_content, args.title_nr)
	}

	c += '\n${page_content}\n'

	if args.path.ends_with('/') {
		// means is dir
		args.path += page_name
	}

	if !args.path.ends_with('.md') {
		args.path += '.md'
	}

	mut pagepath := '${mysite.path.path}/${args.path}'
	mut pagefile := pathlib.get_file(path: pagepath, create: true)!

	pagefile.write(c)!

	// console.print_debug("Copy images in collection '${collection_name}' to ${pagefile.path_dir()}")

	mysite.client.copy_images(collection_name, page_name, pagefile.path_dir()) or {
		return error("Couldn't copy images for '${page_name}' in collection '${collection_name}' using doctreeclient. Available pages:\n${mysite.client.list_markdown()!}\nError: ${err}")
	}
}

fn (mut mysite SiteGenerator) section_generate(args_ Section) ! {
	mut args := args_

	mut c := '{
    "label": "${args.label}",
    "position": ${args.position},
    "link": {
      "type": "generated-index"
    }
  }'

	mut category_path := '${mysite.path.path}/${args.path}/_category_.json'
	mut catfile := pathlib.get_file(path: category_path, create: true)!

	catfile.write(c)!
}
