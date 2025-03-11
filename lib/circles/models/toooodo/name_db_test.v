module core

import os
import rand

fn test_name_db() {
	// Create a temporary directory for testing
	test_dir := os.join_path(os.temp_dir(), 'hero_name_test_${rand.intn(9000) or { 0 } + 1000}')
	os.mkdir_all(test_dir) or { panic(err) }
	defer { os.rmdir_all(test_dir) or {} }
	
	mut runner := new(path: test_dir)!

	// Create multiple names for testing
	mut name1 := runner.names.new()
	name1.domain = 'example.com'
	name1.description = 'Example domain'
	name1.admins = ['admin1-pubkey']

	mut name2 := runner.names.new()
	name2.domain = 'example.org'
	name2.description = 'Example organization domain'
	name2.admins = ['admin2-pubkey']

	mut name3 := runner.names.new()
	name3.domain = 'example.net'
	name3.description = 'Example network domain'
	name3.admins = ['admin3-pubkey']

	// Add the names
	println('Adding name 1')
	name1 = runner.names.set(name1)!
	
	// Explicitly set different IDs for each name to avoid overwriting
	name2.id = 1 // Set a different ID for name2
	println('Adding name 2')
	name2 = runner.names.set(name2)!
	
	name3.id = 2 // Set a different ID for name3
	println('Adding name 3')
	name3 = runner.names.set(name3)!

	// Test list functionality
	println('Testing list functionality')
	
	// Debug: Print the name IDs in the list
	name_ids := runner.names.list()!
	println('Name IDs in list: ${name_ids}')
	
	// Get all names
	all_names := runner.names.getall()!
	println('Retrieved ${all_names.len} names')
	for i, name in all_names {
		println('Name ${i}: id=${name.id}, domain=${name.domain}')
	}
	
	assert all_names.len == 3, 'Expected 3 names, got ${all_names.len}'
	
	// Verify all names are in the list
	mut found1 := false
	mut found2 := false
	mut found3 := false
	
	for name in all_names {
		if name.domain == 'example.com' {
			found1 = true
		} else if name.domain == 'example.org' {
			found2 = true
		} else if name.domain == 'example.net' {
			found3 = true
		}
	}
	
	assert found1, 'Name 1 not found in list'
	assert found2, 'Name 2 not found in list'
	assert found3, 'Name 3 not found in list'

	// Get and verify individual names
	println('Verifying individual names')
	retrieved_name1 := runner.names.get_by_domain('example.com')!
	assert retrieved_name1.domain == name1.domain
	assert retrieved_name1.description == name1.description
	assert retrieved_name1.records.len == 0
	assert retrieved_name1.admins.len == 1
	assert retrieved_name1.admins[0] == 'admin1-pubkey'

	// Test adding records to a name
	println('Testing adding records to a name')
	
	// Create records
	mut record1 := Record{
		name: 'www'
		text: 'Website'
		category: .a
		addr: ['192.168.1.1']
	}
	
	mut record2 := Record{
		name: 'mail'
		text: 'Mail server'
		category: .mx
		addr: ['mail.example.com']
	}
	
	mut record3 := Record{
		name: 'txt'
		text: 'SPF record'
		category: .txt
		addr: ['v=spf1 include:_spf.example.com ~all']
	}
	
	// Add records to name 1
	runner.names.add_record(name1.id, record1)!
	runner.names.add_record(name1.id, record2)!
	runner.names.add_record(name1.id, record3)!
	
	// Verify records were added
	updated_name1 := runner.names.get(name1.id)!
	assert updated_name1.records.len == 3, 'Expected 3 records, got ${updated_name1.records.len}'
	
	// Test get_records functionality
	println('Testing get_records functionality')
	records := runner.names.get_records(name1.id)!
	assert records.len == 3, 'Expected 3 records, got ${records.len}'
	
	// Test get_records_by_category functionality
	println('Testing get_records_by_category functionality')
	a_records := runner.names.get_records_by_category(name1.id, .a)!
	assert a_records.len == 1, 'Expected 1 A record, got ${a_records.len}'
	assert a_records[0].name == 'www'
	
	mx_records := runner.names.get_records_by_category(name1.id, .mx)!
	assert mx_records.len == 1, 'Expected 1 MX record, got ${mx_records.len}'
	assert mx_records[0].name == 'mail'
	
	txt_records := runner.names.get_records_by_category(name1.id, .txt)!
	assert txt_records.len == 1, 'Expected 1 TXT record, got ${txt_records.len}'
	assert txt_records[0].name == 'txt'
	
	// Test update_record functionality
	println('Testing update_record functionality')
	mut updated_record := Record{
		name: 'www'
		text: 'Updated website'
		category: .a
		addr: ['192.168.1.1', '192.168.1.2'] // Added a second IP
	}
	
	runner.names.update_record(name1.id, 'www', .a, updated_record)!
	
	// Verify record was updated
	updated_name_after_record_change := runner.names.get(name1.id)!
	mut found_updated_record := false
	
	for record in updated_name_after_record_change.records {
		if record.name == 'www' && record.category == .a {
			assert record.text == 'Updated website', 'Expected text to be "Updated website", got "${record.text}"'
			assert record.addr.len == 2, 'Expected 2 addresses, got ${record.addr.len}'
			found_updated_record = true
		}
	}
	
	assert found_updated_record, 'Updated record not found after update'
	
	// Test remove_record functionality
	println('Testing remove_record functionality')
	runner.names.remove_record(name1.id, 'txt', .txt)!
	
	// Verify record was removed
	updated_name_after_removal := runner.names.get(name1.id)!
	assert updated_name_after_removal.records.len == 2, 'Expected 2 records after removal, got ${updated_name_after_removal.records.len}'
	
	mut found_txt_record := false
	for record in updated_name_after_removal.records {
		if record.name == 'txt' && record.category == .txt {
			found_txt_record = true
		}
	}
	
	assert !found_txt_record, 'TXT record still found after removal'
	
	// Test admin management
	println('Testing admin management')
	
	// Add admin
	runner.names.add_admin(name1.id, 'admin2-pubkey')!
	
	// Verify admin was added
	updated_name_after_admin_add := runner.names.get(name1.id)!
	assert updated_name_after_admin_add.admins.len == 2, 'Expected 2 admins after addition, got ${updated_name_after_admin_add.admins.len}'
	assert 'admin2-pubkey' in updated_name_after_admin_add.admins, 'New admin not found after addition'
	
	// Remove admin
	runner.names.remove_admin(name1.id, 'admin2-pubkey')!
	
	// Verify admin was removed
	updated_name_after_admin_removal := runner.names.get(name1.id)!
	assert updated_name_after_admin_removal.admins.len == 1, 'Expected 1 admin after removal, got ${updated_name_after_admin_removal.admins.len}'
	assert 'admin2-pubkey' !in updated_name_after_admin_removal.admins, 'Removed admin still found after removal'
	
	// Test delete_by_domain functionality
	println('Testing delete_by_domain functionality')
	runner.names.delete_by_domain('example.org')!
	
	// Verify deletion
	names_after_delete := runner.names.getall()!
	assert names_after_delete.len == 2, 'Expected 2 names after deletion, got ${names_after_delete.len}'
	
	mut found_org := false
	for name in names_after_delete {
		if name.domain == 'example.org' {
			found_org = true
		}
	}
	
	assert !found_org, 'example.org still found after deletion'
	
	// Delete remaining names
	println('Deleting remaining names')
	runner.names.delete_by_domain('example.com')!
	runner.names.delete_by_domain('example.net')!
	
	// Verify all names are deleted
	names_after_all_deleted := runner.names.getall() or {
		// This is expected to fail with 'No names found' error
		assert err.msg().contains('not found'), 'Expected error message to contain "not found"'
		[]Name{}
	}
	assert names_after_all_deleted.len == 0, 'Expected 0 names after all deletions, got ${names_after_all_deleted.len}'

	println('All name manager tests passed successfully')
}



fn test_name_play() {

	test_dir := os.join_path(os.temp_dir(), 'hero_name_test_${rand.intn(9000) or { 0 } + 1000}')
	os.mkdir_all(test_dir) or { panic(err) }
	defer { os.rmdir_all(test_dir) or {} }
	
	mut runner := new(path: test_dir)!

	
	// Create heroscript for testing
	heroscript_text := "
	!!name.create
		domain: 'example.org'
		description: 'Example domain for testing'
		admins: 'admin1-pubkey,admin2-pubkey'
	
	!!name.add_record
		domain: 'example.org'
		name: 'www'
		type: 'a'
		addrs: '192.168.1.1,192.168.1.2'
		text: 'Web server'
	
	!!name.add_record
		domain: 'example.org'
		name: 'mail'
		type: 'mx'
		addr: '192.168.1.10'
		text: 'Mail server'
	
	!!name.add_admin
		domain: 'example.org'
		pubkey: 'admin3-pubkey'
	"
	
	// Parse the heroscript
	mut pb := playbook.new(text: heroscript_text)!

	name_manager:=runner.names

	runner.names.play(mut pb)!

	// Verify the domain was created
	mut names := name_manager.getall()!
	assert names.len == 1
	
	// Get the created domain
	mut name := name_manager.get_by_domain('example.org')!
	
	// Verify domain properties
	assert name.domain == 'example.org'
	assert name.description == 'Example domain for testing'
	
	// Verify admins
	assert name.admins.len == 3
	assert 'admin1-pubkey' in name.admins
	assert 'admin2-pubkey' in name.admins
	assert 'admin3-pubkey' in name.admins
	
	// Verify records
	assert name.records.len == 2
	
	// Find and verify the www record
	mut www_record := Record{}
	mut mail_record := Record{}
	
	for record in name.records {
		if record.name == 'www' {
			www_record = record
		} else if record.name == 'mail' {
			mail_record = record
		}
	}
	
	// Verify www record
	assert www_record.name == 'www'
	assert www_record.category == RecordType.a
	assert www_record.text == 'Web server'
	assert www_record.addr.len == 2
	assert www_record.addr[0] == '192.168.1.1'
	assert www_record.addr[1] == '192.168.1.2'
	
	// Verify mail record
	assert mail_record.name == 'mail'
	assert mail_record.category == RecordType.mx
	assert mail_record.text == 'Mail server'
	assert mail_record.addr.len == 1
	assert mail_record.addr[0] == '192.168.1.10'
	
	// No need to explicitly close the databases
	
	println('Name play heroscript test passed successfully')
}
