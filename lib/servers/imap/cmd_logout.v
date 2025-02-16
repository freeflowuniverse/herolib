module imap

import net

// handle_logout processes the LOGOUT command
pub fn  (mut self Session) handle_logout(mut conn net.TcpConn, tag string) ! {
	conn.write('* BYE IMAP4rev1 Server logging out\r\n'.bytes())!
	conn.write('${tag} OK LOGOUT completed\r\n'.bytes())!
}
