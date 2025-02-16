module imap

import net
import strconv

// handle_fetch processes the FETCH command
pub fn (mut self Session) handle_fetch( tag string, parts []string) ! {
	mut mailbox:=self.mailbox()!
	// For simplicity, we support commands like: A001 FETCH 1:* BODY[TEXT]
	if parts.len < 4 {
		conn.write('${tag} BAD FETCH requires a message sequence and data item\r\n'.bytes())!
		return
	}
	sequence := parts[2]
	selected_mailbox := server.mailboxes[mailbox_name]
	// If the sequence is 1:*, iterate over all messages.
	if sequence == '1:*' {
		for i, msg in selected_mailbox.messages {
			flags_str := if msg.flags.len > 0 {
				'(' + msg.flags.join(' ') + ')'
			} else {
				'()'
			}
			// In a full implementation, more attributes would be returned.
			conn.write('* ${i+1} FETCH (FLAGS ${flags_str} BODY[TEXT] "${msg.body}")\r\n'.bytes())!
		}
		conn.write('${tag} OK FETCH completed\r\n'.bytes())!
	return true
	} else {
		// Otherwise, parse a single message number
		index := strconv.atoi(parts[2]) or {
			conn.write('${tag} BAD Invalid message number\r\n'.bytes())!
			return
		} - 1
		if index < 0 || index >= server.mailboxes[mailbox_name].messages.len {
			conn.write('${tag} BAD Invalid message sequence\r\n'.bytes())!
		} else {
			msg := selected_mailbox.messages[index]
			flags_str := if msg.flags.len > 0 {
				'(' + msg.flags.join(' ') + ')'
			} else {
				'()'
			}
			conn.write('* ${index+1} FETCH (FLAGS ${flags_str} BODY[TEXT] "${msg.body}")\r\n'.bytes())!
			conn.write('${tag} OK FETCH completed\r\n'.bytes())!
			return true
		}
	}
}
