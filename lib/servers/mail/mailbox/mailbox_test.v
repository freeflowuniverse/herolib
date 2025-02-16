module mailbox

import time

fn test_mailbox_basic_operations() {
	mut mb := Mailbox{
		name: 'INBOX'
		uid_validity: 1234
	}

	// Test empty mailbox
	msgs := mb.list() or { panic(err) }
	assert msgs.len == 0

	// Test adding a message
	msg1 := Message{
		uid: 1
		subject: 'Test email'
		body: 'Hello world'
		flags: ['\\Seen']
		internal_date: time.now()
	}
	mb.set(1, msg1) or { panic(err) }

	// Test listing messages
	msgs2 := mb.list() or { panic(err) }
	assert msgs2.len == 1
	assert msgs2[0].subject == 'Test email'

	// Test getting message by UID
	found := mb.get(1) or { panic(err) }
	assert found.uid == 1
	assert found.subject == 'Test email'
	assert found.body == 'Hello world'
	assert found.flags == ['\\Seen']
}

fn test_mailbox_delete() {
	mut mb := Mailbox{
		name: 'INBOX'
		uid_validity: 1234
	}

	// Add two messages
	msg1 := Message{
		uid: 1
		subject: 'First email'
		body: 'Content 1'
	}
	msg2 := Message{
		uid: 2
		subject: 'Second email'
		body: 'Content 2'
	}
	mb.set(1, msg1) or { panic(err) }
	mb.set(2, msg2) or { panic(err) }

	// Delete first message
	mb.delete(1) or { panic(err) }

	// Verify only second message remains
	msgs := mb.list() or { panic(err) }
	assert msgs.len == 1
	assert msgs[0].uid == 2
	assert msgs[0].subject == 'Second email'

	// Test deleting non-existent message
	if _ := mb.delete(999) {
		panic('Expected error when deleting non-existent message')
	}
}

fn test_mailbox_find() {
	mut mb := Mailbox{
		name: 'INBOX'
		uid_validity: 1234
	}

	// Add test messages
	msg1 := Message{
		uid: 1
		subject: 'Important meeting'
		body: 'Meeting at 2 PM'
		flags: ['\\Seen', '\\Flagged']
	}
	msg2 := Message{
		uid: 2
		subject: 'Hello friend'
		body: 'How are you?'
		flags: ['\\Seen']
	}
	msg3 := Message{
		uid: 3
		subject: 'Another meeting'
		body: 'Team sync at 3 PM'
		flags: ['\\Draft']
	}
	
	mb.set(1, msg1) or { panic(err) }
	mb.set(2, msg2) or { panic(err) }
	mb.set(3, msg3) or { panic(err) }

	// Test finding by subject
	found_subject := mb.find(FindArgs{subject: 'meeting'}) or { panic(err) }
	assert found_subject.len == 2
	
	// Test finding by content
	found_content := mb.find(FindArgs{content: 'PM'}) or { panic(err) }
	assert found_content.len == 2

	// Test finding by flags
	found_flags := mb.find(FindArgs{flags: ['\\Seen', '\\Flagged']}) or { panic(err) }
	assert found_flags.len == 1
	assert found_flags[0].uid == 1

	// Test finding with multiple criteria
	found_multi := mb.find(FindArgs{
		subject: 'meeting'
		flags: ['\\Draft']
	}) or { panic(err) }
	assert found_multi.len == 1
	assert found_multi[0].uid == 3
}

fn test_readonly_mailbox() {
	mut mb := Mailbox{
		name: 'INBOX'
		uid_validity: 1234
		read_only: true
	}

	msg := Message{
		uid: 1
		subject: 'Test email'
		body: 'Hello world'
	}

	// Attempt to modify read-only mailbox should fail
	if _ := mb.set(1, msg) {
		panic('Expected error when modifying read-only mailbox')
	}
}
