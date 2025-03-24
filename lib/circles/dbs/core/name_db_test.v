module core

import os
import rand
import freeflowuniverse.herolib.circles.actionprocessor
import freeflowuniverse.herolib.circles.models.core

fn test_name_db() {
	// Create a temporary directory for testing
	test_dir := os.join_path(os.temp_dir(), 'hero_name_test_${rand.intn(9000) or { 0 } + 1000}')
	os.mkdir_all(test_dir) or { panic(err) }
	defer { os.rmdir_all(test_dir) or {} }
	
	mut runner := actionprocessor.new(path: test_dir)!

	// Create multiple names for testing
	mut name1 := runner.names.new()
	name1.domain = 'example.com'
	name1.description = 'Example Domain'
	name1.admins = ['admin1_pubkey']

	mut name2 := runner.names.new()
	name2.domain = 'test.org'
	name2.description = 'Test Organization'
	name2.admins = ['admin2_pubkey']

	mut name3 := runner.names.new()
	name3.domain = 'herolib.io'
	name3.description = 'HeroLib Website'
	name3.admins = ['admin3_pubkey']

	// Create records for testing
	mut record1 := core.Record{
		name: 'www'
		text: 'Web server'
		category: .a
		addr: ['192.168.1.1', '192.168.1.2']
	}

	mut record2 := core.Record{
		name: 'mail'
		text: 'Mail server'
		category: .mx
		addr: ['192.168.2.1']
	}

	// Add records to name1
	name1.records << record1
	name1.records << record2

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
		} else if name.domain == 'test.org' {
			found2 = true
		} else if name.domain == 'herolib.io' {
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
	assert retrieved_name1.records.len == 2
	assert retrieved_name1.records[0].name == 'www'
	assert retrieved_name1.records[0].category == .a
	assert retrieved_name1.records[1].name == 'mail'
	assert retrieved_name1.records[1].category == .mx
	assert retrieved_name1.admins.len == 1
	assert retrieved_name1.admins[0] == 'admin1_pubkey'

	// Test add_record method
	println('Testing add_record method')
	mut record3 := core.Record{
		name: 'api'
		text: 'API server'
		category: .a
		addr: ['192.168.3.1']
	}
	
	runner.names.add_record('test.org', record3)!
	updated_name2 := runner.names.get_by_domain('test.org')!
	assert updated_name2.records.len == 1
	assert updated_name2.records[0].name == 'api'
	assert updated_name2.records[0].category == .a
	assert updated_name2.records[0].text == 'API server'

	// Test update_record_text method
	println('Testing update_record_text method')
	runner.names.update_record_text('test.org', 'api', .a, 'Updated API server')!
	text_updated_name2 := runner.names.get_by_domain('test.org')!
	assert text_updated_name2.records[0].text == 'Updated API server'

	// Test remove_record method
	println('Testing remove_record method')
	runner.names.remove_record('example.com', 'mail', .mx)!
	record_removed_name1 := runner.names.get_by_domain('example.com')!
	assert record_removed_name1.records.len == 1
	assert record_removed_name1.records[0].name == 'www'

	// Test add_admin method
	println('Testing add_admin method')
	runner.names.add_admin('example.com', 'new_admin_pubkey')!
	admin_added_name1 := runner.names.get_by_domain('example.com')!
	assert admin_added_name1.admins.len == 2
	assert 'new_admin_pubkey' in admin_added_name1.admins

	// Test remove_admin method
	println('Testing remove_admin method')
	runner.names.remove_admin('example.com', 'admin1_pubkey')!
	admin_removed_name1 := runner.names.get_by_domain('example.com')!
	assert admin_removed_name1.admins.len == 1
	assert admin_removed_name1.admins[0] == 'new_admin_pubkey'

	// Test get_all_domains method
	println('Testing get_all_domains method')
	domains := runner.names.get_all_domains()!
	assert domains.len == 3
	assert 'example.com' in domains
	assert 'test.org' in domains
	assert 'herolib.io' in domains

	// Test delete functionality
	println('Testing delete functionality')
	// Delete name 2
	runner.names.delete_by_domain('test.org')!
	
	// Verify deletion with list
	names_after_delete := runner.names.getall()!
	assert names_after_delete.len == 2, 'Expected 2 names after deletion, got ${names_after_delete.len}'
	
	// Verify the remaining names
	mut found_after_delete1 := false
	mut found_after_delete2 := false
	mut found_after_delete3 := false
	
	for name in names_after_delete {
		if name.domain == 'example.com' {
			found_after_delete1 = true
		} else if name.domain == 'test.org' {
			found_after_delete2 = true
		} else if name.domain == 'herolib.io' {
			found_after_delete3 = true
		}
	}
	
	assert found_after_delete1, 'Name 1 not found after deletion'
	assert !found_after_delete2, 'Name 2 found after deletion (should be deleted)'
	assert found_after_delete3, 'Name 3 not found after deletion'

	// Delete another name
	println('Deleting another name')
	runner.names.delete_by_domain('herolib.io')!
	
	// Verify only one name remains
	names_after_second_delete := runner.names.getall()!
	assert names_after_second_delete.len == 1, 'Expected 1 name after second deletion, got ${names_after_second_delete.len}'
	assert names_after_second_delete[0].domain == 'example.com', 'Remaining name should be example.com'

	// Delete the last name
	println('Deleting last name')
	runner.names.delete_by_domain('example.com')!
	
	// Verify no names remain
	names_after_all_deleted := runner.names.getall() or {
		// This is expected to fail with 'No names found' error
		assert err.msg().contains('No index keys defined for this type') || err.msg().contains('No names found')
		[]core.Name{cap: 0}
	}
	assert names_after_all_deleted.len == 0, 'Expected 0 names after all deletions, got ${names_after_all_deleted.len}'

	println('All tests passed successfully')
}
