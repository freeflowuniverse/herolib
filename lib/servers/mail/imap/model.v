module imap
import net
import io
import time

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
	username     string                  // Currently logged in user
	account      &mailbox.UserAccount   // Current user's account
	mailbox      string                 // Currently selected mailbox name
	conn         net.TcpConn
	reader       &io.BufferedReader
	tls_active   bool                   // Whether TLS is active on the connection
	capabilities []string               // Current capabilities for this session
}

// mailbox_new creates a new mailbox for the current user
pub fn (mut self Session) mailbox_new(name string) !&mailbox.Mailbox {
	if self.account == unsafe { nil } {
		return error('No user logged in')
	}
	return self.account.create_mailbox(name)
}

// mailbox returns the currently selected mailbox
pub fn (mut self Session) mailbox() !&mailbox.Mailbox {
	if self.account == unsafe { nil } {
		return error('No user logged in')
	}
	if self.mailbox == '' {
		return error('No mailbox selected')
	}
	return self.account.get_mailbox(self.mailbox)
}
