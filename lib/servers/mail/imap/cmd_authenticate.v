module imap

import net
import io
import freeflowuniverse.herolib.ui.console

// handle_authenticate processes the AUTHENTICATE command
pub fn (mut self Session) handle_authenticate(tag string, parts []string) ! {
	if parts.len < 3 {
		self.conn.write('${tag} BAD AUTHENTICATE requires an authentication mechanism\r\n'.bytes())!
		return
	}
	auth_type := parts[2].to_upper()
	if auth_type == 'PLAIN' {
		// Send continuation request for credentials
		self.conn.write('+ \r\n'.bytes())!
		// Read base64 credentials
		creds := self.reader.read_line() or {
			match err.msg() {
				'closed' {
					console.print_debug('Client disconnected during authentication')
					return error('client disconnected during auth')
				}
				'EOF' {
					console.print_debug('Client ended connection during authentication (EOF)')
					return error('connection ended during auth')
				}
				else {
					eprintln('Connection read error during authentication: $err')
					return error('connection error during auth: $err')
				}
			}
		}
		if creds.len > 0 {
			// For demo purposes, accept any credentials
			// After successful auth, remove STARTTLS and LOGINDISABLED capabilities
			self.capabilities = ['IMAP4rev2', 'AUTH=PLAIN']
			self.conn.write('${tag} OK [CAPABILITY IMAP4rev2 AUTH=PLAIN] Authentication successful\r\n'.bytes())!
		} else {
			self.conn.write('${tag} NO Authentication failed\r\n'.bytes())!
		}
	} else {
		self.conn.write('${tag} NO [ALERT] Unsupported authentication mechanism\r\n'.bytes())!
	}
}
