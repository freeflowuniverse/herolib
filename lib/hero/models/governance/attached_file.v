module governance

import freeflowuniverse.herolib.hero.models.core

// AttachedFile represents files attached to governance entities
pub struct AttachedFile {
    core.Base
pub mut:
    entity_id u32 // ID of entity this file is attached to @[index]
    entity_type string // Type of entity (proposal, meeting, etc.) @[index]
    filename string // Original filename
    content_type string // MIME type
    size u64 // File size in bytes
    path string // Storage path
    description string // Optional description
    uploaded_by u32 // User who uploaded @[index]
}