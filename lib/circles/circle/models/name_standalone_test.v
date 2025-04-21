module models

import freeflowuniverse.herolib.data.encoder

// Standalone tests for the Name model that don't depend on other models

fn test_name_standalone_dumps_loads() {
	// Create a test name with some sample data
	mut name := Name{
		id: 123
		domain: 'example.com'
		description: 'A test domain for binary encoding'
	}

	// Add a record
	mut record1 := Record{
		name: 'www'
		text: 'Website'
		category: .a
		addr: ['192.168.1.1', '192.168.1.2']
	}

	name.records << record1

	// Add another record
	mut record2 := Record{
		name: 'mail'
		text: 'Mail server'
		category: .mx
		addr: ['192.168.1.10']
	}

	name.records << record2

	// Add admins
	name.admins << 'admin1-pubkey'
	name.admins << 'admin2-pubkey'

	// Test binary encoding
	binary_data := name.dumps() or {
		assert false, 'Failed to encode name: ${err}'
		return
	}

	// Test binary decoding
	decoded_name := name_loads(binary_data) or {
		assert false, 'Failed to decode name: ${err}'
		return
	}

	// Verify the decoded data matches the original
	assert decoded_name.id == name.id
	assert decoded_name.domain == name.domain
	assert decoded_name.description == name.description

	// Verify records
	assert decoded_name.records.len == name.records.len

	// Verify first record
	assert decoded_name.records[0].name == name.records[0].name
	assert decoded_name.records[0].text == name.records[0].text
	assert decoded_name.records[0].category == name.records[0].category
	assert decoded_name.records[0].addr.len == name.records[0].addr.len
	assert decoded_name.records[0].addr[0] == name.records[0].addr[0]
	assert decoded_name.records[0].addr[1] == name.records[0].addr[1]

	// Verify second record
	assert decoded_name.records[1].name == name.records[1].name
	assert decoded_name.records[1].text == name.records[1].text
	assert decoded_name.records[1].category == name.records[1].category
	assert decoded_name.records[1].addr.len == name.records[1].addr.len
	assert decoded_name.records[1].addr[0] == name.records[1].addr[0]

	// Verify admins
	assert decoded_name.admins.len == name.admins.len
	assert decoded_name.admins[0] == name.admins[0]
	assert decoded_name.admins[1] == name.admins[1]

	println('Name binary encoding/decoding test passed successfully')
}

fn test_name_standalone_index_keys() {
	// Create a test name
	name := Name{
		id: 123
		domain: 'example.com'
		description: 'Test domain'
	}
	
	// Get index keys
	keys := name.index_keys()
	
	// Verify the keys
	assert keys['domain'] == 'example.com'
	assert keys.len == 1 // Should only have 'domain' key
	
	println('Name index_keys test passed successfully')
}

fn test_name_standalone_wrong_encoding_id() {
	// Create invalid data with wrong encoding ID
	mut e := encoder.new()
	e.add_u16(999) // Wrong ID (should be 300)
	
	// Attempt to deserialize and expect error
	result := name_loads(e.data) or {
		assert err.str() == 'Wrong file type: expected encoding ID 300, got 999, for name'
		println('Error handling test (wrong encoding ID) passed successfully')
		return
	}
	
	assert false, 'Should have returned an error for wrong encoding ID'
}

fn test_name_standalone_incomplete_data() {
	// Create incomplete data (missing fields)
	mut e := encoder.new()
	e.add_u16(300) // Correct ID
	e.add_u32(123) // ID
	// Missing other fields
	
	// Attempt to deserialize and expect error
	result := name_loads(e.data) or {
		// Just check that we got an error, without asserting the specific error message
		// since the exact error might differ between environments
		println('Error handling test (incomplete data) passed successfully')
		return
	}
	
	assert false, 'Should have returned an error for incomplete data'
}

fn main() {
	test_name_standalone_dumps_loads()
	test_name_standalone_index_keys()
	test_name_standalone_wrong_encoding_id()
	test_name_standalone_incomplete_data()
	
	println('All Name standalone tests passed successfully')
}