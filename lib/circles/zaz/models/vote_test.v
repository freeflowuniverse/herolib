module models

import freeflowuniverse.herolib.data.ourtime
import freeflowuniverse.herolib.data.encoder

fn test_vote_serialization() {
	// Create test data for a vote with options and ballots
	mut vote := Vote{
		id: 1001
		company_id: 2001
		title: 'Annual Board Election'
		description: 'Vote for the new board members'
		start_date: ourtime.new('2025-01-01 00:00:00')!
		end_date: ourtime.new('2025-01-31 23:59:59')!
		status: VoteStatus.open
		created_at: ourtime.new('2024-12-15 10:00:00')!
		updated_at: ourtime.new('2024-12-15 10:00:00')!
		options: []
		ballots: []
	}

	// Add vote options
	vote.options << VoteOption{
		id: 101
		vote_id: 1001
		text: 'Option A'
		count: 0
		min_valid: 10
	}
	vote.options << VoteOption{
		id: 102
		vote_id: 1001
		text: 'Option B'
		count: 0
		min_valid: 5
	}

	// Add ballots
	vote.ballots << Ballot{
		id: 501
		vote_id: 1001
		user_id: 301
		vote_option_id: 101
		shares_count: 100
		created_at: ourtime.new('2025-01-05 14:30:00')!
	}
	vote.ballots << Ballot{
		id: 502
		vote_id: 1001
		user_id: 302
		vote_option_id: 102
		shares_count: 50
		created_at: ourtime.new('2025-01-06 09:15:00')!
	}

	// Test serialization
	serialized := vote.dumps()!

	// Verify correct encoding ID is present (first 2 bytes should contain 406 as u16)
	mut d := encoder.decoder_new(serialized)
	encoding_id := d.get_u16()!
	assert encoding_id == 406, 'Expected encoding ID 406, got ${encoding_id}'

	// Test deserialization
	decoded_vote := vote_loads(serialized)!

	// Verify vote fields
	assert decoded_vote.id == vote.id
	assert decoded_vote.company_id == vote.company_id
	assert decoded_vote.title == vote.title
	assert decoded_vote.description == vote.description
	assert decoded_vote.start_date.str() == vote.start_date.str()
	assert decoded_vote.end_date.str() == vote.end_date.str()
	assert decoded_vote.status == vote.status
	assert decoded_vote.created_at.str() == vote.created_at.str()
	assert decoded_vote.updated_at.str() == vote.updated_at.str()

	// Verify vote options
	assert decoded_vote.options.len == vote.options.len
	for i, option in vote.options {
		decoded_option := decoded_vote.options[i]
		assert decoded_option.id == option.id
		assert decoded_option.vote_id == option.vote_id
		assert decoded_option.text == option.text
		assert decoded_option.count == option.count
		assert decoded_option.min_valid == option.min_valid
	}

	// Verify ballots
	assert decoded_vote.ballots.len == vote.ballots.len
	for i, ballot in vote.ballots {
		decoded_ballot := decoded_vote.ballots[i]
		assert decoded_ballot.id == ballot.id
		assert decoded_ballot.vote_id == ballot.vote_id
		assert decoded_ballot.user_id == ballot.user_id
		assert decoded_ballot.vote_option_id == ballot.vote_option_id
		assert decoded_ballot.shares_count == ballot.shares_count
		assert decoded_ballot.created_at.str() == ballot.created_at.str()
	}
}

fn test_vote_serialization_empty_collections() {
	// Test with empty options and ballots
	mut vote := Vote{
		id: 1002
		company_id: 2001
		title: 'Simple Vote'
		description: 'Vote with no options or ballots yet'
		start_date: ourtime.new('2025-02-01 00:00:00')!
		end_date: ourtime.new('2025-02-28 23:59:59')!
		status: VoteStatus.open
		created_at: ourtime.new('2025-01-15 10:00:00')!
		updated_at: ourtime.new('2025-01-15 10:00:00')!
		options: []
		ballots: []
	}

	// Test serialization
	serialized := vote.dumps()!

	// Test deserialization
	decoded_vote := vote_loads(serialized)!

	// Verify vote fields
	assert decoded_vote.id == vote.id
	assert decoded_vote.company_id == vote.company_id
	assert decoded_vote.title == vote.title
	assert decoded_vote.description == vote.description
	assert decoded_vote.options.len == 0
	assert decoded_vote.ballots.len == 0
}

fn test_vote_index_keys() {
	// Test the index_keys function
	vote := Vote{
		id: 1003
		company_id: 2002
		title: 'Test Vote'
	}

	keys := vote.index_keys()
	
	assert keys['id'] == '1003'
	assert keys['company_id'] == '2002'
}

fn test_vote_serialization_invalid_id() {
	// Create invalid encoded data with wrong encoding ID
	mut enc := encoder.new()
	enc.add_u16(999) // Wrong ID (should be 406)
	
	// Should return an error when decoding
	if res := vote_loads(enc.data) {
		assert false, 'Expected error for wrong encoding ID, but got success'
	} else {
		assert err.msg().contains('Wrong file type: expected encoding ID 406'), 'Unexpected error message: ${err}'
	}
}

fn test_vote_serialization_byte_structure() {
	// Create a simple vote with minimal data for predictable byte structure
	mut vote := Vote{
		id: 5
		company_id: 10
		title: 'Test'
		description: 'Desc'
		start_date: ourtime.new('2025-01-01 00:00:00')!
		end_date: ourtime.new('2025-01-02 00:00:00')!
		status: VoteStatus.open
		created_at: ourtime.new('2025-01-01 00:00:00')!
		updated_at: ourtime.new('2025-01-01 00:00:00')!
		options: []
		ballots: []
	}

	// Add one simple option
	vote.options << VoteOption{
		id: 1
		vote_id: 5
		text: 'Yes'
		count: 0
		min_valid: 1
	}

	// Add one simple ballot
	vote.ballots << Ballot{
		id: 1
		vote_id: 5
		user_id: 1
		vote_option_id: 1
		shares_count: 10
		created_at: ourtime.new('2025-01-01 01:00:00')!
	}

	// Serialize the vote
	serialized := vote.dumps()!
	
	// Create a decoder to check the byte structure
	mut d := encoder.decoder_new(serialized)
	
	// Verify the encoding structure byte by byte
	assert d.get_u16()! == 406 // Encoding ID
	assert d.get_u32()! == 5 // vote.id
	assert d.get_u32()! == 10 // vote.company_id
	assert d.get_string()! == 'Test' // vote.title
	assert d.get_string()! == 'Desc' // vote.description
	start_date := d.get_string()!
	assert start_date.starts_with('2025-01-01 00:00') // vote.start_date
	end_date := d.get_string()!
	assert end_date.starts_with('2025-01-02 00:00') // vote.end_date
	assert d.get_u8()! == u8(VoteStatus.open) // vote.status
	created_at := d.get_string()!
	assert created_at.starts_with('2025-01-01 00:00') // vote.created_at
	updated_at := d.get_string()!
	assert updated_at.starts_with('2025-01-01 00:00') // vote.updated_at
	
	// Options array
	assert d.get_u16()! == 1 // options.len
	assert d.get_u8()! == 1 // option.id
	assert d.get_u32()! == 5 // option.vote_id
	assert d.get_string()! == 'Yes' // option.text
	assert d.get_int()! == 0 // option.count
	assert d.get_int()! == 1 // option.min_valid
	
	// Ballots array
	assert d.get_u16()! == 1 // ballots.len
	assert d.get_u32()! == 1 // ballot.id
	assert d.get_u32()! == 5 // ballot.vote_id
	assert d.get_u32()! == 1 // ballot.user_id
	assert d.get_u8()! == 1 // ballot.vote_option_id
	assert d.get_int()! == 10 // ballot.shares_count
	ballot_created_at := d.get_string()!
	assert ballot_created_at.starts_with('2025-01-01 01:00') // ballot.created_at
	
	// Private group array
	assert d.get_u16()! == 0 // private_group.len
}
