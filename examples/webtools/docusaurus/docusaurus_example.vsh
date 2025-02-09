#!/usr/bin/env -S v -n -w -gc none  -cg -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.web.docusaurus
// import freeflowuniverse.herolib.data.doctree

// Create a new docusaurus factory
mut docs := docusaurus.new(
	build_path: '/tmp/docusaurus_build'
)!

// Create a new docusaurus site
mut site := docs.dev(
	url: 'https://git.ourworld.tf/despiegk/docs_kristof'
)!

// FOR FUTURE TO ADD CONTENT FROM DOCTREE

// Create a doctree for content
// mut tree := doctree.new(name: 'content')!

// // Add some content from a git repository
// tree.scan(
//     git_url: 'https://github.com/yourusername/your-docs-repo'
//     git_pull: true
// )!

// // Export the content to the docusaurus site
// tree.export(
//     destination: '${site.path_build.path}/docs'
//     reset: true
//     keep_structure: true
//     exclude_errors: false
// )!

// Build the docusaurus site
// site.build()!

// Generate the static site
// site.generate()!

// Optionally open the site in a browser
// site.open()!
