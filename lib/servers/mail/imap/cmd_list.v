module imap

import net

// handle_list processes the LIST command
// See RFC 3501 Section 6.3.9
pub fn (mut self Session) handle_list(tag string, parts []string) ! {
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

	// Handle % wildcard (single level)
	if pattern == '%' {
		// List top-level mailboxes
		for name, mbox in self.server.mailboxes {
			if !name.contains('/') { // Only top level
				mut attrs := []string{}
				if mbox.read_only {
					attrs << '\\ReadOnly'
				}
				// Add child status attributes
				mut has_children := false
				for other_name, _ in self.server.mailboxes {
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
		for name, mbox in self.server.mailboxes {
			mut attrs := []string{}
			if mbox.read_only {
				attrs << '\\ReadOnly'
			}
			// Add child status attributes
			mut has_children := false
			for other_name, _ in self.server.mailboxes {
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
	if pattern in self.server.mailboxes {
		mbox := self.server.mailboxes[pattern]
		mut attrs := []string{}
		if mbox.read_only {
			attrs << '\\ReadOnly'
		}
		// Add child status attributes
		mut has_children := false
		for other_name, _ in self.server.mailboxes {
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
