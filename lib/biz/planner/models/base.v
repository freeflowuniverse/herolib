module models

import time

// BaseModel provides common fields and functionality for all root objects
pub struct BaseModel {
pub mut:
	id          int       @[primary; sql: serial]
	created_at  time.Time @[sql_type: 'TIMESTAMP DEFAULT CURRENT_TIMESTAMP']
	updated_at  time.Time @[sql_type: 'TIMESTAMP DEFAULT CURRENT_TIMESTAMP']
	created_by  int       // User ID who created this record
	updated_by  int       // User ID who last updated this record
	version     int       // For optimistic locking
	tags        []string  // Flexible tagging system for categorization
	metadata    map[string]string // Extensible key-value data for custom fields
	is_active   bool = true       // Soft delete flag
}

// update_timestamp updates the updated_at field and version for optimistic locking
pub fn (mut base BaseModel) update_timestamp(user_id int) {
	base.updated_at = time.now()
	base.updated_by = user_id
	base.version++
}

// add_tag adds a tag if it doesn't already exist
pub fn (mut base BaseModel) add_tag(tag string) {
	if tag !in base.tags {
		base.tags << tag
	}
}

// remove_tag removes a tag if it exists
pub fn (mut base BaseModel) remove_tag(tag string) {
	base.tags = base.tags.filter(it != tag)
}

// has_tag checks if a tag exists
pub fn (base BaseModel) has_tag(tag string) bool {
	return tag in base.tags
}

// set_metadata sets a metadata key-value pair
pub fn (mut base BaseModel) set_metadata(key string, value string) {
	base.metadata[key] = value
}

// get_metadata gets a metadata value by key
pub fn (base BaseModel) get_metadata(key string) ?string {
	return base.metadata[key] or { none }
}

// soft_delete marks the record as inactive instead of deleting it
pub fn (mut base BaseModel) soft_delete(user_id int) {
	base.is_active = false
	base.update_timestamp(user_id)
}

// restore reactivates a soft-deleted record
pub fn (mut base BaseModel) restore(user_id int) {
	base.is_active = true
	base.update_timestamp(user_id)
}