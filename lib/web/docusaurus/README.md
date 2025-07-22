## How to use Heroscript with Docusaurus

You can use Heroscript to define and add content to your Docusaurus site. Below is an example:

```heroscript
!!docusaurus.define
	path_build: "/tmp/docusaurus_build"
	path_publish: "/tmp/docusaurus_publish"

!!docusaurus.reset

!!docusaurus.add name:"my_local_docs" path:"./docs"

!!docusaurus.add name:"tfgrid_docs" 
    git_url:"https://git.threefold.info/tfgrid/docs_tfgrid4/src/branch/main/ebooks/tech"
    git_reset:true
    git_pull:true
```

### `docusaurus.define` Arguments

*   `path_build` (string): Path where the Docusaurus site will be built. Default is `os.home_dir()/hero/var/docusaurus/build`.
*   `path_publish` (string): Path where the Docusaurus site will be published. Default is `os.home_dir()/hero/var/docusaurus/publish`.

### `docusaurus.reset` 

* resets the full docusaurus build system

### `docusaurus.update` 

* updates the docusaurus build system, e.g. pull the templates back in


### `docusaurus.generate` Arguments

*   `name` (string): Name of the Docusaurus site. Default is "main".
*   `path` (string): Local path to the documentation content. Default is an empty string.
*   `git_url` (string): Git URL of the documentation repository. Default is an empty string.
*   `git_reset` (boolean): If set to `true`, the Git repository will be reset. Default is `false`.
*   `git_pull` (boolean): If set to `true`, the Git repository will be pulled. Default is `false`.
*   `git_root` (string): Root directory within the Git repository. Default is an empty string.
*   `nameshort` (string): Short name for the Docusaurus site. Default is the value of `name`.

## called through code

### with heroscript in code

```v

import freeflowuniverse.herolib.web.docusaurus

mut ds:=docusaurus.new(heroscript:'

	//next is optional
	!!docusaurus.define
		path_build: "/tmp/docusaurus_build"
		path_publish: "/tmp/docusaurus_publish"

	!!docusaurus.generate name:"tfgrid_docs" 
		git_url:"https://git.threefold.info/tfgrid/docs_tfgrid4/src/branch/main/ebooks/tech"
		git_root:"/tmp/code"

	')!

mut site:=ds.site_get(name:"tfgrid_docs")!

site.dev()!

```

### directly

```v

import freeflowuniverse.herolib.web.docusaurus

// Create a new docusaurus factory
mut ds := docusaurus.new(
	path_build: '/tmp/docusaurus_build'
	path_publish: '/tmp/docusaurus_publish'
)!

// mut site:=ds.add(path:"${os.home_dir()}/code/git.threefold.info/tfgrid/docs_tfgrid4/ebooks/tech",name:"atest")!
mut site:=ds.add(git_url:"https://git.threefold.info/tfgrid/docs_tfgrid4/src/branch/main/ebooks/tech",name:"atest")!

// println(site)

//next generates but doesn't do anything beyond
// site.generate()!

site.dev()!

```