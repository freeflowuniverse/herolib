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
	server       &SMTPServer
	conn         net.TcpConn
	reader       &io.BufferedReader
	tls_active   bool
	helo_domain  string
	mail_from    string
	rcpt_to      []string
	data_mode    bool
	authenticated bool
	username     string
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
pub const (
	// Positive completion replies
	reply_ready = 220 // Service ready
	reply_goodbye = 221 // Service closing transmission channel
	reply_ok = 250 // Requested mail action okay, completed
	reply_start_mail = 354 // Start mail input

	// Permanent negative completion replies
	reply_syntax_error = 500 // Syntax error, command unrecognized
	reply_syntax_error_params = 501 // Syntax error in parameters
	reply_not_implemented = 502 // Command not implemented
	reply_bad_sequence = 503 // Bad sequence of commands
	reply_auth_required = 530 // Authentication required
	reply_mailbox_unavailable = 550 // Mailbox unavailable
	reply_user_not_local = 551 // User not local
	reply_storage_exceeded = 552 // Requested mail action aborted: exceeded storage allocation
	reply_name_not_allowed = 553 // Requested action not taken: mailbox name not allowed
	reply_transaction_failed = 554 // Transaction failed
)

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
