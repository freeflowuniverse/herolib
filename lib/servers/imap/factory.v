
module imap

pub fn start()! {
	// Create the server and initialize an example INBOX.
	mut server := IMAPServer{
		mailboxes: map[string]&Mailbox{}
	}
	mut inbox := Mailbox{
		name: 'INBOX'
		messages: [
			Message{
				id: 1
				subject: 'Welcome'
				body: 'Welcome to the IMAP server!'
				flags: ['\\Seen']
			},
			Message{
				id: 2
				subject: 'Update'
				body: 'This is an update.'
				flags: []
			},
		]
	}
	// Store a pointer to the INBOX.
	server.mailboxes['INBOX'] = &inbox

	// Start the server (listening on port 143).
	server.run() or { eprintln('Server error: $err') }
}
