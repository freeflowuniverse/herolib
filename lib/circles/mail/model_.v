module mail

module mail

pub struct Email {
	id int           // Database ID (assigned by DBHandler)
	uid int          // Unique identifier of the message (in the circle)
	seq_num int      // IMAP sequence number (in the mailbox)
	mailbox string   // The mailbox this email belongs to
	message string   // The email body content
	attachments []Attachment // Any file attachments
	flags []string   // IMAP flags like \Seen, \Deleted, etc.
	internal_date int // Unix timestamp when the email was received
	size int         // Size of the message in bytes
	envelope Envelope
}

pub struct EmailCreate {
	mailbox string   // The mailbox this email belongs to
	message string   // The email body content
	attachments []Attachment // Any file attachments
	flags []string   // IMAP flags like \Seen, \Deleted, etc.
	envelope EnvelopeCreate
}

pub struct EmailUpdate {
	mailbox string   // The mailbox this email belongs to
	message string   // The email body content
	attachments []Attachment // Any file attachments
	flags []string   // IMAP flags like \Seen, \Deleted, etc.
	envelope EnvelopeCreate
}

pub struct Attachment {
	filename string     // Name of the attached file
	content_type string // MIME type of the attachment
	data string         // Base64 encoded binary data
}

pub struct Envelope {
	date int        // Unix timestamp of the email date
	subject string  // Email subject
	from []string   // From addresses
	sender []string // Sender addresses
	reply_to []string // Reply-To addresses
	to []string     // To addresses
	cc []string     // CC addresses
	bcc []string    // BCC addresses
	in_reply_to string // Message ID this email is replying to
	message_id string  // Unique message ID
}

pub struct EnvelopeCreate {
	subject string  // Email subject
	from []string   // From addresses
	to []string     // To addresses
	cc []string     // CC addresses
	bcc []string    // BCC addresses
}