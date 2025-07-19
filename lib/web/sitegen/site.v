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
	title_nr int
}

pub fn (mut site Site) page_add(args_ Page) ! {
	mut args:= args_

	mut content:=["---"]

	mut parts := args.src.split(':')
	if parts.len != 2 {
		return error("Invalid src format for page '${args.src}', expected format: collection:page_name")
	}
	collection_name := parts[0]
	page_name := parts[1]

	mut page_content := site.client.get_page_content(collection_name, page_name) or {
		return error("Couldn't find page '${page_name}' in collection '${collection_name}' using doctreeclient. Available pages:\n${site.client.list_markdown()!}\nError: ${err}")
	}

	if args.description.len==0 {
		descnew:=doctreeclient.extract_title(page_content)
		if descnew!=""{
			args.description = descnew
		}else{
			args.description = page_name
		}
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

	if args.title_nr > 0 {
		// Set the title number in the page content
		page_content = doctreeclient.set_titles(page_content, args.title_nr)
	}

	c+="\n${page_content}\n"

	if args.path.ends_with("/"){
		//means is dir
		args.path += page_name
	}

	if ! args.path.ends_with(".md"){
		args.path += ".md"
	}

	mut pagepath:= "${site.path.path}/${args.path}"
	mut pagefile:= pathlib.get_file(path:pagepath,create:true)!

	pagefile.write(c)!

   console.print_debug("Copy images in collection '${collection_name}' to ${pagefile.path_dir()}")

   site.client.copy_images(collection_name, page_name, pagefile.path_dir())  or {
		return error("Couldn't copy images for '${page_name}' in collection '${collection_name}' using doctreeclient. Available pages:\n${site.client.list_markdown()!}\nError: ${err}")
	}

}



@[params]
pub struct Section {
pub mut:
	position int
	path string
	label string
}


pub fn (mut site Site) section_add(args_ Section) ! {
	mut args:= args_

	mut c:='{
    "label": "${args.label}",
    "position": ${args.position},
    "link": {
      "type": "generated-index"
    }
  }'

	mut category_path:= "${site.path.path}/${args.path}/_category_.json"
	mut catfile:= pathlib.get_file(path:category_path,create:true)!

	catfile.write(c)!

}

