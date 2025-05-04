# Docusaurus Library for V

This library provides a convenient wrapper around Docusaurus, a powerful static website generator maintained by Meta. It allows you to:

- Create and manage multiple documentation sites
- Configure sites through HeroScript
- Build sites for production
- Set up development environments with hot reloading
- Handle file watching for automatic rebuilding
- Deploy sites to remote servers
- Import content from Git repositories

## Usage

```v
import freeflowuniverse.herolib.web.docusaurus
import os

// Define your HeroScript configuration
hero_script := '
!!docusaurus.config
    name:"my-documentation"
    title:"My Documentation Site"
    tagline:"Documentation made simple with V and Docusaurus"
    url:"https://docs.example.com"
    url_home:"docs/"
    base_url:"/"
    favicon:"img/favicon.png"
    image:"img/hero.png"
    copyright:"© 2025 Example Organization"

!!docusaurus.config_meta
    description:"Comprehensive documentation for our amazing project"
    image:"https://docs.example.com/img/social-card.png"
    title:"My Documentation | Official Docs"

!!docusaurus.navbar
    title:"My Project"

!!docusaurus.navbar_item
    label:"Documentation"
    href:"/docs"
    position:"left"

!!docusaurus.navbar_item
    label:"GitHub"
    href:"https://github.com/example/repo"
    position:"right"

!!docusaurus.footer
    style:"dark"

!!docusaurus.footer_item
    title:"Documentation"
    label:"Introduction"
    to:"/docs"

!!docusaurus.footer_item
    title:"Community"
    label:"GitHub"
    href:"https://github.com/example/repo"
'

// Create a factory with the HeroScript configuration
mut docs := docusaurus.new(
    build_path: os.join_path(os.home_dir(), 'hero/var/docusaurus_demo')
    heroscript: hero_script
)!

// Create a site directory
site_path := os.join_path(os.home_dir(), 'hero/var/docusaurus_source')
os.mkdir_all(site_path)!

// Get or create a site using the factory
mut site := docs.get(
    name: 'my-documentation'
    path: site_path
    init: true
)!

// Generate a site
site.generate()!

// Start development server
site.dev()!

// Or build for production
// site.build()!

// Or build and publish
// site.build_publish()!
```

### Directory Structure

A typical Docusaurus site managed by this library has the following structure:

```
my-site/
├── docs/
│   ├── intro.md
│   └── ...
├── src/
│   └── ...
└── static/
    └── img/
        └── ...
```

### Development Workflow

1. Define your site configuration using HeroScript
2. Create a factory with the HeroScript configuration
3. Get or create a site using the factory
4. Run `site.dev()` to start development server
5. Edit files in the `docs` directory
6. When ready, run `site.build()` or `site.build_publish()` to deploy

## HeroScript Configuration Options

### Main Site Configuration

```
!!docusaurus.config
    name:"my-documentation"      # Site name (used for directories, etc.)
    title:"My Documentation"     # Main title displayed in browser
    tagline:"Documentation Made Easy"
    url:"https://docs.example.com"
    url_home:"docs/"
    base_url:"/"
    favicon:"img/favicon.png"
    image:"img/hero.png"
    copyright:"© 2025 My Organization"
```

### Metadata

```
!!docusaurus.config_meta
    description:"Comprehensive documentation for my project"
    image:"https://docs.example.com/img/social-card.png"
    title:"My Documentation | Official Docs"
```

### Navigation Bar

```
!!docusaurus.navbar
    title:"My Project"

!!docusaurus.navbar_item
    label:"Documentation"
    href:"/docs"
    position:"left"

!!docusaurus.navbar_item
    label:"GitHub"
    href:"https://github.com/example/repo"
    position:"right"
```

### Footer

```
!!docusaurus.footer
    style:"dark"

!!docusaurus.footer_item
    title:"Documentation"
    label:"Introduction"
    to:"/docs"

!!docusaurus.footer_item
    title:"Community"
    label:"GitHub"
    href:"https://github.com/example/repo"
```

### Remote Deployment

```
!!docusaurus.ssh_connection
    name:"production"
    host:"example.com"
    login:"deploy"
    port:22
    key_path:"~/.ssh/id_rsa"

!!docusaurus.build_dest
    ssh_name:"production"
    path:"/var/www/docs"
```

### Content Import

```
!!docusaurus.import_source
    url:"https://github.com/example/external-docs"
    dest:"external"
    replace:"PROJECT_NAME:My Project, VERSION:1.0.0"
```

## Multiple Ways to Use HeroScript

### Option 1: Provide HeroScript directly to the factory

```v
mut docs := docusaurus.new(
    build_path: '~/docusaurus_sites'
    heroscript: hero_script
)!
```

### Option 2: Load HeroScript from a file

```v
mut docs := docusaurus.new(
    build_path: '~/docusaurus_sites'
    heroscript_path: '~/my_docusaurus_config.hero'
)!
```

## Features in Detail

### File Watching

The library includes a file watcher that automatically updates the build directory when files change in the source directory. This enables a smooth development experience with hot reloading.

### Remote Deployment

Sites can be deployed to remote servers via SSH by configuring the deployment destinations in your HeroScript:

```
!!docusaurus.ssh_connection
    name:"production"
    host:"example.com"
    login:"deploy"
    port:22
    key_path:"~/.ssh/id_rsa"

!!docusaurus.build_dest
    ssh_name:"production"
    path:"/var/www/docs"
```

### Content Import

You can import content from Git repositories by configuring import sources in your HeroScript:

```
!!docusaurus.import_source
    url:"https://github.com/example/external-docs"
    dest:"external"
    replace:"PROJECT_NAME:My Project, VERSION:1.0.0"
```

