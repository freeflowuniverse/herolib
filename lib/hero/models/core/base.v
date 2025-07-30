module core

// BaseData provides common fields for all models
pub struct Base {
pub mut:
	id        u32
	created   u64 // Unix timestamp of creation
	updated   u64 // Unix timestamp of last update
	deleted   bool
	version   u32
	comments  []Comment
}