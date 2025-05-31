module docusaurus

// fn (mut site DocSite) process_md(mut path pathlib.Path, args ImportSource) ! {
// 	if path.is_dir() {
// 		mut pathlist_images := path.list(
// 			regex:     [r'.*\.png$', r'.*\.jpg$', r'.*\.svg$', r'.*\.jpeg$']
// 			recursive: true
// 		)!
// 		for mut mypatho_img in pathlist_images.paths {
// 			// now copy the image to the dest
// 			dest := '${site.path_build.path}/docs/${args.dest}/img/${texttools.name_fix(mypatho_img.name())}'
// 			// println("image copy: ${dest}")
// 			mypatho_img.copy(dest: dest, rsync: false)!
// 		}

// 		mut pathlist := path.list(regex: [r'.*\.md$'], recursive: true)!
// 		for mut mypatho2 in pathlist.paths {
// 			site.process_md(mut mypatho2, args)!
// 		}
// 		return
// 	}
// 	mydest := '${site.path_build.path}/docs/${args.dest}/${texttools.name_fix(path.name())}'
// 	mut mydesto := pathlib.get_file(path: mydest, create: true)!

// 	mut mymd := markdownparser.new(path: path.path)!
// 	mut myfm := mymd.frontmatter2()!
// 	if !args.visible {
// 		myfm.args['draft'] = 'true'
// 	}
// 	// println(myfm)
// 	// println(mymd.markdown()!)
// 	mydesto.write(mymd.markdown()!)!
// 	// Note: exit(0) was removed to prevent unexpected program termination
// }
