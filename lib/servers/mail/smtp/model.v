module smtp

import net
import io
import freeflowuniverse.herolib.servers.mail.mailbox

// SMTPServer wraps the mailbox server to provide SMTP functionality
@[heap]
pub struct SMTPServer {
pub mut:
	mailboxserver &mailbox.MailServer
}

// Session represents an active SMTP client connection
pub struct Session {
pub mut:
	server        &SMTPServer
	conn          net.TcpConn
	reader        &io.BufferedReader
	tls_active    bool
	helo_domain   string
	mail_from     string
	rcpt_to       []string
	data_mode     bool
	authenticated bool
	username      string
}

// State represents the current state of the SMTP session
enum State {
	initial
	helo
	mail
	rcpt
	data
	quit
}

// Response codes as defined in RFC 5321
// Positive completion replies
pub const reply_ready = 220 // Service ready

pub const reply_goodbye = 221 // Service closing transmission channel

pub const reply_ok = 250 // Requested mail action okay, completed

pub const reply_start_mail = 354 // Start mail input

// Permanent negative completion replies
pub const reply_syntax_error = 500 // Syntax error, command unrecognized

pub const reply_syntax_error_params = 501 // Syntax error in parameters

pub const reply_not_implemented = 502 // Command not implemented

pub const reply_bad_sequence = 503 // Bad sequence of commands

pub const reply_auth_required = 530 // Authentication required

pub const reply_mailbox_unavailable = 550 // Mailbox unavailable

pub const reply_user_not_local = 551 // User not local

pub const reply_storage_exceeded = 552 // Requested mail action aborted: exceeded storage allocation

pub const reply_name_not_allowed = 553 // Requested action not taken: mailbox name not allowed

pub const reply_transaction_failed = 554 // Transaction failed

// send_response sends a formatted SMTP response to the client
pub fn (mut self Session) send_response(code int, message string) ! {
	response := '${code} ${message}\r\n'
	self.conn.write(response.bytes())!
}

// reset_session resets the session state for a new mail transaction
pub fn (mut self Session) reset_session() {
	self.mail_from = ''
	self.rcpt_to = []string{}
	self.data_mode = false
}
