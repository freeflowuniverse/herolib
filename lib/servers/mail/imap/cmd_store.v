module imap

import net
import strconv

// handle_store processes the STORE command
// See RFC 3501 Section 6.4.6
pub fn (mut self Session) handle_store(tag string, parts []string) ! {
	// Check if user is logged in
	if self.username == '' {
		self.conn.write('${tag} NO Must be logged in first\r\n'.bytes())!
		return error('Not logged in')
	}

	// Expecting format like: A003 STORE sequence-set operation flags
	if parts.len < 5 {
		self.conn.write('${tag} BAD STORE requires a sequence-set, an operation, and flags\r\n'.bytes())!
		return
	}

	// Get all messages to find the target message
	messages := self.server.mailboxserver.message_list(self.username, self.mailbox)!

	// Parse sequence set (currently only supporting single message numbers)
	sequence := parts[2]
	index := strconv.atoi(sequence) or {
		self.conn.write('${tag} BAD Invalid sequence-set\r\n'.bytes())!
		return
	} - 1

	if index < 0 || index >= messages.len {
		self.conn.write('${tag} NO No such message\r\n'.bytes())!
		return
	}

	// Parse operation (FLAGS, +FLAGS, -FLAGS, with optional .SILENT)
	op := parts[3]
	silent := op.ends_with('.SILENT')
	base_op := if silent { op[..op.len - 7] } else { op }

	if base_op !in ['FLAGS', '+FLAGS', '-FLAGS'] {
		self.conn.write('${tag} BAD Unknown STORE operation\r\n'.bytes())!
		return
	}

	// Parse flags
	flags_str := parts[4]
	flags_clean := flags_str.trim('()')
	flags_arr := flags_clean.split(' ').filter(it != '')

	// Validate flags
	valid_flags := ['\\Answered', '\\Flagged', '\\Deleted', '\\Seen', '\\Draft']
	for flag in flags_arr {
		if !flag.starts_with('\\') || flag !in valid_flags {
			self.conn.write('${tag} BAD Invalid flag\r\n'.bytes())!
			return
		}
	}

	mut msg := messages[index]
	old_flags := msg.flags.clone() // Save for comparison

	// Apply flag changes
	match base_op {
		'+FLAGS' {
			// Add each flag if it isn't already present
			for flag in flags_arr {
				if flag !in msg.flags {
					msg.flags << flag
				}
			}
		}
		'-FLAGS' {
			// Remove specified flags
			for flag in flags_arr {
				msg.flags = msg.flags.filter(it != flag)
			}
		}
		'FLAGS' {
			// Replace current flags
			msg.flags = flags_arr
		}
		else {}
	}

	// Save the updated message using mailbox module's message_set
	self.server.mailboxserver.message_set(self.username, self.mailbox, msg.uid, msg) or {
		self.conn.write('${tag} NO Failed to update message flags\r\n'.bytes())!
		return error('Failed to update message flags: ${err}')
	}

	// Send untagged FETCH response if flags changed and not silent
	if !silent && msg.flags != old_flags {
		self.conn.write('* ${index + 1} FETCH (FLAGS (${msg.flags.join(' ')}))\r\n'.bytes())!
	}

	self.conn.write('${tag} OK STORE completed\r\n'.bytes())!
}
