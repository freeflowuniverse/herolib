module imap

import net

// handle_uid processes the UID command
// See RFC 3501 Section 6.4.9
pub fn (mut self Session) handle_uid(tag string, parts []string) ! {
	if parts.len < 3 {
		self.conn.write('${tag} BAD UID requires a command\r\n'.bytes())!
		return
	}

	subcmd := parts[2].to_upper()
	match subcmd {
		'FETCH' {
			// Remove 'UID' from parts and pass to handle_fetch
			// The handle_fetch implementation already includes UIDs in responses
			mut fetch_parts := parts.clone()
			fetch_parts.delete(1) // Remove 'UID'
			self.handle_fetch(tag, fetch_parts)!
		}
		'SEARCH' {
			// Remove 'UID' from parts and pass to handle_search
			mut search_parts := parts.clone()
			search_parts.delete(1) // Remove 'UID'
			// TODO: Implement handle_search
			self.conn.write('${tag} NO SEARCH not implemented\r\n'.bytes())!
		}
		'STORE' {
			// Remove 'UID' from parts and pass to handle_store
			mut store_parts := parts.clone()
			store_parts.delete(1) // Remove 'UID'
			self.handle_store(tag, store_parts)!
		}
		'COPY' {
			// Remove 'UID' from parts and pass to handle_copy
			mut copy_parts := parts.clone()
			copy_parts.delete(1) // Remove 'UID'
			// TODO: Implement handle_copy
			self.conn.write('${tag} NO COPY not implemented\r\n'.bytes())!
		}
		'EXPUNGE' {
			// Remove 'UID' from parts and pass to handle_expunge
			mut expunge_parts := parts.clone()
			expunge_parts.delete(1) // Remove 'UID'
			// TODO: Implement handle_expunge
			self.conn.write('${tag} NO EXPUNGE not implemented\r\n'.bytes())!
		}
		else {
			self.conn.write('${tag} BAD Unknown UID command\r\n'.bytes())!
		}
	}
}
