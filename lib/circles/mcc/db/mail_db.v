module mcc

import freeflowuniverse.herolib.circles.models { DBHandler, SessionState }
import freeflowuniverse.herolib.circles.mcc.models { Email, email_loads }

@[heap]
pub struct MailDB {
pub mut:
	db DBHandler[Email]
}

pub fn new_maildb(session_state SessionState) !MailDB {
	return MailDB{
		db: models.new_dbhandler[Email]('mail', session_state)
	}
}

pub fn (mut m MailDB) new() Email {
	return Email{}
}

// set adds or updates an email
pub fn (mut m MailDB) set(email Email) !Email {
	return m.db.set(email)!
}

// get retrieves an email by its ID
pub fn (mut m MailDB) get(id u32) !Email {
	return m.db.get(id)!
}

// list returns all email IDs
pub fn (mut m MailDB) list() ![]u32 {
	return m.db.list()!
}

pub fn (mut m MailDB) getall() ![]Email {
	return m.db.getall()!
}

// delete removes an email by its ID
pub fn (mut m MailDB) delete(id u32) ! {
	m.db.delete(id)!
}

//////////////////CUSTOM METHODS//////////////////////////////////

// get_by_uid retrieves an email by its UID
pub fn (mut m MailDB) get_by_uid(uid u32) !Email {
	return m.db.get_by_key('uid', uid.str())!
}

// get_by_mailbox retrieves all emails in a specific mailbox
pub fn (mut m MailDB) get_by_mailbox(mailbox string) ![]Email {
	// Get all emails
	all_emails := m.getall()!
	
	// Filter emails by mailbox
	mut result := []Email{}
	for email in all_emails {
		if email.mailbox == mailbox {
			result << email
		}
	}
	
	return result
}

// delete_by_uid removes an email by its UID
pub fn (mut m MailDB) delete_by_uid(uid u32) ! {
	// Get the email by UID
	email := m.get_by_uid(uid) or {
		// Email not found, nothing to delete
		return
	}
	
	// Delete the email by ID
	m.delete(email.id)!
}

// delete_by_mailbox removes all emails in a specific mailbox
pub fn (mut m MailDB) delete_by_mailbox(mailbox string) ! {
	// Get all emails in the mailbox
	emails := m.get_by_mailbox(mailbox)!
	
	// Delete each email
	for email in emails {
		m.delete(email.id)!
	}
}

// update_flags updates the flags of an email
pub fn (mut m MailDB) update_flags(uid u32, flags []string) !Email {
	// Get the email by UID
	mut email := m.get_by_uid(uid)!
	
	// Update the flags
	email.flags = flags
	
	// Save the updated email
	return m.set(email)!
}

// search_by_subject searches for emails with a specific subject substring
pub fn (mut m MailDB) search_by_subject(subject string) ![]Email {
	mut matching_emails := []Email{}
	
	// Get all email IDs
	email_ids := m.list()!
	
	// Filter emails that match the subject
	for id in email_ids {
		// Get the email by ID
		email := m.get(id) or { continue }
		
		// Check if the email has an envelope with a matching subject
		if envelope := email.envelope {
			if envelope.subject.to_lower().contains(subject.to_lower()) {
				matching_emails << email
			}
		}
	}
	
	return matching_emails
}

// search_by_address searches for emails with a specific email address in from, to, cc, or bcc fields
pub fn (mut m MailDB) search_by_address(address string) ![]Email {
	mut matching_emails := []Email{}
	
	// Get all email IDs
	email_ids := m.list()!
	
	// Filter emails that match the address
	for id in email_ids {
		// Get the email by ID
		email := m.get(id) or { continue }
		
		// Check if the email has an envelope with a matching address
		if envelope := email.envelope {
			// Check in from addresses
			for addr in envelope.from {
				if addr.to_lower().contains(address.to_lower()) {
					matching_emails << email
					continue
				}
			}
			
			// Check in to addresses
			for addr in envelope.to {
				if addr.to_lower().contains(address.to_lower()) {
					matching_emails << email
					continue
				}
			}
			
			// Check in cc addresses
			for addr in envelope.cc {
				if addr.to_lower().contains(address.to_lower()) {
					matching_emails << email
					continue
				}
			}
			
			// Check in bcc addresses
			for addr in envelope.bcc {
				if addr.to_lower().contains(address.to_lower()) {
					matching_emails << email
					continue
				}
			}
		}
	}
	
	return matching_emails
}
