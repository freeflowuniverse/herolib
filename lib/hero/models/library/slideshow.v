module library

import freeflowuniverse.herolib.hero.models.core

// Slide represents a single slide in a slideshow
pub struct Slide {
	// URL of the image for this slide
	image_url string

	// Optional title for the slide
	title ?string

	// Optional description for the slide
	description ?string
}

// Slideshow represents a Slideshow library item (collection of images for slideshow)
pub struct Slideshow {
	core.Base // Title of the slideshow
	title string @[index]

	// Optional description of the slideshow
	description ?string

	// List of slides
	slides []Slide
}
