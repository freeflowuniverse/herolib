module library

import freeflowuniverse.herolib.hero.models.core

// Pdf represents a PDF document library item
pub struct Pdf {
	core.Base // Title of the PDF
	title string @[index]

	// Optional description of the PDF
	description ?string

	// URL of the PDF file
	url string

	// Number of pages in the PDF
	page_count u32
}
