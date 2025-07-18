## How to use Heroscript with Docusaurus

You can use Heroscript to define and add content to your Docusaurus site. Below is an example:

```heroscript

!!docusaurus.define production:true, update:true

!!docusaurus.add name:"my_local_docs" path:"./docs"

!!docusaurus.add name:"tfgrid_docs" 
    git_url:"git_url:"https://git.threefold.info/tfgrid/docs_tfgrid4/src/branch/main/ebooks/tech"
    git_reset:true
    git_pull:true
```

### `docusaurus.define` Arguments

*   `path_publish` (string): Path where the Docusaurus site will be published. Default is an empty string.
*   `path_build` (string): Path where the Docusaurus site will be built. Default is an empty string.
*   `production` (boolean): If set to `true`, the site will be built for production. Default is `false`.
*   `update` (boolean): If set to `true`, the Docusaurus site will be updated. Default is `false`.
  
if heroscript used then it will send that content to the Docusaurus play command so it could do the docusaurus add below...

### `docusaurus.add` Arguments

*   `name` (string): Name of the Docusaurus site. Default is "main".
*   `path` (string): Local path to the documentation content. Default is an empty string.
*   `git_url` (string): Git URL of the documentation repository. Default is an empty string.
*   `git_reset` (boolean): If set to `true`, the Git repository will be reset. Default is `false`.
*   `git_pull` (boolean): If set to `true`, the Git repository will be pulled. Default is `false`.
*   `git_root` (string): Root directory within the Git repository. Default is an empty string.
*   `nameshort` (string): Short name for the Docusaurus site. Default is the value of `name`.
*   `path_publish` (string): Path where this specific documentation will be published. Default is an empty string.
*   `production` (boolean): If set to `true`, this documentation will be built for production. Default is `false`.
*   `watch_changes` (boolean): If set to `true`, changes will be watched. Default is `true`.
*   `update` (boolean): If set to `true`, this documentation will be updated. Default is `false`.
*   `open` (boolean): If set to `true`, the Docusaurus site will be opened after generation. Default is `false`.
*   `init` (boolean): If set to `true`, the Docusaurus site will be initialized. Default is `false`.


## called through code

### with heroscript in code

```v

import freeflowuniverse.herolib.web.docusaurus

docusaurus.new(heroscript:'

	//next is optional
	!!docusaurus.define
		path_build: "/tmp/docusaurus_build"
		path_publish: "/tmp/docusaurus_publish"

	!!docusaurus.add name:"tfgrid_docs" 
		git_url:"https://git.threefold.info/tfgrid/docs_tfgrid4/src/branch/main/ebooks/tech"
		git_root:"/tmp/code"
		git_reset:1

	!!docusaurus.dev

	')!

```


### directly

```v

import freeflowuniverse.herolib.web.docusaurus

// Create a new docusaurus factory
mut ds := docusaurus.new(
	path_build: '/tmp/docusaurus_build'
	path_publish: '/tmp/docusaurus_publish'
)!

// mut site:=ds.get(path:"${os.home_dir()}/code/git.threefold.info/tfgrid/docs_tfgrid4/ebooks/tech",name:"atest")!
mut site:=ds.get(url:"https://git.threefold.info/tfgrid/docs_tfgrid4/src/branch/main/ebooks/tech",name:"atest")!

// println(site)

//next generates but doesn't do anything beyond
// site.generate()!

site.dev()!

```