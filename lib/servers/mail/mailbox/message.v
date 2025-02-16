module mailbox

import time

// Represents an email message.
@[heap]
pub struct Message {
pub mut:
	uid           u32 // Unique identifier for the message
	subject       string
	body          string
	flags         []string  // e.g.: ["\\Seen", "\\Flagged"]
	internal_date time.Time // Message arrival time
}
