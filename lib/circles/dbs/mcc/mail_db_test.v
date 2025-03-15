module mcc

import os
import rand
import freeflowuniverse.herolib.circles.actionprocessor
import freeflowuniverse.herolib.circles.models.mcc

fn test_mail_db() {
	// Create a temporary directory for testing
	test_dir := os.join_path(os.temp_dir(), 'hero_mail_test_${rand.intn(9000) or { 0 } + 1000}')
	os.mkdir_all(test_dir) or { panic(err) }
	defer { os.rmdir_all(test_dir) or {} }
	
	mut runner := actionprocessor.new(path: test_dir)!

	// Create multiple emails for testing
	mut email1 := runner.mails.new()
	email1.uid = 1001
	email1.seq_num = 1
	email1.mailbox = 'INBOX'
	email1.message = 'This is test email 1'
	email1.flags = ['\\Seen']
	email1.internal_date = 1647123456
	email1.size = 1024
	email1.envelope = mcc.Envelope{
		subject: 'Test Email 1'
		from: ['sender1@example.com']
		to: ['recipient1@example.com']
	}

	mut email2 := runner.mails.new()
	email2.uid = 1002
	email2.seq_num = 2
	email2.mailbox = 'INBOX'
	email2.message = 'This is test email 2'
	email2.flags = ['\\Seen', '\\Flagged']
	email2.internal_date = 1647123457
	email2.size = 2048
	email2.envelope = mcc.Envelope{
		subject: 'Test Email 2'
		from: ['sender2@example.com']
		to: ['recipient2@example.com']
	}

	mut email3 := runner.mails.new()
	email3.uid = 1003
	email3.seq_num = 1
	email3.mailbox = 'Sent'
	email3.message = 'This is test email 3'
	email3.flags = ['\\Seen']
	email3.internal_date = 1647123458
	email3.size = 3072
	email3.envelope = mcc.Envelope{
		subject: 'Test Email 3'
		from: ['user@example.com']
		to: ['recipient3@example.com']
	}

	// Add the emails
	println('Adding email 1')
	email1 = runner.mails.set(email1)!
	
	// Let the DBHandler assign IDs automatically
	println('Adding email 2')
	email2 = runner.mails.set(email2)!
	
	println('Adding email 3')
	email3 = runner.mails.set(email3)!

	// Test list functionality
	println('Testing list functionality')
	
	// Debug: Print the email IDs in the list
	email_ids := runner.mails.list()!
	println('Email IDs in list: ${email_ids}')
	
	// Get all emails
	all_emails := runner.mails.getall()!
	println('Retrieved ${all_emails.len} emails')
	for i, email in all_emails {
		println('Email ${i}: id=${email.id}, uid=${email.uid}, mailbox=${email.mailbox}')
	}
	
	assert all_emails.len == 3, 'Expected 3 emails, got ${all_emails.len}'
	
	// Verify all emails are in the list
	mut found1 := false
	mut found2 := false
	mut found3 := false
	
	for email in all_emails {
		if email.uid == 1001 {
			found1 = true
		} else if email.uid == 1002 {
			found2 = true
		} else if email.uid == 1003 {
			found3 = true
		}
	}
	
	assert found1, 'Email 1 not found in list'
	assert found2, 'Email 2 not found in list'
	assert found3, 'Email 3 not found in list'

	// Get and verify individual emails
	println('Verifying individual emails')
	retrieved_email1 := runner.mails.get_by_uid(1001)!
	assert retrieved_email1.uid == email1.uid
	assert retrieved_email1.mailbox == email1.mailbox
	assert retrieved_email1.message == email1.message
	assert retrieved_email1.flags.len == 1
	assert retrieved_email1.flags[0] == '\\Seen'
	
	if envelope := retrieved_email1.envelope {
		assert envelope.subject == 'Test Email 1'
		assert envelope.from.len == 1
		assert envelope.from[0] == 'sender1@example.com'
	} else {
		assert false, 'Envelope should not be empty'
	}

	// Test get_by_mailbox
	println('Testing get_by_mailbox')
	
	// Debug: Print all emails and their mailboxes
	all_emails_debug := runner.mails.getall()!
	println('All emails (debug):')
	for i, email in all_emails_debug {
		println('Email ${i}: id=${email.id}, uid=${email.uid}, mailbox="${email.mailbox}"')
	}
	
	// Debug: Print index keys for each email
	for i, email in all_emails_debug {
		keys := email.index_keys()
		println('Email ${i} index keys: ${keys}')
	}
	
	inbox_emails := runner.mails.get_by_mailbox('INBOX')!
	println('Found ${inbox_emails.len} emails in INBOX')
	for i, email in inbox_emails {
		println('INBOX Email ${i}: id=${email.id}, uid=${email.uid}')
	}
	
	assert inbox_emails.len == 2, 'Expected 2 emails in INBOX, got ${inbox_emails.len}'
	
	sent_emails := runner.mails.get_by_mailbox('Sent')!
	assert sent_emails.len == 1, 'Expected 1 email in Sent, got ${sent_emails.len}'
	assert sent_emails[0].uid == 1003

	// Test update_flags
	println('Updating email flags')
	runner.mails.update_flags(1001, ['\\Seen', '\\Answered'])!
	updated_email := runner.mails.get_by_uid(1001)!
	assert updated_email.flags.len == 2
	assert '\\Answered' in updated_email.flags

	// Test search_by_subject
	println('Testing search_by_subject')
	subject_emails := runner.mails.search_by_subject('Test Email')!
	assert subject_emails.len == 3, 'Expected 3 emails with subject containing "Test Email", got ${subject_emails.len}'
	
	subject_emails2 := runner.mails.search_by_subject('Email 2')!
	assert subject_emails2.len == 1, 'Expected 1 email with subject containing "Email 2", got ${subject_emails2.len}'
	assert subject_emails2[0].uid == 1002

	// Test search_by_address
	println('Testing search_by_address')
	address_emails := runner.mails.search_by_address('recipient2@example.com')!
	assert address_emails.len == 1, 'Expected 1 email with address containing "recipient2@example.com", got ${address_emails.len}'
	assert address_emails[0].uid == 1002

	// Test delete functionality
	println('Testing delete functionality')
	// Delete email 2
	runner.mails.delete_by_uid(1002)!
	
	// Verify deletion with list
	emails_after_delete := runner.mails.getall()!
	assert emails_after_delete.len == 2, 'Expected 2 emails after deletion, got ${emails_after_delete.len}'
	
	// Verify the remaining emails
	mut found_after_delete1 := false
	mut found_after_delete2 := false
	mut found_after_delete3 := false
	
	for email in emails_after_delete {
		if email.uid == 1001 {
			found_after_delete1 = true
		} else if email.uid == 1002 {
			found_after_delete2 = true
		} else if email.uid == 1003 {
			found_after_delete3 = true
		}
	}
	
	assert found_after_delete1, 'Email 1 not found after deletion'
	assert !found_after_delete2, 'Email 2 found after deletion (should be deleted)'
	assert found_after_delete3, 'Email 3 not found after deletion'

	// Test delete_by_mailbox
	println('Testing delete_by_mailbox')
	runner.mails.delete_by_mailbox('Sent')!
	
	// Verify only INBOX emails remain
	emails_after_mailbox_delete := runner.mails.getall()!
	assert emails_after_mailbox_delete.len == 1, 'Expected 1 email after mailbox deletion, got ${emails_after_mailbox_delete.len}'
	assert emails_after_mailbox_delete[0].mailbox == 'INBOX', 'Remaining email should be in INBOX'
	assert emails_after_mailbox_delete[0].uid == 1001, 'Remaining email should have UID 1001'

	// Delete the last email
	println('Deleting last email')
	runner.mails.delete_by_uid(1001)!
	
	// Verify no emails remain
	emails_after_all_deleted := runner.mails.getall() or {
		// This is expected to fail with 'No emails found' error
		assert err.msg().contains('No')
		[]mcc.Email{cap: 0}
	}
	assert emails_after_all_deleted.len == 0, 'Expected 0 emails after all deletions, got ${emails_after_all_deleted.len}'

	println('All tests passed successfully')
}
