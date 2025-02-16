module imap

import net

// handle_close processes the CLOSE command
// See RFC 3501 Section 6.4.1
pub fn (mut self Session) handle_close(tag string) ! {
	// If no mailbox is selected, return error
	if self.mailbox == '' {
		self.conn.write('${tag} NO No mailbox selected\r\n'.bytes())!
		return
	}

	// Get all messages in the mailbox
	messages := self.server.mailboxserver.message_list(self.username, self.mailbox)!

	// Delete messages with \Deleted flag
	for msg in messages {
		if '\\Deleted' in msg.flags {
			self.server.mailboxserver.message_delete(self.username, self.mailbox, msg.uid) or {
				eprintln('Failed to delete message ${msg.uid}: ${err}')
				continue
			}
		}
	}

	// Clear selected mailbox
	self.mailbox = ''

	self.conn.write('${tag} OK CLOSE completed\r\n'.bytes())!
}
