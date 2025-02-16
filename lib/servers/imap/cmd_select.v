module imap

import net

// handle_select processes the SELECT command
pub fn  (mut self Session) handle_select(mut conn net.TcpConn, tag string, parts []string, mut server IMAPServer) !string {
	if parts.len < 3 {
		conn.write('${tag} BAD SELECT requires a mailbox name\r\n'.bytes())!
		return error('SELECT requires a mailbox name')
	}
	// Remove any surrounding quotes from mailbox name
	mailbox_name := parts[2].trim('"')
	// Look for the mailbox. If not found, create it.
	if mailbox_name !in server.mailboxes {
		server.mailboxes[mailbox_name] = &Mailbox{
			name: mailbox_name
			messages: []Message{}
		}
	}
	// Respond with a basic status.
	messages_count := server.mailboxes[mailbox_name].messages.len
	conn.write('* FLAGS (\\Answered \\Flagged \\Deleted \\Seen \\Draft)\r\n'.bytes())!
	conn.write('* ${messages_count} EXISTS\r\n'.bytes())!
	conn.write('* OK [PERMANENTFLAGS (\\Answered \\Flagged \\Deleted \\Seen \\Draft \\*)] Flags permitted\r\n'.bytes())!
	conn.write('${tag} OK [READ-WRITE] SELECT completed\r\n'.bytes())!
	return mailbox_name
}
