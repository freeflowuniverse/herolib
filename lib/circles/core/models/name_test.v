module models

import freeflowuniverse.herolib.data.ourdb
import freeflowuniverse.herolib.data.radixtree
import freeflowuniverse.herolib.core.playbook

fn test_name_dumps_loads() {
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

fn test_name_complex_structure() {
	// Create a more complex name with multiple records of different types
	mut name := Name{
		id: 456
		domain: 'complex-example.org'
		description: 'A complex test domain with multiple records'
	}

	// Add A record
	name.records << Record{
		name: 'www'
		text: 'Web server'
		category: .a
		addr: ['203.0.113.1']
	}

	// Add AAAA record
	name.records << Record{
		name: 'ipv6'
		text: 'IPv6 server'
		category: .aaaa
		addr: ['2001:db8::1']
	}

	// Add CNAME record
	name.records << Record{
		name: 'alias'
		text: 'Alias record'
		category: .cname
		addr: ['www.complex-example.org']
	}

	// Add MX record
	name.records << Record{
		name: 'mail'
		text: 'Mail server'
		category: .mx
		addr: ['mail.complex-example.org']
	}

	// Add NS record
	name.records << Record{
		name: 'ns1'
		text: 'Name server 1'
		category: .ns
		addr: ['ns1.complex-example.org']
	}

	// Add TXT record
	name.records << Record{
		name: 'txt'
		text: 'SPF record'
		category: .txt
		addr: ['v=spf1 include:_spf.complex-example.org ~all']
	}
	
	// Add admins
	name.admins << 'admin-pubkey'
	name.admins << 'backup-admin-pubkey'

	// Test binary encoding
	binary_data := name.dumps() or {
		assert false, 'Failed to encode complex name: ${err}'
		return
	}

	// Test binary decoding
	decoded_name := name_loads(binary_data) or {
		assert false, 'Failed to decode complex name: ${err}'
		return
	}

	// Verify the decoded data matches the original
	assert decoded_name.id == name.id
	assert decoded_name.domain == name.domain
	assert decoded_name.description == name.description
	assert decoded_name.records.len == name.records.len
	assert decoded_name.admins.len == name.admins.len

	// Verify each record type is correctly encoded/decoded
	mut record_types := {
		RecordType.a: 0
		RecordType.aaaa: 0
		RecordType.cname: 0
		RecordType.mx: 0
		RecordType.ns: 0
		RecordType.txt: 0
	}

	for record in decoded_name.records {
		record_types[record.category]++
	}

	assert record_types[RecordType.a] == 1
	assert record_types[RecordType.aaaa] == 1
	assert record_types[RecordType.cname] == 1
	assert record_types[RecordType.mx] == 1
	assert record_types[RecordType.ns] == 1
	assert record_types[RecordType.txt] == 1

	// Verify specific records by name
	for i, record in name.records {
		decoded_record := decoded_name.records[i]
		assert decoded_record.name == record.name
		assert decoded_record.text == record.text
		assert decoded_record.category == record.category
		assert decoded_record.addr.len == record.addr.len
		
		for j, addr in record.addr {
			assert decoded_record.addr[j] == addr
		}
	}

	// Verify admins
	for i, admin in name.admins {
		assert decoded_name.admins[i] == admin
	}

	println('Complex name binary encoding/decoding test passed successfully')
}

fn test_name_empty_records() {
	// Test a name with no records
	name := Name{
		id: 789
		domain: 'empty.example.net'
		description: 'A domain with no records'
		records: []
		admins: ['admin-pubkey']
	}

	// Test binary encoding
	binary_data := name.dumps() or {
		assert false, 'Failed to encode empty name: ${err}'
		return
	}

	// Test binary decoding
	decoded_name := name_loads(binary_data) or {
		assert false, 'Failed to decode empty name: ${err}'
		return
	}

	// Verify the decoded data matches the original
	assert decoded_name.id == name.id
	assert decoded_name.domain == name.domain
	assert decoded_name.description == name.description
	assert decoded_name.records.len == 0
	assert decoded_name.admins.len == 1
	assert decoded_name.admins[0] == name.admins[0]

	println('Empty records name binary encoding/decoding test passed successfully')
}
