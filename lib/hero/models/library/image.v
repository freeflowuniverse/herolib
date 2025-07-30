module library

import freeflowuniverse.herolib.hero.models.core

// Image represents an Image library item
pub struct Image {
    core.Base
    
    // Title of the image
    title string @[index]
    
    // Optional description of the image
    description ?string
    
    // URL of the image
    url string
    
    // Width of the image in pixels
    width u32
    
    // Height of the image in pixels
    height u32
}