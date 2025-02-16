module imap

import net

// handle_capability processes the CAPABILITY command
pub fn handle_capability(mut conn net.TcpConn, tag string) ! {
	conn.write('* CAPABILITY IMAP4rev1 AUTH=PLAIN STARTTLS LOGIN\r\n'.bytes())!
	conn.write('${tag} OK Completed\r\n'.bytes())!
}
