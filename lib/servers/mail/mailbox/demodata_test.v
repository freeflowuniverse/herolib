module mailbox

fn new_mailserver() &MailServer {
	return &MailServer{
		accounts: map[string]&UserAccount{}
	}
}

fn test_demodata() ! {
	mut server := new_mailserver()
	server.demodata()!

	// Test user accounts
	usernames := ['user1', 'user2', 'user3', 'user4', 'user5']
	names := ['First User', 'Second User', 'Third User', 'Fourth User', 'Fifth User']

	for i, username in usernames {
		// Verify user account exists and properties are correct
		mut account := server.get_account(username)!
		assert account.name == username
		assert account.description == names[i]
		assert account.emails.len == 2
		assert account.emails[0] == '${username}@example.com'
		assert account.emails[1] == '${username}.alt@example.com'

		// Verify mailboxes exist
		mailboxes := account.list_mailboxes()
		assert mailboxes.len == 2
		assert mailboxes.contains('INBOX')
		assert mailboxes.contains('Sent')

		// Verify INBOX messages
		mut inbox := account.get_mailbox('INBOX')!
		messages := inbox.list()!
		assert messages.len == 10

		// Check specific properties of first and last INBOX messages
		first_msg := inbox.get(messages[0].uid)!
		assert first_msg.subject == 'Inbox Message 1'
		assert first_msg.body == 'This is inbox message 1 for ${username}'
		assert first_msg.flags == ['\\Seen']

		last_msg := inbox.get(messages[9].uid)!
		assert last_msg.subject == 'Inbox Message 10'
		assert last_msg.body == 'This is inbox message 10 for ${username}'
		assert last_msg.flags == if 9 % 2 == 0 { ['\\Seen'] } else { [] }

		// Verify Sent messages
		mut sent := account.get_mailbox('Sent')!
		sent_messages := sent.list()!
		assert sent_messages.len == 10

		// Check specific properties of first and last Sent messages
		first_sent := sent.get(sent_messages[0].uid)!
		assert first_sent.subject == 'Sent Message 1'
		assert first_sent.body == 'This is sent message 1 from ${username}'
		assert first_sent.flags == ['\\Seen']

		last_sent := sent.get(sent_messages[9].uid)!
		assert last_sent.subject == 'Sent Message 10'
		assert last_sent.body == 'This is sent message 10 from ${username}'
		assert last_sent.flags == ['\\Seen']
	}
}
