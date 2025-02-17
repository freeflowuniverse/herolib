module mailbox

// Represents a mailbox holding messages.
@[heap]
struct Mailbox {
mut:
	name         string
	messages     []Message
	next_uid     u32  // Next unique identifier to be assigned
	uid_validity u32  // Unique identifier validity value
	read_only    bool // Whether mailbox is read-only
}

// Returns all messages in the mailbox
fn (mut self Mailbox) list() ![]Message {
	return self.messages
}

// Gets a message by its UID
fn (mut self Mailbox) get(uid u32) !Message {
	for msg in self.messages {
		if msg.uid == uid {
			return msg
		}
	}
	return error('Message with UID ${uid} not found')
}

// Deletes a message by its UID
fn (mut self Mailbox) delete(uid u32) ! {
	for i, msg in self.messages {
		if msg.uid == uid {
			self.messages.delete(i)
			return
		}
	}
	return error('Message with UID ${uid} not found')
}

// Sets/updates a message with the given UID
fn (mut self Mailbox) set(uid u32, msg Message) ! {
	if self.read_only {
		return error('Mailbox is read-only')
	}

	mut found := false
	for i, existing in self.messages {
		if existing.uid == uid {
			self.messages[i] = msg
			found = true
			break
		}
	}

	if !found {
		// Add as new message if UID doesn't exist
		self.messages << msg
	}
}

@[params]
pub struct FindArgs {
pub mut:
	subject string
	content string
	flags   []string
}

// Finds messages matching the given criteria
fn (mut self Mailbox) find(args FindArgs) ![]Message {
	mut results := []Message{}

	for msg in self.messages {
		mut matches := true

		// Check subject if specified
		if args.subject != '' && !msg.subject.contains(args.subject) {
			matches = false
		}

		// Check content if specified
		if matches && args.content != '' && !msg.body.contains(args.content) {
			matches = false
		}

		// Check all specified flags are present
		if matches && args.flags.len > 0 {
			for flag in args.flags {
				if flag !in msg.flags {
					matches = false
					break
				}
			}
		}

		if matches {
			results << msg
		}
	}

	return results
}

fn (mut self Mailbox) len() int {
	return self.messages.len
}
