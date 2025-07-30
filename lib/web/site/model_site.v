module site
import os


@[heap]
pub struct Site {
pub mut:
	pages       []Page
	sections	[]Section
	siteconfig SiteConfig

}

pub struct Page {
pub mut:
	title       string
	description string
	draft       bool
	position    int
	hide_title  bool
	src         string @[required]
	path        string @[required]
	title_nr    int
	slug string
}

pub struct Section {
pub mut:
	position int
	path     string
	label    string
}
