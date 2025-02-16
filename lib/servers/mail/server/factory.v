
module imap
import time

import freeflowuniverse.herolib.servers.mail.mailbox

pub fn start_demo()! {
	// Create the server and initialize an example INBOX.

	mut mailboxserver:=mailbox.new_with_demo_data()



}
