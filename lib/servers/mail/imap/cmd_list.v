module imap

import net

// handle_list processes the LIST command
// See RFC 3501 Section 6.3.9
pub fn (mut self Session) handle_list(tag string, parts []string) ! {
	// Check if user is logged in
	if self.username == '' {
		self.conn.write('${tag} NO Must be logged in first\r\n'.bytes())!
		return error('Not logged in')
	}

	if parts.len < 4 {
		self.conn.write('${tag} BAD LIST requires reference name and mailbox name\r\n'.bytes())!
		return
	}

	reference := parts[2].trim('"')
	pattern := parts[3].trim('"')

	// For now, we only support empty reference and simple patterns
	if reference != '' && reference != 'INBOX' {
		// Just return OK with no results for unsupported references
		self.conn.write('${tag} OK LIST completed\r\n'.bytes())!
		return
	}

	// Handle special case of empty mailbox name
	if pattern == '' {
		// Return hierarchy delimiter and root name
		self.conn.write('* LIST (\\Noselect) "/" ""\r\n'.bytes())!
		self.conn.write('${tag} OK LIST completed\r\n'.bytes())!
		return
	}

	// Get list of mailboxes for the user using mailbox module
	mailbox_names := self.server.mailboxserver.mailbox_list(self.username) or {
		self.conn.write('${tag} NO Failed to list mailboxes\r\n'.bytes())!
		return error('Failed to list mailboxes: ${err}')
	}

	// Handle % wildcard (single level)
	if pattern == '%' {
		// List top-level mailboxes
		for name in mailbox_names {
			if !name.contains('/') { // Only top level
				// Since we don't have direct access to read-only status, use basic attributes
				mut attrs := []string{}

				// Add child status attributes
				mut has_children := false
				for other_name in mailbox_names {
					if other_name.starts_with(name + '/') {
						has_children = true
						break
					}
				}
				if has_children {
					attrs << '\\HasChildren'
				} else {
					attrs << '\\HasNoChildren'
				}
				attr_str := if attrs.len > 0 { '(${attrs.join(' ')})' } else { '()' }
				self.conn.write('* LIST ${attr_str} "/" "${name}"\r\n'.bytes())!
			}
		}
		self.conn.write('${tag} OK LIST completed\r\n'.bytes())!
		return
	}

	// Handle * wildcard (multiple levels)
	if pattern == '*' {
		// List all mailboxes
		for name in mailbox_names {
			// Since we don't have direct access to read-only status, use basic attributes
			mut attrs := []string{}

			// Add child status attributes
			mut has_children := false
			for other_name in mailbox_names {
				if other_name.starts_with(name + '/') {
					has_children = true
					break
				}
			}
			if has_children {
				attrs << '\\HasChildren'
			} else {
				attrs << '\\HasNoChildren'
			}
			attr_str := if attrs.len > 0 { '(${attrs.join(' ')})' } else { '()' }
			self.conn.write('* LIST ${attr_str} "/" "${name}"\r\n'.bytes())!
		}
		self.conn.write('${tag} OK LIST completed\r\n'.bytes())!
		return
	}

	// Handle exact mailbox name
	if pattern in mailbox_names {
		// Since we don't have direct access to read-only status, use basic attributes
		mut attrs := []string{}

		// Add child status attributes
		mut has_children := false
		for other_name in mailbox_names {
			if other_name.starts_with(pattern + '/') {
				has_children = true
				break
			}
		}
		if has_children {
			attrs << '\\HasChildren'
		} else {
			attrs << '\\HasNoChildren'
		}
		attr_str := if attrs.len > 0 { '(${attrs.join(' ')})' } else { '()' }
		self.conn.write('* LIST ${attr_str} "/" "${pattern}"\r\n'.bytes())!
	}

	self.conn.write('${tag} OK LIST completed\r\n'.bytes())!
}
