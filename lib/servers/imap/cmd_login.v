module imap

import net

// handle_login processes the LOGIN command
pub fn  (mut self Session) handle_login(mut conn net.TcpConn, tag string, parts []string, server &IMAPServer) ! {
	if parts.len < 4 {
		conn.write('${tag} BAD LOGIN requires username and password\r\n'.bytes())!
		return
	}
	// For demo purposes, accept any username/password
	conn.write('${tag} OK [CAPABILITY IMAP4rev1 AUTH=PLAIN] User logged in\r\n'.bytes())!
}
