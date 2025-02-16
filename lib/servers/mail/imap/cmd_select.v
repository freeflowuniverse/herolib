module imap

import net

// handle_select processes the SELECT command
// See RFC 3501 Section 6.3.2
pub fn (mut self Session) handle_select(tag string, parts []string) ! {
	if parts.len < 3 {
		self.conn.write('${tag} BAD SELECT requires a mailbox name\r\n'.bytes())!
		return error('SELECT requires a mailbox name')
	}

	// Check if user is logged in
	if self.username == '' {
		self.conn.write('${tag} NO Must be logged in first\r\n'.bytes())!
		return error('Not logged in')
	}

	// If there's a currently selected mailbox, send CLOSED response
	if self.mailbox != '' {
		self.conn.write('* OK [CLOSED] Previous mailbox is now closed\r\n'.bytes())!
	}

	// Remove any surrounding quotes from mailbox name
	mailbox_name := parts[2].trim('"')

	// Check if mailbox exists by trying to list messages
	messages := self.server.mailboxserver.message_list(self.username, mailbox_name) or {
		self.conn.write('${tag} NO Mailbox does not exist\r\n'.bytes())!
		return error('Mailbox does not exist')
	}

	messages_count := messages.len

	// Required untagged responses per spec:
	// 1. FLAGS - list of flags that can be set on messages
	self.conn.write('* FLAGS (\\Answered \\Flagged \\Deleted \\Seen \\Draft)\r\n'.bytes())!
	
	// 2. EXISTS - number of messages
	self.conn.write('* ${messages_count} EXISTS\r\n'.bytes())!

	// Required OK untagged responses:
	// 1. PERMANENTFLAGS
	self.conn.write('* OK [PERMANENTFLAGS (\\Answered \\Flagged \\Deleted \\Seen \\Draft \\*)] Flags permitted\r\n'.bytes())!
	
	// 2. UIDNEXT - Use a high number since we don't have direct access to next_uid
	self.conn.write('* OK [UIDNEXT 4294967295] Predicted next UID\r\n'.bytes())!
	
	// 3. UIDVALIDITY - Use a constant since we don't have direct access to uid_validity
	self.conn.write('* OK [UIDVALIDITY 1] UIDs valid\r\n'.bytes())!

	// Update session's selected mailbox
	self.mailbox = mailbox_name

	// Always use READ-WRITE mode since we don't have read-only information
	self.conn.write('${tag} OK [READ-WRITE] SELECT completed\r\n'.bytes())!
}
