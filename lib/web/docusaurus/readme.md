# Docusaurus Library for V

A V language library for creating, configuring, and managing [Docusaurus](https://docusaurus.io/) documentation sites with minimal effort.

## Overview

This library provides a convenient wrapper around Docusaurus, a powerful static website generator maintained by Meta. It allows you to:

- Create and manage multiple documentation sites
- Configure sites through structured JSON or HeroScript
- Build sites for production
- Set up development environments with hot reloading
- Handle file watching for automatic rebuilding
- Deploy sites to remote servers
- Import content from Git repositories

## Features

- **Simple API**: Create and manage Docusaurus sites with a few lines of V code
- **Flexible Configuration**: Configure sites using JSON files or programmatically
- **Development Mode**: Built-in development server with file watching
- **Remote Deployment**: Push to remote servers via SSH
- **Content Import**: Import content from Git repositories
- **Template Management**: Uses standard Docusaurus templates with custom configuration

## Installation

The library is part of the HeroLib package and can be imported as follows:

```v
import freeflowuniverse.herolib.web.docusaurus
```

## Usage

### Basic Example

```v
import freeflowuniverse.herolib.web.docusaurus

// Create a new docusaurus factory
mut docs := docusaurus.new(
    build_path: '~/docusaurus_projects' // Optional, defaults to ~/hero/var/docusaurus
)!

// Get or create a site
mut site := docs.get(
    name: 'my-docs', 
    path: '~/my-docs-source', 
    init: true  // Create if doesn't exist
)!

// Run development server
site.dev()!

// Or build for production
// site.build()!

// Or build and publish
// site.build_publish()!
```

### Configuration

Configuration is done via JSON files in the `cfg` directory of your site:

- `main.json`: Main site configuration (title, URL, metadata, etc.)
- `navbar.json`: Navigation bar configuration
- `footer.json`: Footer configuration

Example `main.json`:

```json
{
  "title": "My Documentation",
  "tagline": "Documentation Made Easy",
  "favicon": "img/favicon.png",
  "url": "https://docs.example.com",
  "url_home": "docs/",
  "baseUrl": "/",
  "image": "img/logo.png",
  "metadata": {
    "description": "Comprehensive documentation for my project",
    "image": "https://docs.example.com/img/logo.png",
    "title": "My Documentation"
  },
  "buildDest": ["user@server:/path/to/deployment"],
  "buildDestDev": ["user@server:/path/to/dev-deployment"]
}
```

### Directory Structure

A typical Docusaurus site managed by this library has the following structure:

```
my-site/
├── cfg/
│   ├── main.json
│   ├── navbar.json
│   └── footer.json
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

1. Create a new site using `docs.get()`
2. Configure your site via JSON files or programmatically
3. Run `site.dev()` to start development server
4. Edit files in the `docs` directory
5. When ready, run `site.build()` or `site.build_publish()` to deploy

## Features in Detail

### File Watching

The library includes a file watcher that automatically updates the build directory when files change in the source directory. This enables a smooth development experience with hot reloading.

### Remote Deployment

Sites can be deployed to remote servers via SSH. Configure the deployment destinations in `main.json`:

```json
"buildDest": ["user@server:/path/to/deployment"],
"buildDestDev": ["user@server:/path/to/dev-deployment"]
```

### Content Import

You can import content from Git repositories:

```json
"import": [
  {
    "url": "https://github.com/username/repo",
    "dest": "external-docs",
    "visible": true
  }
]
```

## Advanced Usage with HeroScript

You can configure your Docusaurus site using HeroScript in multiple ways:

### Option 1: Provide HeroScript directly to the factory

```v
import freeflowuniverse.herolib.web.docusaurus

// Create a factory with inline HeroScript
mut docs := docusaurus.new(
    build_path: '~/docusaurus_sites'
    heroscript: '
        !!docusaurus.config 
            name:"my-docs"
            title:"My Documentation"
            tagline:"Documentation Made Easy"
            url:"https://docs.example.com"
            base_url:"/"

        !!docusaurus.navbar
            title:"My Project"

        !!docusaurus.navbar_item
            label:"GitHub"
            href:"https://github.com/username/repo"
            position:"right"
    '
)!
```

### Option 2: Load HeroScript from a file

```v
import freeflowuniverse.herolib.web.docusaurus

// Create a factory using HeroScript from a file
mut docs := docusaurus.new(
    build_path: '~/docusaurus_sites'
    heroscript_path: '~/my_docusaurus_config.hero'
)!
```

### Option 3: Process HeroScript separately

```v
import freeflowuniverse.herolib.web.docusaurus

mut script := '
!!docusaurus.config 
    title:"My Documentation"
    tagline:"Documentation Made Easy"
    url:"https://docs.example.com"
    base_url:"/"

!!docusaurus.navbar
    title:"My Project"

!!docusaurus.navbar_item
    label:"GitHub"
    href:"https://github.com/username/repo"
    position:"right"
'

// Process the HeroScript to get a Config object
mut config := docusaurus.play(heroscript: script)!

// Use the config when creating a site
mut site := docs.get(
    name: 'my-site',
    path: '~/my-site-source',
    config: config
)!
```

## License

This library is part of the HeroLib project and follows its licensing terms.