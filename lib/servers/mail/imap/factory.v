module imap

import time
import freeflowuniverse.herolib.servers.mail.mailbox

pub fn new(mailboxserver &mailbox.MailServer) !IMAPServer {
	mut server := IMAPServer{
		mailboxserver: mailboxserver
	}

	return server
}
