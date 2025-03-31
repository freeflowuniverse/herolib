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
}

fn test_contact_deserialization_with_wrong_encoding_id() {
	// Create a Contact with test data
	mut original := Contact{
		id: 42
		first_name: 'John'
		last_name: 'Doe'
		email: 'john.doe@example.com'
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
