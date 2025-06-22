#!/usr/bin/env -S v -n -w -gc none -cg -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.web.docusaurus
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.core.playbook
import os

fn main() {
	println('Starting Docusaurus Example with HeroScript')

	// Define the HeroScript that configures our Docusaurus site
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
	
	!!docusaurus.ssh_connection
	    name:"production"
	    host:"example.com"
	    login:"deploy"
	    port:22
	    key_path:"~/.ssh/id_rsa"
	
	!!docusaurus.build_dest
	    ssh_name:"production"
	    path:"/var/www/docs"
	
	!!docusaurus.navbar
	    title:"My Project"
	
	!!docusaurus.navbar_item
	    label:"Documentation"
	    href:"/docs"
	    position:"left"
	
	!!docusaurus.navbar_item
	    label:"API"
	    href:"/api"
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
	    title:"Documentation"
	    label:"API Reference"
	    to:"/api"
	
	!!docusaurus.footer_item
	    title:"Community"
	    label:"GitHub"
	    href:"https://github.com/example/repo"
	
	!!docusaurus.footer_item
	    title:"Community"
	    label:"Discord"
	    href:"https://discord.gg/example"
	
	!!docusaurus.footer_item
	    title:"More"
	    label:"Blog"
	    href:"https://blog.example.com"
	
	!!docusaurus.import_source
	    url:"https://github.com/example/external-docs"
	    dest:"external"
	    replace:"PROJECT_NAME:My Project, VERSION:1.0.0"
	'

	mut docs := docusaurus.new(
		build_path: os.join_path(os.home_dir(), 'hero/var/docusaurus_demo1')
		update:     true // Update the templates
		heroscript: hero_script
	) or {
		eprintln('Error creating docusaurus factory with inline script: ${err}')
		exit(1)
	}

	// Create a site directory if it doesn't exist
	site_path := os.join_path(os.home_dir(), 'hero/var/docusaurus_demo_src')
	os.mkdir_all(site_path) or {
		eprintln('Error creating site directory: ${err}')
		exit(1)
	}

	// Get or create a site using the factory
	println('Creating site...')
	mut site := docs.get(
		name: 'my-documentation'
		path: site_path
		init: true // Create if it doesn't exist
		// Note: The site will use the config from the previously processed HeroScript
	) or {
		eprintln('Error creating site: ${err}')
		exit(1)
	}

	// Generate a sample markdown file for the docs
	println('Creating sample markdown content...')
	mut docs_dir := pathlib.get_dir(path: os.join_path(site_path, 'docs'), create: true) or {
		eprintln('Error creating docs directory: ${err}')
		exit(1)
	}

	// Create intro.md file
	mut intro_file := docs_dir.file_get_new('intro.md') or {
		eprintln('Error creating intro file: ${err}')
		exit(1)
	}

	intro_content := '---
title: Introduction
slug: /
sidebar_position: 1
---

# Welcome to My Documentation

This is a sample documentation site created with Docusaurus and HeroLib V using HeroScript configuration.

## Features

- Easy to use
- Markdown support
- Customizable
- Search functionality

## Getting Started

Follow these steps to get started:

1. Installation
2. Configuration
3. Adding content
4. Deployment
'
	intro_file.write(intro_content) or {
		eprintln('Error writing to intro file: ${err}')
		exit(1)
	}

	// Create quick-start.md file
	mut quickstart_file := docs_dir.file_get_new('quick-start.md') or {
		eprintln('Error creating quickstart file: ${err}')
		exit(1)
	}

	quickstart_content := '---
title: Quick Start
sidebar_position: 2
---

# Quick Start Guide

This guide will help you get up and running quickly.

## Installation

```bash
$ npm install my-project
```

## Basic Usage

```javascript
import { myFunction } from "my-project";

// Use the function
const result = myFunction();
console.log(result);
```
'
	quickstart_file.write(quickstart_content) or {
		eprintln('Error writing to quickstart file: ${err}')
		exit(1)
	}

	// Generate the site
	println('Generating site...')
	site.generate() or {
		eprintln('Error generating site: ${err}')
		exit(1)
	}

	println('Site generated successfully!')

	// Choose which operation to perform:

	// Option 1: Run in development mode
	// This will start a development server in a screen session
	println('Starting development server...')
	site.dev(host: 'localhost', port: 3000) or {
		eprintln('Error starting development server: ${err}')
		exit(1)
	}

	// Option 2: Build for production (uncomment to use)
	/*
	println('Building site for production...')
	site.build() or {
		eprintln('Error building site: ${err}')
		exit(1)
	}
	println('Site built successfully!')
	*/

	// Option 3: Build and publish to the remote server (uncomment to use)
	/*
	println('Building and publishing site...')
	site.build_publish() or {
		eprintln('Error publishing site: ${err}')
		exit(1)
	}
	println('Site published successfully!')
	*/
}
