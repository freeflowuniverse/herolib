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

	mut mbox := self.mailbox()!

	// Remove all messages with \Deleted flag
	mut new_messages := []Message{}
	for msg in mbox.messages {
		if '\\Deleted' !in msg.flags {
			new_messages << msg
		}
	}
	mbox.messages = new_messages

	// Clear selected mailbox
	self.mailbox = ''

	self.conn.write('${tag} OK CLOSE completed\r\n'.bytes())!
}
