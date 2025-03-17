module db

import freeflowuniverse.herolib.circles.base { DBHandler, SessionState, new_dbhandler }
import freeflowuniverse.herolib.circles.mcc.models { Contact }

@[heap]
pub struct ContactsDB {
pub mut:
	db DBHandler[Contact]
}

pub fn new_contacts_db(session_state SessionState) !ContactsDB {
	return ContactsDB{
		db: new_dbhandler[Contact]('contacts', session_state)
	}
}

pub fn (mut c ContactsDB) new() Contact {
	return Contact{}
}

// set adds or updates an Contacts
pub fn (mut c ContactsDB) set(contact Contact) !Contact {
	return c.db.set(contact)!
}

// get retrieves an email by its ID
pub fn (mut c ContactsDB) get(id u32) !Contact {
	return c.db.get(id)!
}

// list returns all email IDs
pub fn (mut c ContactsDB) list() ![]u32 {
	return c.db.list()!
}

pub fn (mut c ContactsDB) getall() ![]Contact {
	return c.db.getall()!
}

// delete removes an email by its ID
pub fn (mut c ContactsDB) delete(id u32) ! {
	c.db.delete(id)!
}

//////////////////CUSTOM METHODS//////////////////////////////////

// get_by_uid retrieves an email by its UID
pub fn (mut c ContactsDB) get_by_uid(uid u32) !Contact {
	return c.db.get_by_key('uid', uid.str())!
}

// get_by_mailbox retrieves all contacts in a specific mailbox
pub fn (mut c ContactsDB) get_by_mailbox(mailbox string) ![]Contact {
	// Get all contacts
	allcontacts := c.getall()!

	// Filter contacts by mailbox
	mut result := []Contact{}
	// for email in all_contacts {
	// 	if email.mailbox == mailbox {
	// 		result << email
	// 	}
	// }

	return result
}

// delete_by_uid removes an email by its UID
pub fn (mut c ContactsDB) delete_by_uid(uid u32) ! {
	// Get the email by UID
	email := c.get_by_uid(uid) or {
		// Email not found, nothing to delete
		return
	}

	// Delete the email by ID
	c.delete(email.id)!
}

// delete_by_mailbox removes all contacts in a specific mailbox
pub fn (mut c ContactsDB) delete_by_mailbox(mailbox string) ! {
	// Get all contacts in the mailbox
	contacts := c.get_by_mailbox(mailbox)!

	// Delete each email
	for email in contacts {
		c.delete(email.id)!
	}
}

// update_flags updates the flags of an email
pub fn (mut c ContactsDB) update_flags(uid u32, flags []string) !Contact {
	// Get the email by UID
	mut email := c.get_by_uid(uid)!

	// Update the flags
	// email.flags = flags

	// Save the updated email
	return c.set(email)!
}

// search_by_subject searches for contacts with a specific subject substring
pub fn (mut c ContactsDB) search_by_subject(subject string) ![]Contact {
	mut matching_contacts := []Contact{}

	// Get all email IDs
	// email_ids := c.list()!

	// Filter contacts that match the subject
	// for id in email_ids {
	// 	// Get the email by ID
	// 	// email := c.get(id) or { continue }

	// 	// // Check if the email has an envelope with a matching subject
	// 	// if envelope := email.envelope {
	// 	// 	if envelope.subject.to_lower().contains(subject.to_lower()) {
	// 	// 		matching_contacts << email
	// 	// 	}
	// 	// }
	// }

	return matching_contacts
}

// search_by_address searches for contacts with a specific email address in from, to, cc, or bcc fields
pub fn (mut c ContactsDB) search_by_address(address string) ![]Contact {
	mut matching_contacts := []Contact{}

	// Get all email IDs
	email_ids := c.list()!

	// Filter contacts that match the address
	for id in email_ids {
		// Get the email by ID
		email := c.get(id) or { continue }

		// Check if the email has an envelope with a matching address
		// if envelope := email.envelope {
		// 	// Check in from addresses
		// 	for addr in envelope.from {
		// 		if addr.to_lower().contains(address.to_lower()) {
		// 			matching_contacts << email
		// 			continue
		// 		}
		// 	}

		// 	// Check in to addresses
		// 	for addr in envelope.to {
		// 		if addr.to_lower().contains(address.to_lower()) {
		// 			matching_contacts << email
		// 			continue
		// 		}
		// 	}

		// 	// Check in cc addresses
		// 	for addr in envelope.cc {
		// 		if addr.to_lower().contains(address.to_lower()) {
		// 			matching_contacts << email
		// 			continue
		// 		}
		// 	}

		// 	// Check in bcc addresses
		// 	for addr in envelope.bcc {
		// 		if addr.to_lower().contains(address.to_lower()) {
		// 			matching_contacts << email
		// 			continue
		// 		}
		// 	}
		// }
	}

	return matching_contacts
}
