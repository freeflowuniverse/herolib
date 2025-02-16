module imap

import net
import io
import freeflowuniverse.herolib.servers.mail.mailbox

// IMAPServer wraps the mailbox server to provide IMAP functionality
@[heap]
pub struct IMAPServer {
pub mut:
	mailboxserver &mailbox.MailServer
}

// Session represents an active IMAP client connection
pub struct Session {
pub mut:
	server       &IMAPServer
	username     string // Currently logged in user
	mailbox      string // Currently selected mailbox name
	conn         net.TcpConn
	reader       &io.BufferedReader
	tls_active   bool     // Whether TLS is active on the connection
	capabilities []string // Current capabilities for this session
}

// mailbox_new creates a new mailbox for the current user
pub fn (mut self Session) mailbox_new(name string) ! {
	if self.username == '' {
		return error('No user logged in')
	}
	self.server.mailboxserver.mailbox_create(self.username, name)!
}

// mailbox_exists checks if the currently selected mailbox exists
pub fn (mut self Session) mailbox_exists() bool {
	if self.username == '' || self.mailbox == '' {
		return false
	}
	mailboxes := self.server.mailboxserver.mailbox_list(self.username) or { return false }
	return self.mailbox in mailboxes
}
