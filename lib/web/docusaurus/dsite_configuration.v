module docusaurus

import freeflowuniverse.herolib.web.site


pub struct Configuration {
pub mut:
	main   Main
	navbar Navbar
	footer Footer
}

pub struct Main {
pub mut:
	title          string
	tagline        string
	favicon        string
	url            string
	base_url       string @[json: 'baseUrl']
	url_home       string
	image          string
	metadata       Metadata
	build_dest     []string @[json: 'buildDest']
	build_dest_dev []string @[json: 'buildDestDev']
	copyright      string
	name           string
}

pub struct Metadata {
pub mut:
	description string
	image       string
	title       string
}

pub struct Navbar {
pub mut:
	title string
	logo  Logo
	items []NavbarItem
}

pub struct Logo {
pub mut:
	alt      string
	src      string
	src_dark string @[json: 'srcDark']
}

pub struct NavbarItem {
pub mut:
	label    string
	href     string @[omitempty]
	position string
	to       string @[omitempty]
}

pub struct Footer {
pub mut:
	style string
	links []FooterLink
}

pub struct FooterLink {
pub mut:
	title string
	items []FooterItem
}

pub struct FooterItem {
pub mut:
	label string
	href  string @[omitempty]
	to    string @[omitempty]
}
// ... (struct definitions remain the same) ...

// This function is now a pure transformer: site.SiteConfig -> docusaurus.Configuration
pub fn new_configuration(site_cfg site.SiteConfig) !Configuration {
	// Transform site.SiteConfig to docusaurus.Configuration
	mut nav_items := []NavbarItem{}
	for item in site_cfg.menu.items {
		nav_items << NavbarItem{
			label:    item.label
			href:     item.href
			position: item.position
			to:       item.to
		}
	}

	mut footer_links := []FooterLink{}
	for link in site_cfg.footer.links {
		mut footer_items_mapped := []FooterItem{}
		for item in link.items {
			footer_items_mapped << FooterItem{
				label: item.label
				href:  item.href
				to:    item.to
			}
		}
		footer_links << FooterLink{
			title: link.title
			items: footer_items_mapped
		}
	}

	cfg := Configuration{
		main: Main{
			title:          site_cfg.title
			tagline:        site_cfg.tagline
			favicon:        site_cfg.favicon
			url:            site_cfg.url
			base_url:       site_cfg.base_url
			url_home:       site_cfg.url_home
			image:          site_cfg.image
			metadata:       Metadata{
				title:       site_cfg.meta_title
				description: site_cfg.description
				image:       site_cfg.meta_image
			}
			build_dest:     site_cfg.build_dest.map(it.path)
			build_dest_dev: site_cfg.build_dest_dev.map(it.path)
			copyright:      site_cfg.copyright
			name:           site_cfg.name
		}
		navbar: Navbar{
			title: site_cfg.menu.title
			logo:  Logo{
				alt:      site_cfg.menu.logo_alt
				src:      site_cfg.menu.logo_src
				src_dark: site_cfg.menu.logo_src_dark
			}
			items: nav_items
		}
		footer: Footer{
			style: site_cfg.footer.style
			links: footer_links
		}
	}
	return config_fix(cfg)!
}

fn config_fix(config Configuration) !Configuration {
	return Configuration{
		...config
		main: Main{
			...config.main
			title:    if config.main.title == '' { 'Docusaurus' } else { config.main.title }
			favicon:  if config.main.favicon == '' { 'img/favicon.ico' } else { config.main.favicon }
			url:      if config.main.url == '' { 'https://example.com' } else { config.main.url }
			base_url: if config.main.base_url == '' { '/' } else { config.main.base_url }
		}
	}	// ... (no changes needed here) ...
}
