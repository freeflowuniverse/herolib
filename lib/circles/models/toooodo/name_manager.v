module core

import freeflowuniverse.herolib.data.ourdb
import freeflowuniverse.herolib.data.radixtree
import freeflowuniverse.herolib.core.playbook

@[heap]
pub struct NameManager {
pub mut:
	manager DBSession[Name]
}

pub fn new_namemanager(db_data &ourdb.OurDB, db_meta &radixtree.RadixTree) NameManager {
	return NameManager{
		manager: session.new_dbsession[Name](db_data, db_meta, 'name')
	}
}

pub fn (mut m NameManager) new() Name {
	return Name{}
}

// set adds or updates a name
pub fn (mut m NameManager) set(name Name) !Name {
	return m.manager.set(name)!
}

// get retrieves a name by its ID
pub fn (mut m NameManager) get(id u32) !Name {
	return m.manager.get(id)!
}

// list returns all name IDs
pub fn (mut m NameManager) list() ![]u32 {
	return m.manager.list()!
}

pub fn (mut m NameManager) getall() ![]Name {
	return m.manager.getall()!
}

// delete removes a name by its ID
pub fn (mut m NameManager) delete(id u32) ! {
	m.manager.delete(id)!
}

//////////////////CUSTOM METHODS//////////////////////////////////

// get_by_domain retrieves a name by its domain
pub fn (mut m NameManager) get_by_domain(domain string) !Name {
	return m.manager.get_by_key('domain', domain)!
}

// delete_by_domain removes a name by its domain
pub fn (mut m NameManager) delete_by_domain(domain string) ! {
	// Get the name by domain
	name := m.get_by_domain(domain) or {
		// Name not found, nothing to delete
		return
	}
	
	// Delete the name by ID
	m.delete(name.id)!
}

// add_record adds a record to a name
pub fn (mut m NameManager) add_record(name_id u32, record Record) !Name {
	// Get the name by ID
	mut name := m.get(name_id)!
	
	// Check if record with the same name and category already exists
	for existing_record in name.records {
		if existing_record.name == record.name && existing_record.category == record.category {
			return error('Record with name ${record.name} and category ${record.category} already exists in domain ${name.domain}')
		}
	}
	
	// Add the record to the name
	name.records << record
	
	// Save the updated name
	return m.set(name)!
}

// remove_record removes a record from a name by name and category
pub fn (mut m NameManager) remove_record(name_id u32, record_name string, category RecordType) !Name {
	// Get the name by ID
	mut name := m.get(name_id)!
	
	// Find and remove the record with the specified name and category
	mut found := false
	mut new_records := []Record{}
	
	for record in name.records {
		if record.name != record_name || record.category != category {
			new_records << record
		} else {
			found = true
		}
	}
	
	if !found {
		return error('Record with name ${record_name} and category ${category} not found in domain ${name.domain}')
	}
	
	// Update the name's records
	name.records = new_records
	
	// Save the updated name
	return m.set(name)!
}

// update_record updates a record in a name
pub fn (mut m NameManager) update_record(name_id u32, record_name string, category RecordType, new_record Record) !Name {
	// Get the name by ID
	mut name := m.get(name_id)!
	
	// Find and update the record with the specified name and category
	mut found := false
	
	for i, mut record in name.records {
		if record.name == record_name && record.category == category {
			// If the new record has a different name or category, check for conflicts
			if (new_record.name != record_name || new_record.category != category) {
				// Check for conflicts with existing records
				for existing_record in name.records {
					if existing_record.name == new_record.name && existing_record.category == new_record.category {
						return error('Cannot update record: A record with name ${new_record.name} and category ${new_record.category} already exists')
					}
				}
			}
			
			name.records[i] = new_record
			found = true
			break
		}
	}
	
	if !found {
		return error('Record with name ${record_name} and category ${category} not found in domain ${name.domain}')
	}
	
	// Save the updated name
	return m.set(name)!
}

// get_records returns all records of a name
pub fn (mut m NameManager) get_records(name_id u32) ![]Record {
	// Get the name by ID
	name := m.get(name_id)!
	
	return name.records
}

// get_records_by_category returns all records of a name with a specific category
pub fn (mut m NameManager) get_records_by_category(name_id u32, category RecordType) ![]Record {
	// Get the name by ID
	name := m.get(name_id)!
	
	// Filter records by category
	mut records_with_category := []Record{}
	
	for record in name.records {
		if record.category == category {
			records_with_category << record
		}
	}
	
	return records_with_category
}

// add_admin adds an admin to a name
pub fn (mut m NameManager) add_admin(name_id u32, pubkey string) !Name {
	// Get the name by ID
	mut name := m.get(name_id)!
	
	// Check if admin already exists
	for admin in name.admins {
		if admin == pubkey {
			return error('Admin with pubkey ${pubkey} already exists in domain ${name.domain}')
		}
	}
	
	// Add the admin to the name
	name.admins << pubkey
	
	// Save the updated name
	return m.set(name)!
}

// remove_admin removes an admin from a name
pub fn (mut m NameManager) remove_admin(name_id u32, pubkey string) !Name {
	// Get the name by ID
	mut name := m.get(name_id)!
	
	// Find and remove the admin with the specified pubkey
	mut found := false
	mut new_admins := []string{}
	
	for admin in name.admins {
		if admin != pubkey {
			new_admins << admin
		} else {
			found = true
		}
	}
	
	if !found {
		return error('Admin with pubkey ${pubkey} not found in domain ${name.domain}')
	}
	
	// Ensure there's at least one admin left
	if new_admins.len == 0 {
		return error('Cannot remove the last admin from domain ${name.domain}')
	}
	
	// Update the name's admins
	name.admins = new_admins
	
	// Save the updated name
	return m.set(name)!
}

// play processes heroscript commands for names
pub fn (mut m NameManager) play(mut plbook playbook.PlayBook) ! {
	// Find all actions that start with 'name.'
	name_actions := plbook.actions_find(actor: 'name')!
	if name_actions.len == 0 {
		return
	}

	// Process name.create actions
	mut create_actions := plbook.actions_find(actor: 'name', name: 'create')!
	for mut action in create_actions {
		mut p := action.params
		
		// Create a new name
		mut name := m.new()
		name.domain = p.get('domain')!
		name.description = p.get_default('description', '')!
		
		// Add admin if provided
		if p.exists('admin') {
			name.admins << p.get('admin')!
		} else if p.exists('admins') {
			name.admins = p.get_list('admins')!
		}
		
		// Save the name
		name = m.set(name)!
		
		// Mark the action as done
		action.done = true
		
		// Return the created name as a result
		action.result.set('id', name.id.str())
		action.result.set('domain', name.domain)
	}
	
	// Process name.add_record actions
	mut add_record_actions := plbook.actions_find(actor: 'name', name: 'add_record')!
	for mut action in add_record_actions {
		mut p := action.params
		
		// Get domain name
		domain := p.get('domain')!
		
		// Find the name by domain
		mut name := m.get_by_domain(domain) or {
			action.result.set('error', 'Domain ${domain} not found')
			action.done = true
			continue
		}
		
		// Create a new record
		mut record := Record{
			name: p.get('name')!
			text: p.get_default('text', '')!
		}
		
		// Get record type
		type_str := p.get('type')!
		record.category = match type_str.to_lower() {
			'a' { RecordType.a }
			'aaaa' { RecordType.aaaa }
			'cname' { RecordType.cname }
			'mx' { RecordType.mx }
			'ns' { RecordType.ns }
			'ptr' { RecordType.ptr }
			'soa' { RecordType.soa }
			'srv' { RecordType.srv }
			'txt' { RecordType.txt }
			else { 
				action.result.set('error', 'Invalid record type: ${type_str}')
				action.done = true
				continue
			}
		}
		
		// Get addresses
		if p.exists('addr') {
			record.addr << p.get('addr')!
		} else if p.exists('addrs') {
			record.addr = p.get_list('addrs')!
		}
		
		// Add the record to the name
		name = m.add_record(name.id, record) or {
			action.result.set('error', err.str())
			action.done = true
			continue
		}
		
		// Mark the action as done
		action.done = true
		
		// Return the record info as a result
		action.result.set('domain_id', name.id.str())
		action.result.set('record_name', record.name)
		action.result.set('type', type_str)
	}
	
	// Process name.add_admin actions
	mut add_admin_actions := plbook.actions_find(actor: 'name', name: 'add_admin')!
	for mut action in add_admin_actions {
		mut p := action.params
		
		// Get domain name
		domain := p.get('domain')!
		
		// Find the name by domain
		mut name := m.get_by_domain(domain) or {
			action.result.set('error', 'Domain ${domain} not found')
			action.done = true
			continue
		}
		
		// Get admin pubkey
		pubkey := p.get('pubkey')!
		
		// Add the admin to the name
		name = m.add_admin(name.id, pubkey) or {
			action.result.set('error', err.str())
			action.done = true
			continue
		}
		
		// Mark the action as done
		action.done = true
		
		// Return the admin info as a result
		action.result.set('domain_id', name.id.str())
		action.result.set('pubkey', pubkey)
	}
}
