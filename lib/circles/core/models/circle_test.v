module models

fn test_circle_dumps_loads() {
	// Create a test circle with some sample data
	mut circle := Circle{
		id: 123
		name: 'Test Circle'
		description: 'A test circle for binary encoding'
	}

	// Add a member
	mut member1 := Member{
		pubkeys: ['user1-pubkey']
		name: 'User One'
		description: 'First test user'
		role: .admin
		emails: ['user1@example.com', 'user.one@example.org']
	}
	
	circle.members << member1

	// Add another member
	mut member2 := Member{
		pubkeys: ['user2-pubkey']
		name: 'User Two'
		description: 'Second test user'
		role: .member
		emails: ['user2@example.com']
	}
	
	circle.members << member2

	// Test binary encoding
	binary_data := circle.dumps() or {
		assert false, 'Failed to encode circle: ${err}'
		return
	}

	// Test binary decoding
	decoded_circle := circle_loads(binary_data) or {
		assert false, 'Failed to decode circle: ${err}'
		return
	}

	// Verify the decoded data matches the original
	assert decoded_circle.id == circle.id
	assert decoded_circle.name == circle.name
	assert decoded_circle.description == circle.description
	
	// Verify members
	assert decoded_circle.members.len == circle.members.len
	
	// Verify first member
	assert decoded_circle.members[0].pubkeys.len == circle.members[0].pubkeys.len
	assert decoded_circle.members[0].pubkeys[0] == circle.members[0].pubkeys[0]
	assert decoded_circle.members[0].name == circle.members[0].name
	assert decoded_circle.members[0].description == circle.members[0].description
	assert decoded_circle.members[0].role == circle.members[0].role
	assert decoded_circle.members[0].emails.len == circle.members[0].emails.len
	assert decoded_circle.members[0].emails[0] == circle.members[0].emails[0]
	assert decoded_circle.members[0].emails[1] == circle.members[0].emails[1]
	
	// Verify second member
	assert decoded_circle.members[1].pubkeys.len == circle.members[1].pubkeys.len
	assert decoded_circle.members[1].pubkeys[0] == circle.members[1].pubkeys[0]
	assert decoded_circle.members[1].name == circle.members[1].name
	assert decoded_circle.members[1].description == circle.members[1].description
	assert decoded_circle.members[1].role == circle.members[1].role
	assert decoded_circle.members[1].emails.len == circle.members[1].emails.len
	assert decoded_circle.members[1].emails[0] == circle.members[1].emails[0]

	println('Circle binary encoding/decoding test passed successfully')
}

fn test_circle_complex_structure() {
	// Create a more complex circle with multiple members of different roles
	mut circle := Circle{
		id: 456
		name: 'Complex Test Circle'
		description: 'A complex test circle with multiple members'
	}

	// Add admin member
	circle.members << Member{
		pubkeys: ['admin-pubkey']
		name: 'Admin User'
		description: 'Circle administrator'
		role: .admin
		emails: ['admin@example.com']
	}

	// Add stakeholder member
	circle.members << Member{
		pubkeys: ['stakeholder-pubkey']
		name: 'Stakeholder User'
		description: 'Circle stakeholder'
		role: .stakeholder
		emails: ['stakeholder@example.com', 'stakeholder@company.com']
	}

	// Add regular members
	circle.members << Member{
		pubkeys: ['member1-pubkey']
		name: 'Regular Member 1'
		description: 'First regular member'
		role: .member
		emails: ['member1@example.com']
	}

	circle.members << Member{
		pubkeys: ['member2-pubkey']
		name: 'Regular Member 2'
		description: 'Second regular member'
		role: .member
		emails: ['member2@example.com']
	}

	// Add contributor
	circle.members << Member{
		pubkeys: ['contributor-pubkey']
		name: 'Contributor'
		description: 'Circle contributor'
		role: .contributor
		emails: ['contributor@example.com']
	}

	// Add guest
	circle.members << Member{
		pubkeys: ['guest-pubkey']
		name: 'Guest User'
		description: 'Circle guest'
		role: .guest
		emails: ['guest@example.com']
	}

	// Test binary encoding
	binary_data := circle.dumps() or {
		assert false, 'Failed to encode complex circle: ${err}'
		return
	}

	// Test binary decoding
	decoded_circle := circle_loads(binary_data) or {
		assert false, 'Failed to decode complex circle: ${err}'
		return
	}

	// Verify the decoded data matches the original
	assert decoded_circle.id == circle.id
	assert decoded_circle.name == circle.name
	assert decoded_circle.description == circle.description
	assert decoded_circle.members.len == circle.members.len

	// Verify each member type is correctly encoded/decoded
	mut role_counts := {
		Role.admin: 0
		Role.stakeholder: 0
		Role.member: 0
		Role.contributor: 0
		Role.guest: 0
	}

	for member in decoded_circle.members {
		role_counts[member.role]++
	}

	assert role_counts[Role.admin] == 1
	assert role_counts[Role.stakeholder] == 1
	assert role_counts[Role.member] == 2
	assert role_counts[Role.contributor] == 1
	assert role_counts[Role.guest] == 1

	// Verify specific members by pubkeys
	for i, member in circle.members {
		decoded_member := decoded_circle.members[i]
		assert decoded_member.pubkeys.len == member.pubkeys.len
		assert decoded_member.pubkeys[0] == member.pubkeys[0]
		assert decoded_member.name == member.name
		assert decoded_member.description == member.description
		assert decoded_member.role == member.role
		assert decoded_member.emails.len == member.emails.len
		
		for j, email in member.emails {
			assert decoded_member.emails[j] == email
		}
	}

	println('Complex circle binary encoding/decoding test passed successfully')
}

fn test_circle_empty_members() {
	// Test a circle with no members
	circle := Circle{
		id: 789
		name: 'Empty Circle'
		description: 'A circle with no members'
		members: []
	}

	// Test binary encoding
	binary_data := circle.dumps() or {
		assert false, 'Failed to encode empty circle: ${err}'
		return
	}

	// Test binary decoding
	decoded_circle := circle_loads(binary_data) or {
		assert false, 'Failed to decode empty circle: ${err}'
		return
	}

	// Verify the decoded data matches the original
	assert decoded_circle.id == circle.id
	assert decoded_circle.name == circle.name
	assert decoded_circle.description == circle.description
	assert decoded_circle.members.len == 0

	println('Empty circle binary encoding/decoding test passed successfully')
}
