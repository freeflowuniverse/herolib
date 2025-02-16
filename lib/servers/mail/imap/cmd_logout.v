module imap

import net

// handle_logout processes the LOGOUT command
pub fn (mut self Session) handle_logout(tag string) ! {
	self.conn.write('* BYE IMAP4rev2 Server logging out\r\n'.bytes())!
	self.conn.write('${tag} OK LOGOUT completed\r\n'.bytes())!
}
