module smtp

import net
import io
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.servers.mail.mailbox
import time


// start starts the SMTP server on port 25 and accepts client connections
pub fn (mut server SMTPServer) start() ! {
	spawn daemon(mut server)
}

fn daemon(mut server SMTPServer) ! {

	addr := '0.0.0.0:25'
	mut listener := net.listen_tcp(.ip, addr, dualstack: true) or {
		return error('Failed to listen on $addr: $err')
	}
	println('SMTP Server listening on $addr')

	for {
		mut conn := listener.accept() or {
			eprintln('Failed to accept connection: $err')
			continue
		}

		conn.set_read_timeout(30 * time.second)
		conn.set_write_timeout(30 * time.second)

		spawn handle_connection(mut conn, mut server)
	}
}

// handle_connection processes commands from a connected SMTP client
fn handle_connection(mut conn net.TcpConn, mut server SMTPServer) ! {
	defer {
		conn.close() or { panic(err) }
	}

	mut reader := io.new_buffered_reader(reader: conn)
	defer {
		unsafe {
			reader.free()
		}
	}

	mut session := Session{
		server: &server
		conn: conn
		reader: reader
		tls_active: false
		authenticated: false
	}

	client_addr := conn.peer_addr()!
	console.print_debug('> new SMTP client: ${client_addr}')

	// Send initial greeting
	session.send_response(smtp.reply_ready, 'SMTP server ready')!

	for {
		// Read a line (command) from the client
		line := reader.read_line() or {
			match err.msg() {
				'closed' {
					console.print_debug('Client disconnected normally')
					return error('client disconnected')
				}
				'EOF' {
					console.print_debug('Client connection ended (EOF)')
					return error('connection ended')
				}
				else {
					eprintln('Connection read error: $err')
					return error('connection error: $err')
				}
			}
		}

		console.print_debug('< ${line}')
		trimmed := line.trim_space()
		if trimmed.len == 0 {
			continue
		}

		if session.data_mode {
			handle_data_content(mut session, trimmed)!
			continue
		}

		// Parse command and parameters
		parts := trimmed.split(' ')
		cmd := parts[0].to_upper()

		match cmd {
			'HELO', 'EHLO' {
				handle_helo(mut session, parts)!
			}
			'MAIL' {
				handle_mail(mut session, parts)!
			}
			'RCPT' {
				handle_rcpt(mut session, parts)!
			}
			'DATA' {
				handle_data(mut session)!
			}
			'RSET' {
				handle_rset(mut session)!
			}
			'QUIT' {
				handle_quit(mut session)!
				return
			}
			'AUTH' {
				handle_auth(mut session, parts)!
			}
			'NOOP' {
				session.send_response(smtp.reply_ok, 'OK')!
			}
			else {
				session.send_response(smtp.reply_syntax_error, 'Command not recognized')!
			}
		}
	}
}

// handle_helo processes HELO/EHLO commands
fn handle_helo(mut session Session, parts []string) ! {
	if parts.len < 2 {
		session.send_response(smtp.reply_syntax_error_params, 'Missing domain parameter')!
		return
	}

	session.helo_domain = parts[1]
	mut capabilities := ['8BITMIME', 'PIPELINING']
	
	if !session.tls_active {
		capabilities << 'STARTTLS'
	}
	if !session.authenticated {
		capabilities << 'AUTH PLAIN LOGIN'
	}

	if parts[0].to_upper() == 'EHLO' {
		// Send multi-line EHLO response
		session.send_response(smtp.reply_ok, '${session.helo_domain}')!
		for cap in capabilities {
			session.conn.write('250-${cap}\r\n'.bytes())!
		}
		session.conn.write('250 HELP\r\n'.bytes())!
	} else {
		// Simple HELO response
		session.send_response(smtp.reply_ok, '${session.helo_domain}')!
	}
}

// handle_mail processes MAIL FROM command
fn handle_mail(mut session Session, parts []string) ! {
	if session.helo_domain == '' {
		session.send_response(smtp.reply_bad_sequence, 'Please send HELO/EHLO first')!
		return
	}

	if parts.len < 2 {
		session.send_response(smtp.reply_syntax_error_params, 'Missing FROM parameter')!
		return
	}

	from_part := parts[1].to_upper()
	if !from_part.starts_with('FROM:') {
		session.send_response(smtp.reply_syntax_error_params, 'Syntax error in FROM parameter')!
		return
	}

	// Extract email address from <...>
	addr_start := from_part.index('<') or { -1 }
	addr_end := from_part.last_index('>') or { -1 }
	if addr_start == -1 || addr_end == -1 || addr_start >= addr_end {
		session.send_response(smtp.reply_syntax_error_params, 'Invalid email address format')!
		return
	}

	session.mail_from = from_part[addr_start + 1..addr_end]
	session.send_response(smtp.reply_ok, 'OK')!
}

// handle_rcpt processes RCPT TO command
fn handle_rcpt(mut session Session, parts []string) ! {
	if session.mail_from == '' {
		session.send_response(smtp.reply_bad_sequence, 'Need MAIL FROM command first')!
		return
	}

	if parts.len < 2 {
		session.send_response(smtp.reply_syntax_error_params, 'Missing TO parameter')!
		return
	}

	to_part := parts[1].to_upper()
	if !to_part.starts_with('TO:') {
		session.send_response(smtp.reply_syntax_error_params, 'Syntax error in TO parameter')!
		return
	}

	// Extract email address from <...>
	addr_start := to_part.index('<') or { -1 }
	addr_end := to_part.last_index('>') or { -1 }
	if addr_start == -1 || addr_end == -1 || addr_start >= addr_end {
		session.send_response(smtp.reply_syntax_error_params, 'Invalid email address format')!
		return
	}

	rcpt_addr := to_part[addr_start + 1..addr_end]
	
	// Verify recipient exists in mailbox server
	username := session.server.mailboxserver.account_find_by_email(rcpt_addr) or {
		session.send_response(smtp.reply_mailbox_unavailable, 'No such user here')!
		return
	}

	session.rcpt_to << rcpt_addr
	session.send_response(smtp.reply_ok, 'OK')!
}

// handle_data processes DATA command
fn handle_data(mut session Session) ! {
	if session.rcpt_to.len == 0 {
		session.send_response(smtp.reply_bad_sequence, 'Need RCPT TO command first')!
		return
	}

	session.data_mode = true
	session.send_response(smtp.reply_start_mail, 'Start mail input; end with <CRLF>.<CRLF>')!
}

// handle_data_content processes the email content after DATA command
fn handle_data_content(mut session Session, line string) ! {
	if line == '.' {
		// End of data
		session.data_mode = false

		// Store message for each recipient
		for rcpt in session.rcpt_to {
			username := session.server.mailboxserver.account_find_by_email(rcpt) or {
				eprintln('Failed to find recipient ${rcpt}')
				continue
			}

			// Create message in recipient's INBOX
			mut msg := mailbox.Message{
				uid: 0 // Will be assigned by mailbox
				subject: 'New message' // TODO: Parse subject from headers
				body: line // TODO: Accumulate message body
				flags: []string{} // No flags initially
				internal_date: time.now()
			}
			session.server.mailboxserver.message_set(username, 'INBOX', 0, msg) or {
				eprintln('Failed to store message for ${username}: ${err}')
				session.send_response(smtp.reply_transaction_failed, 'Failed to store message')!
				return
			}
		}

		session.send_response(smtp.reply_ok, 'OK')!
		session.reset_session()
		return
	}

	// TODO: Accumulate message body
	// For now we just acknowledge the line
}

// handle_rset processes RSET command
fn handle_rset(mut session Session) ! {
	session.reset_session()
	session.send_response(smtp.reply_ok, 'OK')!
}

// handle_quit processes QUIT command
fn handle_quit(mut session Session) ! {
	session.send_response(smtp.reply_goodbye, 'Goodbye')!
}

// handle_auth processes AUTH command
fn handle_auth(mut session Session, parts []string) ! {
	if parts.len < 2 {
		session.send_response(smtp.reply_syntax_error_params, 'Missing authentication type')!
		return
	}

	auth_type := parts[1].to_upper()
	if auth_type !in ['PLAIN', 'LOGIN'] {
		session.send_response(smtp.reply_syntax_error_params, 'Unsupported authentication type')!
		return
	}

	// For demo purposes, accept any credentials
	if auth_type == 'PLAIN' {
		if parts.len < 3 {
			session.send_response(smtp.reply_syntax_error_params, 'Missing credentials')!
			return
		}
		// In real implementation, decode base64 credentials and validate
		session.authenticated = true
		session.send_response(smtp.reply_ok, 'Authentication successful')!
	} else { // LOGIN
		// Send username prompt
		session.conn.write('334 VXNlcm5hbWU6\r\n'.bytes())! // Base64 encoded "Username:"
		username := session.reader.read_line()!
		
		// Send password prompt
		session.conn.write('334 UGFzc3dvcmQ6\r\n'.bytes())! // Base64 encoded "Password:"
		password := session.reader.read_line()!

		// For demo purposes, accept any credentials
		session.authenticated = true
		session.username = username // Store for potential use
		session.send_response(smtp.reply_ok, 'Authentication successful')!
	}
}
