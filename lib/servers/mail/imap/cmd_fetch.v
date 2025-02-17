module imap

import net
import strconv

// handle_fetch processes the FETCH command
// See RFC 3501 Section 6.4.5
pub fn (mut self Session) handle_fetch(tag string, parts []string) ! {
	// Check if user is logged in
	if self.username == '' {
		self.conn.write('${tag} NO Must be logged in first\r\n'.bytes())!
		return error('Not logged in')
	}

	if parts.len < 4 {
		self.conn.write('${tag} BAD FETCH requires a message sequence and data item\r\n'.bytes())!
		return
	}

	sequence := parts[2]
	// Join remaining parts to handle parenthesized items
	data_items := parts[3..].join(' ').trim('()')

	// Parse data items, handling quoted strings and parentheses
	mut items_to_fetch := []string{}
	mut current_item := ''
	mut in_brackets := false

	for c in data_items {
		match c {
			`[` {
				in_brackets = true
				current_item += c.ascii_str()
			}
			`]` {
				in_brackets = false
				current_item += c.ascii_str()
				if current_item != '' {
					items_to_fetch << current_item.trim_space()
					current_item = ''
				}
			}
			` ` {
				if in_brackets {
					current_item += c.ascii_str()
				} else if current_item != '' {
					items_to_fetch << current_item.trim_space()
					current_item = ''
				}
			}
			else {
				current_item += c.ascii_str()
			}
		}
	}
	if current_item != '' {
		items_to_fetch << current_item.trim_space()
	}

	// Convert to uppercase for matching
	items_to_fetch = items_to_fetch.map(it.to_upper())

	// Get all messages in mailbox
	messages := self.server.mailboxserver.message_list(self.username, self.mailbox)!
	total_messages := messages.len

	// Parse sequence range
	mut start_idx := 0
	mut end_idx := 0

	if sequence == '1:*' {
		start_idx = 0
		end_idx = total_messages - 1
	} else if sequence.contains(':') {
		range_parts := sequence.split(':')
		if range_parts.len != 2 {
			self.conn.write('${tag} BAD Invalid sequence range\r\n'.bytes())!
			return
		}
		start_idx = strconv.atoi(range_parts[0]) or {
			self.conn.write('${tag} BAD Invalid sequence range start\r\n'.bytes())!
			return
		} - 1
		if range_parts[1] == '*' {
			end_idx = total_messages - 1
		} else {
			end_idx = strconv.atoi(range_parts[1]) or {
				self.conn.write('${tag} BAD Invalid sequence range end\r\n'.bytes())!
				return
			} - 1
		}
	} else {
		// Single message number
		start_idx = strconv.atoi(sequence) or {
			self.conn.write('${tag} BAD Invalid message number\r\n'.bytes())!
			return
		} - 1
		end_idx = start_idx
	}

	if start_idx < 0 || end_idx >= total_messages || start_idx > end_idx {
		self.conn.write('${tag} NO Invalid message range\r\n'.bytes())!
		return
	}

	// Process messages in range
	for i := start_idx; i <= end_idx; i++ {
		msg := messages[i]
		mut response := []string{}

		// Always include UID in FETCH responses
		response << 'UID ${msg.uid}'

		for item in items_to_fetch {
			match item {
				'FLAGS' {
					flags_str := if msg.flags.len > 0 {
						msg.flags.join(' ')
					} else {
						''
					}
					response << 'FLAGS (${flags_str})'
				}
				'INTERNALDATE' {
					response << 'INTERNALDATE "${msg.internal_date.str()}"'
				}
				'RFC822.SIZE' {
					response << 'RFC822.SIZE ${msg.body.len}'
				}
				'BODY[TEXT]' {
					// Mark message as seen unless using BODY.PEEK
					if !item.contains('.PEEK') {
						if '\\Seen' !in msg.flags {
							mut updated_msg := msg
							updated_msg.flags << '\\Seen'
							self.server.mailboxserver.message_set(self.username, self.mailbox,
								msg.uid, updated_msg) or {
								eprintln('Failed to update \\Seen flag: ${err}')
							}
						}
					}
					response << 'BODY[TEXT] {${msg.body.len}}\r\n${msg.body}'
				}
				'BODY[]', 'BODY.PEEK[]' {
					// Mark message as seen unless using BODY.PEEK
					if !item.contains('.PEEK') {
						if '\\Seen' !in msg.flags {
							mut updated_msg := msg
							updated_msg.flags << '\\Seen'
							self.server.mailboxserver.message_set(self.username, self.mailbox,
								msg.uid, updated_msg) or {
								eprintln('Failed to update \\Seen flag: ${err}')
							}
						}
					}
					// For BODY[], return the full message including headers
					mut full_msg := 'From: <>\r\n'
					full_msg += 'Subject: ${msg.subject}\r\n'
					full_msg += 'Date: ${msg.internal_date.str()}\r\n'
					full_msg += '\r\n' // Empty line between headers and body
					full_msg += msg.body
					response << 'BODY[] {${full_msg.len}}\r\n${full_msg}'
				}
				'BODY[HEADER]', 'BODY.PEEK[HEADER]' {
					// Return just the headers
					mut headers := 'From: <>\r\n'
					headers += 'Subject: ${msg.subject}\r\n'
					headers += 'Date: ${msg.internal_date.str()}\r\n'
					headers += '\r\n' // Empty line after headers
					response << 'BODY[HEADER] {${headers.len}}\r\n${headers}'
				}
				'ENVELOPE' {
					// Basic envelope with just subject for now
					response << 'ENVELOPE (NIL "${msg.subject}" NIL NIL NIL NIL NIL NIL NIL NIL)'
				}
				else {}
			}
		}

		self.conn.write('* ${i + 1} FETCH (${response.join(' ')})\r\n'.bytes())!
	}
	self.conn.write('${tag} OK FETCH completed\r\n'.bytes())!
}
