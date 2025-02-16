module imap

import net
import strconv

// handle_store processes the STORE command
pub fn  (mut self Session) handle_store(mut conn net.TcpConn, tag string, parts []string, mut server IMAPServer, mailbox_name string) !bool {
	if mailbox_name !in server.mailboxes {
		conn.write('${tag} BAD No mailbox selected\r\n'.bytes())!
		return
	}
	// Expecting a format like: A003 STORE 1 +FLAGS (\Seen)
	if parts.len < 5 {
		conn.write('${tag} BAD STORE requires a message sequence, an operation, and flags\r\n'.bytes())!
		return
	}
	// For simplicity, only support a single message number.
	index := strconv.atoi(parts[2]) or {
		conn.write('${tag} BAD Invalid message number\r\n'.bytes())!
		return
	} - 1
	if index < 0 || index >= server.mailboxes[mailbox_name].messages.len {
		conn.write('${tag} BAD Invalid message sequence\r\n'.bytes())!
		return
	}
	op := parts[3] // e.g. "+FLAGS", "-FLAGS", or "FLAGS"
	// The flags are provided in the next token, e.g.: (\Seen)
	flags_str := parts[4]
	// Remove any surrounding parentheses.
	flags_clean := flags_str.trim('()')
	flags_arr := flags_clean.split(' ').filter(it != '')
	mut msg := server.mailboxes[mailbox_name].messages[index]
	match op {
		'+FLAGS' {
			// Add each flag if it isn't already present.
			for flag in flags_arr {
				if flag !in msg.flags {
					msg.flags << flag
				}
			}
		}
		'-FLAGS' {
			// Remove any flags that match.
			for flag in flags_arr {
				msg.flags = msg.flags.filter(it != flag)
			}
		}
		'FLAGS' {
			// Replace current flags.
			msg.flags = flags_arr
		}
		else {
			conn.write('${tag} BAD Unknown STORE operation\r\n'.bytes())!
			return
		}
	}
	// Save the updated message back.
	server.mailboxes[mailbox_name].messages[index] = msg
	conn.write('${tag} OK [PERMANENTFLAGS (\\Answered \\Flagged \\Deleted \\Seen \\Draft)] Store completed\r\n'.bytes())!
	return true
}
