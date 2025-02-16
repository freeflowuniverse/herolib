module imap

import net
import strings
import freeflowuniverse.herolib.ui.console
import time
import io

// Run starts the server on port 143 and accepts client connections.
pub fn (mut server IMAPServer) start() ! {

	spawn daemon(mut server)
}

fn daemon(mut server IMAPServer) ! {

	addr := '0.0.0.0:143'
	mut listener := net.listen_tcp(.ip, addr, dualstack:true) or {
		return error('Failed to listen on $addr: $err')
	}
	println('IMAP Server listening on $addr')
	
	// Set TCP options for better reliability
	// listener.set_option_bool(.reuse_addr, true)
	
	for {
		mut conn := listener.accept() or {
			eprintln('Failed to accept connection: $err')
			continue
		}
		
		// Set connection options
		
		// conn.set_option_int(.tcp_keepalive, 60)!
		conn.set_read_timeout(30 * time.second)
		conn.set_write_timeout(30 * time.second)
		
		// Handle each connection concurrently
		spawn handle_connection(mut conn, mut server)
	}

}

// handle_connection processes commands from a connected client.
fn handle_connection(mut conn net.TcpConn, mut server IMAPServer) ! {
	// Send greeting per IMAP protocol.
	defer {
		conn.close() or { panic(err) }
	}
	conn.write('* OK [CAPABILITY IMAP4rev2 STARTTLS LOGINDISABLED AUTH=PLAIN] IMAP server ready\r\n'.bytes())!
	// Initially no mailbox is selected.
	mut selected_mailbox_name := ''
	mut res := false
	client_addr := conn.peer_addr()!
	console.print_debug('> new client: ${client_addr}')
	mut reader := io.new_buffered_reader(reader: conn)
	defer {
		unsafe {
			reader.free()
		}
	}	

	mut session:= Session{
		server: &server
		mailbox: ""
		conn: conn
		reader: reader
		tls_active: false
		capabilities: ['IMAP4rev2', 'STARTTLS', 'LOGINDISABLED', 'AUTH=PLAIN']
	}

	for {
		// Read a line (command) from the client.
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
		console.print_debug(line)
		trimmed := line.trim_space()
		if trimmed.len == 0 {
			continue
		}
		// Commands come with a tag followed by the command and parameters.
		parts := trimmed.split(' ')
		if parts.len < 2 {
			conn.write('${parts[0]} BAD Invalid command\r\n'.bytes())!
			continue
		}
		tag := parts[0]
		cmd := parts[1].to_upper()
		match cmd {
			'LOGIN' {
				session.handle_login(tag, parts )!
			}
			'AUTHENTICATE' {
				session.handle_authenticate(tag, parts)!
			}
			'SELECT' {
				session.handle_select(tag, parts)!
			}
			'FETCH' {
				session.handle_fetch(tag, parts) !
			}
			'STORE' {
				session.handle_store(tag, parts) !
			}
			'CAPABILITY' {
				session.handle_capability(tag) !
			}
			'LIST' {
				session.handle_list(tag, parts) !
			}
			'UID' {
				session.handle_uid(tag, parts) !
			}
			'CLOSE' {
				session.handle_close(tag) !
			}
			'LOGOUT' {
				session.handle_logout(tag) !
				return
			}
			else {
				conn.write('${tag} BAD Unknown command\r\n'.bytes())!
			}
		}
	}
}
