module library

import freeflowuniverse.herolib.hero.models.core

// Collection represents a collection of library items
pub struct Collection {
	core.Base // Title of the collection
	title string @[index]

	// Optional description of the collection
	description ?string

	// List of image item IDs belonging to this collection
	images []u32

	// List of PDF item IDs belonging to this collection
	pdfs []u32

	// List of Markdown item IDs belonging to this collection
	markdowns []u32

	// List of Book item IDs belonging to this collection
	books []u32

	// List of Slides item IDs belonging to this collection
	slides []u32
}
