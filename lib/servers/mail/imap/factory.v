
module imap
import time
pub fn start()! {
	// Create the server and initialize an example INBOX.
	mut server := IMAPServer{
		mailboxes: map[string]&Mailbox{}
	}
	
	// Initialize INBOX with required IMAP4rev2 fields
	mut inbox := Mailbox{
		name: 'INBOX'
		next_uid: 3  // Since we have 2 messages
		uid_validity: u32(time.now().unix()) // Use current time as validity
		read_only: false
		messages: [
			Message{
				id: 1
				uid: 1
				subject: 'Welcome'
				body: 'Welcome to the IMAP server!'
				flags: ['\\Seen']
				internal_date: time.now()
			},
			Message{
				id: 2
				uid: 2
				subject: 'Update'
				body: 'This is an update.'
				flags: []
				internal_date: time.now()
			},
		]
	}
	
	// Store a pointer to the INBOX.
	server.mailboxes['INBOX'] = &inbox

	// Start the server (listening on port 143).
	server.run() or { eprintln('Server error: $err') }
}
