module dbmodule core

import freeflowuniverse.herolib.circles.base { DBHandler, SessionState }
import freeflowuniverse.herolib.circles.core.models { Name, Record, RecordType }

@[heap]
pub struct NameDB {
pub mut:
	db DBHandler[Name]
}

pub fn new_namedb(session_state SessionState) !NameDB {
	return NameDB{
		db: models.new_dbhandler[Name]('name', session_state)
	}
}

pub fn (mut m NameDB) new() Name {
	return Name{}
}

// set adds or updates a name
pub fn (mut m NameDB) set(name Name) !Name {
	return m.db.set(name)!
}

// get retrieves a name by its ID
pub fn (mut m NameDB) get(id u32) !Name {
	return m.db.get(id)!
}

// list returns all name IDs
pub fn (mut m NameDB) list() ![]u32 {
	return m.db.list()!
}

pub fn (mut m NameDB) getall() ![]Name {
	return m.db.getall()!
}

// delete removes a name by its ID
pub fn (mut m NameDB) delete(id u32) ! {
	m.db.delete(id)!
}

//////////////////CUSTOM METHODS//////////////////////////////////

// get_by_domain retrieves a name by its domain
pub fn (mut m NameDB) get_by_domain(domain string) !Name {
	return m.db.get_by_key('domain', domain)!
}

// delete_by_domain removes a name by its domain
pub fn (mut m NameDB) delete_by_domain(domain string) ! {
	// Get the name by domain
	name := m.get_by_domain(domain) or {
		// Name not found, nothing to delete
		return
	}
	
	// Delete the name by ID
	m.delete(name.id)!
}

// get_all_domains returns all domains
pub fn (mut m NameDB) get_all_domains() ![]string {
	// Get all name IDs
	name_ids := m.list()!
	
	// Get domains for all names
	mut domains := []string{}
	for id in name_ids {
		name := m.get(id) or { continue }
		domains << name.domain
	}
	
	return domains
}

// add_record adds a record to a name
pub fn (mut m NameDB) add_record(domain string, record Record) !Name {
	// Get the name by domain
	mut name := m.get_by_domain(domain)!
	
	// Check if record with same name and type already exists
	for existing_record in name.records {
		if existing_record.name == record.name && existing_record.category == record.category {
			return error('Record with name ${record.name} and type ${record.category} already exists in domain ${domain}')
		}
	}
	
	// Add the record
	name.records << record
	
	// Save the updated name
	return m.set(name)!
}

// remove_record removes a record from a name by record name and type
pub fn (mut m NameDB) remove_record(domain string, record_name string, record_type RecordType) !Name {
	// Get the name by domain
	mut name := m.get_by_domain(domain)!
	
	// Find and remove the record
	mut found := false
	mut new_records := []Record{}
	
	for record in name.records {
		if record.name == record_name && record.category == record_type {
			found = true
			continue
		}
		new_records << record
	}
	
	if !found {
		return error('Record with name ${record_name} and type ${record_type} not found in domain ${domain}')
	}
	
	// Update the name records
	name.records = new_records
	
	// Save the updated name
	return m.set(name)!
}

// update_record_text updates the text of a record
pub fn (mut m NameDB) update_record_text(domain string, record_name string, record_type RecordType, new_text string) !Name {
	// Get the name by domain
	mut name := m.get_by_domain(domain)!
	
	// Find and update the record
	mut found := false
	
	for i, mut record in name.records {
		if record.name == record_name && record.category == record_type {
			name.records[i].text = new_text
			found = true
			break
		}
	}
	
	if !found {
		return error('Record with name ${record_name} and type ${record_type} not found in domain ${domain}')
	}
	
	// Save the updated name
	return m.set(name)!
}

// add_admin adds an admin to a name
pub fn (mut m NameDB) add_admin(domain string, pubkey string) !Name {
	// Get the name by domain
	mut name := m.get_by_domain(domain)!
	
	// Check if admin already exists
	if pubkey in name.admins {
		return error('Admin with pubkey ${pubkey} already exists in domain ${domain}')
	}
	
	// Add the admin
	name.admins << pubkey
	
	// Save the updated name
	return m.set(name)!
}

// remove_admin removes an admin from a name
pub fn (mut m NameDB) remove_admin(domain string, pubkey string) !Name {
	// Get the name by domain
	mut name := m.get_by_domain(domain)!
	
	// Find and remove the admin
	mut found := false
	mut new_admins := []string{}
	
	for admin in name.admins {
		if admin == pubkey {
			found = true
			continue
		}
		new_admins << admin
	}
	
	if !found {
		return error('Admin with pubkey ${pubkey} not found in domain ${domain}')
	}
	
	// Update the name admins
	name.admins = new_admins
	
	// Save the updated name
	return m.set(name)!
}
