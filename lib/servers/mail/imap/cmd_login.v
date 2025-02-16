module imap

import net

// handle_login processes the LOGIN command
// See RFC 3501 Section 6.2.3
pub fn (mut self Session) handle_login(tag string, parts []string) ! {
	// Check if LOGINDISABLED is advertised
	if self.capabilities.contains('LOGINDISABLED') {
		self.conn.write('${tag} NO [PRIVACYREQUIRED] LOGIN disabled\r\n'.bytes())!
		return
	}

	if parts.len < 4 {
		self.conn.write('${tag} BAD LOGIN requires username and password\r\n'.bytes())!
		return
	}

	username := parts[2]
	password := parts[3]

	// For demo purposes, accept any username and look it up in the mailbox server
	// In a real implementation, we would validate the password here
	
	// Try to find existing account by email
	email := '${username}@example.com'
	existing_username := self.server.mailboxserver.account_find_by_email(email) or {
		// Create a new account if not found
		self.server.mailboxserver.account_create(username, username, ['${username}@example.com']) or {
			self.conn.write('${tag} NO [AUTHENTICATIONFAILED] Failed to create account\r\n'.bytes())!
			return
		}
		username // Return the new username
	}

	self.username = existing_username
	
	// Update capabilities - remove LOGINDISABLED and STARTTLS after login
	self.capabilities = self.capabilities.filter(it != 'LOGINDISABLED' && it != 'STARTTLS')
	
	// Send OK response with updated capabilities
	self.conn.write('${tag} OK [CAPABILITY ${self.capabilities.join(' ')}] LOGIN completed\r\n'.bytes())!
}
