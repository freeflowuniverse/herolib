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

	// TODO: Implement actual authentication
	// For demo purposes, accept any username/password
	// In real implementation:
	// 1. Validate credentials
	// 2. If invalid, return: NO [AUTHENTICATIONFAILED] Authentication failed
	// 3. If valid but can't authorize, return: NO [AUTHORIZATIONFAILED] Authorization failed
	
	// After successful login:
	// 1. Send capabilities in OK response
	// 2. Don't include LOGINDISABLED or STARTTLS in capabilities after login
	self.conn.write('${tag} OK [CAPABILITY IMAP4rev2 AUTH=PLAIN] LOGIN completed\r\n'.bytes())!
}
