module docusaurus


//to avoid overwriting wrong locations

fn check_item(item string) ! {
	item2 := item.trim_space().trim('/').trim_space().all_after_last('/')
	if ['internal', 'infodev', 'info', 'dev', 'friends', 'dd', 'web'].contains(item2) {
		return error('destination path is wrong, cannot be: ${item}')
	}
}

fn (mut site DocSite) check() ! {
	for item in site.config.main.build_dest {
		check_item(item)!
	}
	for item in site.config.main.build_dest_dev {
		check_item(item)!
	}
}