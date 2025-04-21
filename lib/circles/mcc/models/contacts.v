module models

import freeflowuniverse.herolib.data.encoder
import freeflowuniverse.herolib.data.ourtime

pub struct Contact {
pub mut:
	// Database ID
	id u32 // Database ID (assigned by DBHandler)
	// Content fields
	created_at  ourtime.OurTime
	modified_at ourtime.OurTime
	first_name  string
	last_name   string
	email       string
	group       string    // Reference to a dns name, each group has a globally unique dns
	groups      []u32     // Groups this contact belongs to (references Circle IDs)
}


// add_group adds a group to this contact
pub fn (mut contact Contact) add_group(group_id u32) {
	if group_id !in contact.groups {
		contact.groups << group_id
	}
}

// remove_group removes a group from this contact
pub fn (mut contact Contact) remove_group(group_id u32) {
	contact.groups = contact.groups.filter(it != group_id)
}

// filter_by_groups returns true if this contact belongs to any of the specified groups
pub fn (contact Contact) filter_by_groups(groups []u32) bool {
	for g in groups {
		if g in contact.groups {
			return true
		}
	}
	return false
}

// search_by_name returns true if the name contains the query (case-insensitive)
pub fn (contact Contact) search_by_name(query string) bool {
	full_name := contact.full_name().to_lower()
	query_words := query.to_lower().split(' ')
	
	for word in query_words {
		if !full_name.contains(word) {
			return false
		}
	}
	return true
}

// search_by_email returns true if the email contains the query (case-insensitive)
pub fn (contact Contact) search_by_email(query string) bool {
	return contact.email.to_lower().contains(query.to_lower())
}

// update_groups updates the contact's groups
pub fn (mut contact Contact) update_groups(groups []u32) {
	contact.groups = groups.clone()
	contact.modified_at = i64(ourtime.now().unix)
}

// full_name returns the full name of the contact
pub fn (contact Contact) full_name() string {
	return '${contact.first_name} ${contact.last_name}'
}

// dumps serializes the Contact to a byte array
pub fn (contact Contact) dumps() ![]u8 {
	mut enc := encoder.new()

	// Add unique encoding ID to identify this type of data
	enc.add_u16(303) // Unique ID for Contact type

	enc.add_u32(contact.id)
	enc.add_i64(contact.created_at)
	enc.add_i64(contact.modified_at)
	enc.add_string(contact.first_name)
	enc.add_string(contact.last_name)
	enc.add_string(contact.email)
	enc.add_string(contact.group)
	
	// Add groups array
	enc.add_u32(u32(contact.groups.len))
	for group_id in contact.groups {
		enc.add_u32(group_id)
	}

	return enc.data
}

// loads deserializes a byte array to a Contact
pub fn contact_event_loads(data []u8) !Contact {
	mut d := encoder.decoder_new(data)
	mut contact := Contact{}

	// Check encoding ID to verify this is the correct type of data
	encoding_id := d.get_u16()!
	if encoding_id != 303 {
		return error('Wrong file type: expected encoding ID 303, got ${encoding_id}, for contact')
	}

	// Decode Contact fields
	contact.id = d.get_u32()!
	contact.created_at = d.get_i64()!
	contact.modified_at = d.get_i64()!
	contact.first_name = d.get_string()!
	contact.last_name = d.get_string()!
	contact.email = d.get_string()!
	contact.group = d.get_string()!
	
	// Check if there's more data (for backward compatibility)
	// Try to read the groups array, but handle potential errors if no more data
	contact.groups = []u32{}
	
	// We need to handle the case where older data might not have groups
	// Try to read the groups length, but catch any errors if we're at the end of data
	groups_len := d.get_u32() or {
		// No more data, which is fine for backward compatibility
		return contact
	}
	
	// If we successfully read the groups length, try to read the groups
	if groups_len > 0 {
		contact.groups = []u32{cap: int(groups_len)}
		for _ in 0..groups_len {
			group_id := d.get_u32() or {
				// If we can't read a group ID, just return what we have so far
				break
			}
			contact.groups << group_id
		}
	}

	return contact
}

// index_keys returns the keys to be indexed for this contact
pub fn (contact Contact) index_keys() map[string]string {
	mut keys := map[string]string{}
	keys['id'] = contact.id.str()
	keys['email'] = contact.email
	keys['name'] = contact.full_name()
	keys['group'] = contact.group
	return keys
}
