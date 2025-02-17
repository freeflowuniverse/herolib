module imap

import net

// handle_capability processes the CAPABILITY command
// See RFC 3501 Section 6.1.1
pub fn (mut self Session) handle_capability(tag string) ! {
	mut capabilities := []string{}

	// IMAP4rev2 is required and must be included
	capabilities << 'IMAP4rev2'

	// Required capabilities on cleartext ports
	if !self.tls_active {
		capabilities << 'STARTTLS'
		capabilities << 'LOGINDISABLED'
	}

	// Required AUTH capability
	capabilities << 'AUTH=PLAIN'

	// Send capabilities in untagged response
	// Note: IMAP4rev2 doesn't need to be first, but must be included
	self.conn.write('* CAPABILITY ${capabilities.join(' ')}\r\n'.bytes())!

	// Send tagged OK response
	self.conn.write('${tag} OK CAPABILITY completed\r\n'.bytes())!
}
