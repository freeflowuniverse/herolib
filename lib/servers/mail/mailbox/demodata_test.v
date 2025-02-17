module mailbox

fn test_demodata() {
	mut server := new()
	server.demodata()!

	// Test user accounts
	usernames := ['user1', 'user2', 'user3', 'user4', 'user5']
	names := ['First User', 'Second User', 'Third User', 'Fourth User', 'Fifth User']

	for i, username in usernames {
		// Verify user exists by checking email
		primary_email := '${username}@example.com'
		found_username := server.account_find_by_email(primary_email) or { panic(err) }
		assert found_username == username

		alt_email := '${username}.alt@example.com'
		found_username_alt := server.account_find_by_email(alt_email) or { panic(err) }
		assert found_username_alt == username

		// Verify mailboxes exist
		mailboxes := server.mailbox_list(username) or { panic(err) }
		assert mailboxes.len == 2
		assert 'INBOX' in mailboxes
		assert 'Sent' in mailboxes

		// Verify INBOX messages
		inbox_messages := server.message_list(username, 'INBOX') or { panic(err) }
		assert inbox_messages.len == 10

		// Check specific properties of first and last INBOX messages
		first_msg := server.message_get(username, 'INBOX', u32(1)) or { panic(err) }
		assert first_msg.subject == 'Inbox Message 1'
		assert first_msg.body == 'This is inbox message 1 for ${username}'
		assert first_msg.flags == ['\\Seen']

		last_msg := server.message_get(username, 'INBOX', u32(10)) or { panic(err) }
		assert last_msg.subject == 'Inbox Message 10'
		assert last_msg.body == 'This is inbox message 10 for ${username}'
		assert last_msg.flags == if 9 % 2 == 0 {
			['\\Seen']
		} else {
			[]
		}

		// Verify Sent messages
		sent_messages := server.message_list(username, 'Sent') or { panic(err) }
		assert sent_messages.len == 10

		// Check specific properties of first and last Sent messages
		first_sent := server.message_get(username, 'Sent', u32(1)) or { panic(err) }
		assert first_sent.subject == 'Sent Message 1'
		assert first_sent.body == 'This is sent message 1 from ${username}'
		assert first_sent.flags == ['\\Seen']

		last_sent := server.message_get(username, 'Sent', u32(10)) or { panic(err) }
		assert last_sent.subject == 'Sent Message 10'
		assert last_sent.body == 'This is sent message 10 from ${username}'
		assert last_sent.flags == ['\\Seen']
	}
}
