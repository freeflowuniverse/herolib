module smtp

import freeflowuniverse.herolib.servers.mail.mailbox

pub fn new(mailboxserver &mailbox.MailServer) !SMTPServer {
	mut server := SMTPServer{
		mailboxserver: mailboxserver
	}
	return server
}
