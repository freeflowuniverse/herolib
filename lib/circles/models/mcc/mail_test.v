module mcc

import freeflowuniverse.herolib.data.ourtime

fn test_email_serialization() {
	// Create a test email with all fields populated
	mut email := Email{
		uid: 123
		seq_num: 456
		mailbox: 'INBOX'
		message: 'This is a test email message.\nWith multiple lines.\nFor testing purposes.'
		flags: ['\\\\Seen', '\\\\Flagged']
		internal_date: 1615478400 // March 11, 2021
		size: 0 // Will be calculated
	}

	// Add an attachment
	email.attachments << Attachment{
		filename: 'test.txt'
		content_type: 'text/plain'
		data: 'VGhpcyBpcyBhIHRlc3QgYXR0YWNobWVudC4=' // Base64 encoded "This is a test attachment."
	}

	// Add envelope information
	email.envelope = Envelope{
		date: 1615478400 // March 11, 2021
		subject: 'Test Email Subject'
		from: ['sender@example.com']
		sender: ['sender@example.com']
		reply_to: ['sender@example.com']
		to: ['recipient1@example.com', 'recipient2@example.com']
		cc: ['cc@example.com']
		bcc: ['bcc@example.com']
		in_reply_to: '<previous-message-id@example.com>'
		message_id: '<message-id@example.com>'
	}

	// Serialize the email
	binary_data := email.dumps() or {
		assert false, 'Failed to encode email: ${err}'
		return
	}

	// Deserialize the email
	decoded_email := email_loads(binary_data) or {
		assert false, 'Failed to decode email: ${err}'
		return
	}

	// Verify the decoded data matches the original
	assert decoded_email.uid == email.uid
	assert decoded_email.seq_num == email.seq_num
	assert decoded_email.mailbox == email.mailbox
	assert decoded_email.message == email.message
	assert decoded_email.flags.len == email.flags.len
	assert decoded_email.flags[0] == email.flags[0]
	assert decoded_email.flags[1] == email.flags[1]
	assert decoded_email.internal_date == email.internal_date
	
	// Verify attachment data
	assert decoded_email.attachments.len == email.attachments.len
	assert decoded_email.attachments[0].filename == email.attachments[0].filename
	assert decoded_email.attachments[0].content_type == email.attachments[0].content_type
	assert decoded_email.attachments[0].data == email.attachments[0].data
	
	// Verify envelope data
	if envelope := decoded_email.envelope {
		assert envelope.date == email.envelope?.date
		assert envelope.subject == email.envelope?.subject
		assert envelope.from.len == email.envelope?.from.len
		assert envelope.from[0] == email.envelope?.from[0]
		assert envelope.to.len == email.envelope?.to.len
		assert envelope.to[0] == email.envelope?.to[0]
		assert envelope.to[1] == email.envelope?.to[1]
		assert envelope.cc.len == email.envelope?.cc.len
		assert envelope.cc[0] == email.envelope?.cc[0]
		assert envelope.bcc.len == email.envelope?.bcc.len
		assert envelope.bcc[0] == email.envelope?.bcc[0]
		assert envelope.in_reply_to == email.envelope?.in_reply_to
		assert envelope.message_id == email.envelope?.message_id
	} else {
		assert false, 'Envelope is missing in decoded email'
	}
}

fn test_email_without_envelope() {
	// Create a test email without an envelope
	mut email := Email{
		uid: 789
		seq_num: 101
		mailbox: 'Sent'
		message: 'Simple message without envelope'
		flags: ['\\\\Seen']
		internal_date: 1615478400
	}

	// Serialize the email
	binary_data := email.dumps() or {
		assert false, 'Failed to encode email without envelope: ${err}'
		return
	}

	// Deserialize the email
	decoded_email := email_loads(binary_data) or {
		assert false, 'Failed to decode email without envelope: ${err}'
		return
	}

	// Verify the decoded data matches the original
	assert decoded_email.uid == email.uid
	assert decoded_email.seq_num == email.seq_num
	assert decoded_email.mailbox == email.mailbox
	assert decoded_email.message == email.message
	assert decoded_email.flags.len == email.flags.len
	assert decoded_email.flags[0] == email.flags[0]
	assert decoded_email.internal_date == email.internal_date
	assert decoded_email.envelope == none
}

fn test_email_helper_methods() {
	// Create a test email with envelope
	mut email := Email{
		uid: 123
		seq_num: 456
		mailbox: 'INBOX'
		message: 'Test message'
		envelope: Envelope{
			subject: 'Test Subject'
			from: ['sender@example.com']
			to: ['recipient@example.com']
			cc: ['cc@example.com']
			bcc: ['bcc@example.com']
			date: 1615478400
		}
	}

	// Test helper methods
	assert email.subject() == 'Test Subject'
	assert email.from() == 'sender@example.com'
	assert email.to().len == 1
	assert email.to()[0] == 'recipient@example.com'
	assert email.cc().len == 1
	assert email.cc()[0] == 'cc@example.com'
	assert email.bcc().len == 1
	assert email.bcc()[0] == 'bcc@example.com'
	assert email.date() == 1615478400
	
	// Test setter methods
	email.set_subject('Updated Subject')
	assert email.subject() == 'Updated Subject'
	
	email.set_from('newsender@example.com')
	assert email.from() == 'newsender@example.com'
	
	email.set_to(['new1@example.com', 'new2@example.com'])
	assert email.to().len == 2
	assert email.to()[0] == 'new1@example.com'
	assert email.to()[1] == 'new2@example.com'
	
	// Test ensure_envelope with a new email
	mut new_email := Email{
		uid: 789
		message: 'Email without envelope'
	}
	
	assert new_email.envelope == none
	new_email.ensure_envelope()
	assert new_email.envelope != none
	
	new_email.set_subject('New Subject')
	assert new_email.subject() == 'New Subject'
}

fn test_email_imap_methods() {
	// Create a test email for IMAP functionality testing
	mut email := Email{
		uid: 123
		seq_num: 456
		mailbox: 'INBOX'
		message: 'This is a test email message.\nWith multiple lines.\nFor testing purposes.'
		flags: ['\\\\Seen', '\\\\Flagged']
		internal_date: 1615478400
		envelope: Envelope{
			subject: 'Test Subject'
			from: ['sender@example.com']
			to: ['recipient@example.com']
		}
	}
	
	// Test size calculation
	calculated_size := email.calculate_size()
	assert calculated_size > 0
	assert calculated_size >= u32(email.message.len)
	
	// Test body structure for email without attachments
	body_structure := email.body_structure()
	assert body_structure.contains('text')
	assert body_structure.contains('plain')
	assert body_structure.contains('7bit')
	
	// Test body structure for email with attachments
	mut email_with_attachments := email
	email_with_attachments.attachments << Attachment{
		filename: 'test.txt'
		content_type: 'text/plain'
		data: 'VGhpcyBpcyBhIHRlc3QgYXR0YWNobWVudC4='
	}
	
	body_structure_with_attachments := email_with_attachments.body_structure()
	assert body_structure_with_attachments.contains('multipart')
	assert body_structure_with_attachments.contains('mixed')
	assert body_structure_with_attachments.contains('attachment')
	assert body_structure_with_attachments.contains('test.txt')
	
	// Test flag-related methods
	assert email.is_read() == true
	assert email.is_flagged() == true
	
	// Test recipient methods
	all_recipients := email.recipients()
	assert all_recipients.len == 1
	assert all_recipients[0] == 'recipient@example.com'
	
	// Test has_attachments
	assert email.has_attachments() == false
	assert email_with_attachments.has_attachments() == true
}

fn test_count_lines() {
	assert count_lines('') == 0
	assert count_lines('Single line') == 1
	assert count_lines('Line 1\nLine 2') == 2
	assert count_lines('Line 1\nLine 2\nLine 3\nLine 4') == 4
}
