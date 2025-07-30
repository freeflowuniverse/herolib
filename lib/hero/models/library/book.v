module library

import freeflowuniverse.herolib.hero.models.core

// TocEntry represents a table of contents entry for a book
pub struct TocEntry {
    // Title of the chapter/section
    title string
    
    // Page number (index in the pages array)
    page u32
    
    // Optional subsections
    subsections []TocEntry
}

// Book represents a Book library item (collection of markdown pages with TOC)
pub struct Book {
    core.Base
    
    // Title of the book
    title string @[index]
    
    // Optional description of the book
    description ?string
    
    // Table of contents
    table_of_contents []TocEntry
    
    // Pages content (markdown strings)
    pages []string
}