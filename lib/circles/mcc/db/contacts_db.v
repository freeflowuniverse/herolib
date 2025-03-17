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

// delete_by_uid removes an email by its UID
pub fn (mut c ContactsDB) delete_by_uid(uid u32) ! {
	// Get the contact by UID
	contact := c.get_by_uid(uid) or {
		// Contact not found, nothing to delete
		return
	}

	// Delete the contact by ID
	c.delete(contact.id)!
}

// search_by_subject searches for contacts with a specific subject substring
pub fn (mut c ContactsDB) search_by_name(name string) ![]Contact {
	mut matching_contacts := []Contact{}

	// Get all contact IDs
	contact_ids := c.list()!

	// Filter contacts that match the first name or last name
	for id in contact_ids {
		// Get the contact by ID
		contact := c.get(id) or { continue }

		// Check if the contact has an envelope with a matching subject
		if contact.first_name.to_lower().contains(name.to_lower())
			|| contact.last_name.to_lower().contains(name.to_lower()) {
			matching_contacts << contact
		}
	}

	return matching_contacts
}

// search_by_address searches for contacts with a specific email address in from, to, cc, or bcc fields
pub fn (mut c ContactsDB) search_by_email(email string) ![]Contact {
	mut matching_contacts := []Contact{}

	// Get all contact IDs
	contact_ids := c.list()!

	// Filter contacts that match the address
	for id in contact_ids {
		// Get the contact by ID
		contact := c.get(id) or { continue }

		// Check if the contact has an envelope with a matching address
		if contact.email == email {
			matching_contacts << contact
		}
	}

	return matching_contacts
}
