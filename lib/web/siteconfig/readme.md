# Site Module

The `lib/web/site/` directory contains the Vlang code responsible for generating and managing a documentation website all the config elements are specified in heroscript

## config heroscript

```yaml
!!site.config
    name:"ThreeFold DePIN Tech"
    description:"ThreeFold is laying the foundation for a geo aware Web 4, the next generation of the Internet."
    tagline:"Geo Aware Internet Platform"
    favicon:"img/favicon.png"
    image:"img/tf_graph.png"
    copyright:"ThreeFold"

!!site.menu
    title:"ThreeFold DePIN Tech"
    logo_alt:"ThreeFold Logo"
    logo_src:"img/logo.svg"
    logo_src_dark:"img/new_logo_tft.png"

!!site.menu_item
    label:"ThreeFold.io"
    href:"https://threefold.io"
    position:"right"

!!site.menu_item
    label:"Mycelium Network"
    href:"https://mycelium.threefold.io/"
    position:"right"

!!site.menu_item
    label:"AI Box"
    href:"https://aibox.threefold.io/"
    position:"right"

!!site.footer
    style:"dark"

!!site.footer_item
    title:"Docs"
    label:"Introduction"
    href:"https://docs.threefold.io/docs/introduction"

!!site.footer_item
    title:"Docs"
    label:"Litepaper"
    href:"https://docs.threefold.io/docs/litepaper/"

!!site.footer_item
    title:"Features"
    label:"Become a Farmer"
    href:"https://docs.threefold.io/docs/category/become-a-farmer"

!!site.footer_item
    title:"Features"
    label:"Components"
    href:"https://docs.threefold.io/docs/category/components"


!!site.footer_item
    title:"Web"
    label:"ThreeFold.io"
    href:"https://threefold.io"

!!site.footer_item
    title:"Web"
    label:"Dashboard"
    href:"https://dashboard.grid.tf"

!!site.collections
    url:"https://github.com/example/external-docs"
    replace:"PROJECT_NAME:My Project, VERSION:1.0.0"
```

## site structure

```yaml
!!site.page name:intro 
    description:"ThreeFold is laying the foundation for a geo aware Web 4, the next generation of the Internet."

//next is example where we use all properties, folder is where the page is located, prio is the order of the page, if not used the filled in from order in which we parse this config file
!!site.page name:mycelium draft:true folder:"/specs/components" prio:4
    content:"the page content itself, only for small pages"
    title:"Mycelium as Title"
    description:"..."

!!site.page name:fungistor folder:"/specs/components" prio:1
    src:"mycollection:mycelium.md"
    title:"fungistor as Title"
    description:"...."

!!site.page name:fungistor folder:"/specs/components" prio:1
    src:"mycollection:mycelium" //can be without .md
    title:"fungistor as Title"
    description:"..."

```

## how to use easy

```v
import freeflowuniverse.herolib.web.site
siteconfig := site.new(path:"/tmp/mypath")!

```

## how to use with playbook

```v
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.web.site
// path string
// text string
// git_url string
// git_pull bool
// git_branch string
// git_reset bool
// session  ?&base.Session      is optional
mut plbook := playbook.new(path: "....")!

site.play(plbook:plbook)!

```