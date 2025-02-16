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
	if username in self.server.mailboxserver.accounts {
		self.username = username
		self.account = self.server.mailboxserver.accounts[username]
		
		// Update capabilities - remove LOGINDISABLED and STARTTLS after login
		self.capabilities = self.capabilities.filter(it != 'LOGINDISABLED' && it != 'STARTTLS')
		
		// Send OK response with updated capabilities
		self.conn.write('${tag} OK [CAPABILITY ${self.capabilities.join(' ')}] LOGIN completed\r\n'.bytes())!
	} else {
		// Create a new account for demo purposes
		// In a real implementation, this would return an authentication error
		mut account := self.server.mailboxserver.create_account(username, username, ['${username}@example.com']) or {
			self.conn.write('${tag} NO [AUTHENTICATIONFAILED] Failed to create account\r\n'.bytes())!
			return
		}
		self.username = username
		self.account = account
		
		// Update capabilities - remove LOGINDISABLED and STARTTLS after login
		self.capabilities = self.capabilities.filter(it != 'LOGINDISABLED' && it != 'STARTTLS')
		
		// Send OK response with updated capabilities
		self.conn.write('${tag} OK [CAPABILITY ${self.capabilities.join(' ')}] LOGIN completed\r\n'.bytes())!
	}
}
