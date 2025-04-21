module models

fn test_contact_serialization_deserialization() {
	// Create a Contact with test data
	mut original := Contact{
		id: 42
		created_at: 1648193845
		modified_at: 1648193900
		first_name: 'John'
		last_name: 'Doe'
		email: 'john.doe@example.com'
		group: 'Friends'
		groups: [u32(1), 2, 3]
	}

	// Serialize the Contact
	serialized := original.dumps() or {
		assert false, 'Failed to serialize Contact: ${err}'
		return
	}

	// Deserialize back to a Contact
	deserialized := contact_event_loads(serialized) or {
		assert false, 'Failed to deserialize Contact: ${err}'
		return
	}

	// Verify all fields match between original and deserialized
	assert deserialized.id == original.id, 'ID mismatch: ${deserialized.id} != ${original.id}'
	assert deserialized.created_at == original.created_at, 'created_at mismatch'
	assert deserialized.modified_at == original.modified_at, 'modified_at mismatch'
	assert deserialized.first_name == original.first_name, 'first_name mismatch'
	assert deserialized.last_name == original.last_name, 'last_name mismatch'
	assert deserialized.email == original.email, 'email mismatch'
	assert deserialized.group == original.group, 'group mismatch'
	assert deserialized.groups == original.groups, 'groups mismatch'
}

fn test_contact_deserialization_with_wrong_encoding_id() {
	// Create a Contact with test data
	mut original := Contact{
		id: 42
		first_name: 'John'
		last_name: 'Doe'
		email: 'john.doe@example.com'
		groups: [u32(1), 2]
	}

	// Serialize the Contact
	mut serialized := original.dumps() or {
		assert false, 'Failed to serialize Contact: ${err}'
		return
	}

	// Corrupt the encoding ID (first 2 bytes) to simulate wrong data type
	if serialized.len >= 2 {
		// Change encoding ID from 303 to 304
		serialized[1] = 48 // 304 = 00000001 00110000
	}

	// Attempt to deserialize with wrong encoding ID
	contact_event_loads(serialized) or {
		// This should fail with an error about wrong encoding ID
		assert err.str().contains('Wrong file type'), 'Expected error about wrong file type, got: ${err}'
		return
	}

	// If we get here, the deserialization did not fail as expected
	assert false, 'Deserialization should have failed with wrong encoding ID'
}

fn test_contact_with_empty_fields() {
	// Create a Contact with empty string fields
	mut original := Contact{
		id: 100
		created_at: 1648193845
		modified_at: 1648193900
		first_name: ''
		last_name: ''
		email: ''
		group: ''
		groups: []u32{}
	}

	// Serialize the Contact
	serialized := original.dumps() or {
		assert false, 'Failed to serialize Contact with empty fields: ${err}'
		return
	}

	// Deserialize back to a Contact
	deserialized := contact_event_loads(serialized) or {
		assert false, 'Failed to deserialize Contact with empty fields: ${err}'
		return
	}

	// Verify all fields match between original and deserialized
	assert deserialized.id == original.id, 'ID mismatch'
	assert deserialized.created_at == original.created_at, 'created_at mismatch'
	assert deserialized.modified_at == original.modified_at, 'modified_at mismatch'
	assert deserialized.first_name == original.first_name, 'first_name mismatch'
	assert deserialized.last_name == original.last_name, 'last_name mismatch'
	assert deserialized.email == original.email, 'email mismatch'
	assert deserialized.group == original.group, 'group mismatch'
	assert deserialized.groups == original.groups, 'groups mismatch'
}

fn test_contact_serialization_size() {
	// Create a Contact with test data
	mut original := Contact{
		id: 42
		created_at: 1648193845
		modified_at: 1648193900
		first_name: 'John'
		last_name: 'Doe'
		email: 'john.doe@example.com'
		group: 'Friends'
		groups: [u32(1), 2, 3]
	}

	// Serialize the Contact
	serialized := original.dumps() or {
		assert false, 'Failed to serialize Contact: ${err}'
		return
	}

	// Verify serialized data is not empty and has a reasonable size
	assert serialized.len > 0, 'Serialized data should not be empty'
	
	// Calculate approximate expected size
	// 2 bytes for encoding ID + 4 bytes for ID + 8 bytes each for timestamps
	// + string lengths + string content lengths
	expected_min_size := 2 + 4 + (8 * 2) + original.first_name.len + original.last_name.len + 
	                      original.email.len + original.group.len + 4 // some overhead for string lengths
	
	assert serialized.len >= expected_min_size, 'Serialized data size is suspiciously small'
}

fn test_contact_new_constructor() {
	// Test the new_contact constructor
	contact := new_contact(42, 'John', 'Doe', 'john.doe@example.com', 'Friends')
	
	assert contact.id == 42
	assert contact.first_name == 'John'
	assert contact.last_name == 'Doe'
	assert contact.email == 'john.doe@example.com'
	assert contact.group == 'Friends'
	assert contact.groups.len == 0
	
	// Check that timestamps were set
	assert contact.created_at > 0
	assert contact.modified_at > 0
	assert contact.created_at == contact.modified_at
}

fn test_contact_groups_management() {
	// Test adding and removing groups
	mut contact := new_contact(42, 'John', 'Doe', 'john.doe@example.com', 'Friends')
	
	// Initially empty
	assert contact.groups.len == 0
	
	// Add groups
	contact.add_group(1)
	contact.add_group(2)
	contact.add_group(3)
	
	assert contact.groups.len == 3
	assert u32(1) in contact.groups
	assert u32(2) in contact.groups
	assert u32(3) in contact.groups
	
	// Adding duplicate should not change anything
	contact.add_group(1)
	assert contact.groups.len == 3
	
	// Remove a group
	contact.remove_group(2)
	assert contact.groups.len == 2
	assert u32(1) in contact.groups
	assert u32(2) !in contact.groups
	assert u32(3) in contact.groups
	
	// Update all groups
	contact.update_groups([u32(5), 6])
	assert contact.groups.len == 2
	assert u32(5) in contact.groups
	assert u32(6) in contact.groups
	assert u32(1) !in contact.groups
	assert u32(3) !in contact.groups
}

fn test_contact_filter_and_search() {
	// Test filtering and searching
	mut contact := Contact{
		id: 42
		first_name: 'John'
		last_name: 'Doe'
		email: 'john.doe@example.com'
		group: 'Friends'
		groups: [u32(1), 2, 3]
	}
	
	// Test filter_by_groups
	assert contact.filter_by_groups([u32(1), 5]) == true
	assert contact.filter_by_groups([u32(5), 6]) == false
	
	// Test search_by_name
	assert contact.search_by_name('john') == true
	assert contact.search_by_name('doe') == true
	assert contact.search_by_name('john doe') == true
	assert contact.search_by_name('JOHN') == true // Case insensitive
	assert contact.search_by_name('smith') == false
	
	// Test search_by_email
	assert contact.search_by_email('john') == true
	assert contact.search_by_email('example') == true
	assert contact.search_by_email('EXAMPLE') == true // Case insensitive
	assert contact.search_by_email('gmail') == false
}

fn test_contact_update() {
	// Test updating contact information
	mut contact := new_contact(42, 'John', 'Doe', 'john.doe@example.com', 'Friends')
	mut original_modified_at := contact.modified_at
	
	// Update individual fields
	contact.update('Jane', '', '', '')
	assert contact.first_name == 'Jane'
	assert contact.last_name == 'Doe' // Unchanged
	assert contact.modified_at > original_modified_at
	
	original_modified_at = contact.modified_at
	
	// Update multiple fields
	contact.update('', 'Smith', 'jane.smith@example.com', '')
	assert contact.first_name == 'Jane' // Unchanged
	assert contact.last_name == 'Smith'
	assert contact.email == 'jane.smith@example.com'
	assert contact.group == 'Friends' // Unchanged
	assert contact.modified_at > original_modified_at
}

fn test_contact_full_name() {
	// Test full_name method
	contact := Contact{
		first_name: 'John'
		last_name: 'Doe'
	}
	
	assert contact.full_name() == 'John Doe'
}
