module sitegen

import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.web.doctreeclient
import freeflowuniverse.herolib.ui.console
pub struct Site {
pub mut:
	name string
	path pathlib.Path
	client &doctreeclient.DocTreeClient
}


@[params]
pub struct Page {
pub mut:
	title string
	description 	string
	draft bool
	position int
	hide_title bool
	src 	string  @[required]
	path string @[required]
}

pub fn (mut site Site) page_add(args_ Page) ! {
	mut args:= args_

	mut content:=["---"]

	if ! args.path.ends_with(".md") {
		args.path += ".md"
	}

	pagename := args.path.split('/').last()

	if args.title.len==0 {
		args.title = pagename
	}
	content<< "title: '${args.title}'"

	if args.description.len>0 {
		content<< "description: '${args.description}'"
	}

	if args.hide_title {
		content<< "hide_title: ${args.hide_title}"
	}

	if args.draft{
		content<< "draft: ${args.draft}"
	}

	if args.position>0{
		content<< "sidebar_position: ${args.position}"
	}
	
	content<< "---"

	mut c:=content.join("\n")

	mut parts := args.src.split(':')
	if parts.len != 2 {
		return error("Invalid src format for page '${args.src}', expected format: collection:page_name")
	}
	collection_name := parts[0]
	page_name := parts[1]

	mut page_content := site.client.get_page_content(collection_name, page_name) or {
		return error("Couldn't find page '${page_name}' in collection '${collection_name}' using doctreeclient. Available pages:\n${site.client.list_markdown()!}\nError: ${err}")
	}

	c+="\n${page_content}\n"

	mut pagepath:= "${site.path.path}/${args.path}"
	mut pagefile:= pathlib.get_file(path:pagepath,create:true)!

   console.print_debug("Writing page '${pagepath}'")

	pagefile.write(c)!




}
