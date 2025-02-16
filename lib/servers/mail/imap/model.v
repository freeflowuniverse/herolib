module imap
import net
import io
import time


// Our in-memory server holds a map of mailbox names to pointers to Mailbox.
@[heap]
pub struct IMAPServer {
pub mut:
	mailboxes map[string]&Mailbox
}

pub struct Session {
pub mut:
	server       &IMAPServer
	mailbox      string      // The name of the mailbox
	conn         net.TcpConn
	reader       &io.BufferedReader
	tls_active   bool        // Whether TLS is active on the connection
	capabilities []string    // Current capabilities for this session
}


pub fn (mut self Session) mailbox_new(name string) !&Mailbox {
	self.server.mailboxes[name] = &Mailbox{name:name}
	return self.server.mailboxes[name]
}

pub fn (mut self Session) mailbox() !&Mailbox {
	if !(self.mailbox in self.server.mailboxes) {
		return error("mailbox ${self.mailbox} does not exist")
	}
	return self.server.mailboxes[self.mailbox] or { panic("bug") }
}
