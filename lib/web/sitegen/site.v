module sitegen

import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.data.doctree

pub struct Site {
pub mut:
	name string
	path pathlib.Path
	tree &doctree.Tree
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

	mut mypage:=site.tree.page_get(args.src) or {
		// site.tree.print_pages()
		return error("Couldn't find page '${args.src}' in site tree:'${site.tree.name}', needs to be in form \$collection:\$name\n${site.tree.list_markdown()}")
	}

	c+="\n${mypage.get_markdown()!}\n"

	mut pagepath:= "${site.path.path}/${args.path}"
	mut pagefile:= pathlib.get_file(path:pagepath,create:true)!

	pagefile.write(c)!


}
