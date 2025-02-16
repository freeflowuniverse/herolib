module mailbox
import time

fn test_user_account_mailboxes() {
	mut account := UserAccount{
		name: 'testuser'
		description: 'Test User'
		emails: ['test@example.com']
	}

	// Test creating mailboxes
	inbox := account.create_mailbox('INBOX') or { panic(err) }
	assert inbox.name == 'INBOX'
	
	sent := account.create_mailbox('Sent') or { panic(err) }
	assert sent.name == 'Sent'

	// Test duplicate mailbox creation
	if _ := account.create_mailbox('INBOX') {
		panic('Expected error when creating duplicate mailbox')
	}

	// Test listing mailboxes
	boxes := account.list_mailboxes()
	assert boxes.len == 2
	assert 'INBOX' in boxes
	assert 'Sent' in boxes

	// Test getting mailbox
	found := account.get_mailbox('INBOX') or { panic(err) }
	assert found.name == 'INBOX'

	// Test getting non-existent mailbox
	if _ := account.get_mailbox('NonExistent') {
		panic('Expected error when getting non-existent mailbox')
	}

	// Test deleting mailbox
	account.delete_mailbox('Sent') or { panic(err) }
	boxes_after_delete := account.list_mailboxes()
	assert boxes_after_delete.len == 1
	assert 'Sent' !in boxes_after_delete
}

fn test_mail_server_accounts() {
	mut server := MailServer{}

	// Test creating accounts
	server.account_create('user1', 'First User', ['user1@example.com', 'user1.alt@example.com']) or { panic(err) }
	mut account1 := server.account_get('user1') or { panic(err) }
	assert account1.name == 'user1'
	assert account1.emails.len == 2

	// Verify INBOX was created automatically
	mut inbox := account1.get_mailbox('INBOX') or { panic(err) }
	assert inbox.name == 'INBOX'

	// Test creating account with duplicate username
	if _ := server.account_create('user1', 'Duplicate User', ['other@example.com']) {
		panic('Expected error when creating account with duplicate username')
	}

	// Test creating account with duplicate email
	if _ := server.account_create('user2', 'Second User', ['user1@example.com']) {
		panic('Expected error when creating account with duplicate email')
	}

	// Test creating another valid account
	server.account_create('user2', 'Second User', ['user2@example.com']) or { panic(err) }
	mut account2 := server.account_get('user2') or { panic(err) }
	assert account2.name == 'user2'

	// Test listing accounts
	accounts := server.account_list()
	assert accounts.len == 2
	assert 'user1' in accounts
	assert 'user2' in accounts

	// Test getting account
	mut found := server.account_get('user1') or { panic(err) }
	assert found.name == 'user1'
	assert found.emails == ['user1@example.com', 'user1.alt@example.com']

	// Test getting non-existent account
	if _ := server.account_get('nonexistent') {
		panic('Expected error when getting non-existent account')
	}

	// Test finding account by email
	found_by_email := server.account_find_by_email('user1.alt@example.com') or { panic(err) }
	assert found_by_email == 'user1'

	// Test finding non-existent email
	if _ := server.account_find_by_email('nonexistent@example.com') {
		panic('Expected error when finding non-existent email')
	}

	// Test deleting account
	server.account_delete('user2') or { panic(err) }
	accounts_after_delete := server.account_list()
	assert accounts_after_delete.len == 1
	assert 'user2' !in accounts_after_delete
}

fn test_end_to_end() {
	mut server := MailServer{}

	// Create account
	server.account_create('testuser', 'Test User', ['test@example.com']) or { panic(err) }
	mut account := server.account_get('testuser') or { panic(err) }

	// Get INBOX and add a message
	mut inbox := account.get_mailbox('INBOX') or { panic(err) }
	msg := Message{
		uid: 1
		subject: 'Test message'
		body: 'Hello world'
		flags: ['\\Seen']
	}
	inbox.set(1, msg) or { panic(err) }

	// Create Archives mailbox
	mut archives := account.create_mailbox('Archives') or { panic(err) }
	
	// Verify mailboxes through server lookup
	mut found_account := server.account_get('testuser') or { panic(err) }
	mailboxes := found_account.list_mailboxes()
	assert mailboxes.len == 2
	assert 'INBOX' in mailboxes
	assert 'Archives' in mailboxes

	// Verify message in INBOX
	mut found_inbox := found_account.get_mailbox('INBOX') or { panic(err) }
	msgs := found_inbox.list() or { panic(err) }
	assert msgs.len == 1
	assert msgs[0].subject == 'Test message'
}
