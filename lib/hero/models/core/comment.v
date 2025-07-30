module core

// Comment represents a generic comment that can be associated with any model
// It supports threaded conversations with parent/child relationships
pub struct Comment {
pub mut:
	// Unique identifier for the comment
	id u32 // Unique identifier for the comment @[index]
	// Timestamp when the comment was created
	created_at u64 // Timestamp when the comment was created
	// Timestamp when the comment was last updated
	updated_at u64 // Timestamp when the comment was last updated
	// ID of the user who posted this comment
	user_id u32 // ID of the user who posted this comment @[index]
	// The actual text content of the comment
	content string
	// Optional ID of the parent comment for threaded conversations
	// None indicates this is a top-level comment
	parent_comment_id u32
}
