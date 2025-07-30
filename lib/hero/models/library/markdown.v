module library

import freeflowuniverse.herolib.hero.models.core

// Markdown represents a Markdown document library item
pub struct Markdown {
    core.Base
    
    // Title of the document
    title string @[index]
    
    // Optional description of the document
    description ?string
    
    // The markdown content
    content string
}