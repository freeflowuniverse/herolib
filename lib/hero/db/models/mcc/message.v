module models

import freeflowuniverse.herolib.hero.db.models.base
import freeflowuniverse.herolib.data.ourtime

// our attempt to make a message object which can be used for email as well as chat
pub struct Message {
	base.Base // Base struct for common fields
pub mut:
	// Database ID
	id          u32          // Database ID (assigned by DBHandler)
	message_id  string       // Unique identifier for the email
	folder      string       // The folder this email belongs to (inbox, sent, drafts, etc.)
	message     string       // The email body content
	attachments []Attachment // Any file attachments
	send_time   ourtime.OurTime

	date    i64  // Unix timestamp when the email was sent/received
	size    u32  // Size of the message in bytes
	read    bool // Whether the email has been read
	flagged bool // Whether the email has been flagged/starred

	// Header information
	subject     string
	from        []u32 // List of user IDs (or email addresses) who sent the email user needs to exist in circle where we use this
	sender      []u32
	reply_to    []u32
	to          []u32
	cc          []u32
	bcc         []u32
	in_reply_to u32
}

// Attachment represents an email attachment
pub struct Attachment {
pub mut:
	filename     string
	content_type string
	hash         string // Hash of the attachment data
}

pub fn (self Message) index_keys() map[string]string {
	return map[string]string{}
}

pub fn (self Message) ftindex_keys() map[string]string {
	return map[string]string{} // TODO: add subject and from to this and to and message
}
