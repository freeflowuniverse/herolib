module mail

// A simplified test file to verify basic functionality

fn test_email_basic() {
	// Create a test email
	mut email := Email{
		uid: 123
		seq_num: 456
		mailbox: 'INBOX'
		message: 'This is a test email message.'
		flags: ['\\\\Seen']
		internal_date: 1615478400
	}
	
	// Test helper methods
	email.ensure_envelope()
	email.set_subject('Test Subject')
	email.set_from('sender@example.com')
	email.set_to(['recipient@example.com'])
	
	assert email.subject() == 'Test Subject'
	assert email.from() == 'sender@example.com'
	assert email.to().len == 1
	assert email.to()[0] == 'recipient@example.com'
	
	// Test flag methods
	assert email.is_read() == true
	
	// Test size calculation
	calculated_size := email.calculate_size()
	assert calculated_size > 0
	assert calculated_size >= u32(email.message.len)
}

fn test_count_lines() {
	assert count_lines('') == 0
	assert count_lines('Single line') == 1
	assert count_lines('Line 1\nLine 2') == 2
}
