module models

import freeflowuniverse.herolib.data.ourtime
import freeflowuniverse.herolib.data.encoder

// VoteStatus represents the status of a vote
pub enum VoteStatus {
	open
	closed
	cancelled
}

// Vote represents a voting item in the Freezone
pub struct Vote {
pub mut:
	id            u32
	company_id    u32
	title         string
	description   string
	start_date    ourtime.OurTime
	end_date      ourtime.OurTime
	status        VoteStatus
	created_at    ourtime.OurTime
	updated_at    ourtime.OurTime
	options       []VoteOption
	ballots       []Ballot
	private_group []u32 // user id's only people who can vote
}

// VoteOption represents an option in a vote
pub struct VoteOption {
pub mut:
	id         u8
	vote_id    u32
	text       string
	count      int
	min_valid  int // min votes we need to make total vote count
}

// the vote as done by the user
pub struct Ballot {
pub mut:
	id             u32
	vote_id        u32
	user_id        u32
	vote_option_id u8
	shares_count   int
	created_at     ourtime.OurTime
}

// dumps serializes the Vote to a byte array
pub fn (vote Vote) dumps() ![]u8 {
	mut enc := encoder.new()

	// Add unique encoding ID to identify this type of data
	enc.add_u16(406) // Unique ID for Vote type

	// Encode Vote fields
	enc.add_u32(vote.id)
	enc.add_u32(vote.company_id)
	enc.add_string(vote.title)
	enc.add_string(vote.description)
	enc.add_string(vote.start_date.str())
	enc.add_string(vote.end_date.str())
	enc.add_u8(u8(vote.status))
	enc.add_string(vote.created_at.str())
	enc.add_string(vote.updated_at.str())

	// Encode options array
	enc.add_u16(u16(vote.options.len))
	for option in vote.options {
		enc.add_u8(option.id)
		enc.add_u32(option.vote_id)
		enc.add_string(option.text)
		enc.add_int(option.count)
		enc.add_int(option.min_valid)
	}

	// Encode ballots array
	enc.add_u16(u16(vote.ballots.len))
	for ballot in vote.ballots {
		enc.add_u32(ballot.id)
		enc.add_u32(ballot.vote_id)
		enc.add_u32(ballot.user_id)
		enc.add_u8(ballot.vote_option_id)
		enc.add_int(ballot.shares_count)
		enc.add_string(ballot.created_at.str())
	}

	// Encode private_group array
	enc.add_u16(u16(vote.private_group.len))
	for user_id in vote.private_group {
		enc.add_u32(user_id)
	}

	return enc.data
}

// loads deserializes a byte array to a Vote
pub fn vote_loads(data []u8) !Vote {
	mut d := encoder.decoder_new(data)
	mut vote := Vote{}

	// Check encoding ID to verify this is the correct type of data
	encoding_id := d.get_u16()!
	if encoding_id != 406 {
		return error('Wrong file type: expected encoding ID 406, got ${encoding_id}, for vote')
	}

	// Decode Vote fields
	vote.id = d.get_u32()!
	vote.company_id = d.get_u32()!
	vote.title = d.get_string()!
	vote.description = d.get_string()!
	
	start_date_str := d.get_string()!
	vote.start_date = ourtime.new(start_date_str)!
	
	end_date_str := d.get_string()!
	vote.end_date = ourtime.new(end_date_str)!
	
	vote.status = VoteStatus(d.get_u8()!)
	
	created_at_str := d.get_string()!
	vote.created_at = ourtime.new(created_at_str)!
	
	updated_at_str := d.get_string()!
	vote.updated_at = ourtime.new(updated_at_str)!

	// Decode options array
	options_len := d.get_u16()!
	vote.options = []VoteOption{len: int(options_len)}
	for i in 0 .. options_len {
		mut option := VoteOption{}
		option.id = d.get_u8()!
		option.vote_id = d.get_u32()!
		option.text = d.get_string()!
		option.count = d.get_int()!
		option.min_valid = d.get_int()!
		vote.options[i] = option
	}

	// Decode ballots array
	ballots_len := d.get_u16()!
	vote.ballots = []Ballot{len: int(ballots_len)}
	for i in 0 .. ballots_len {
		mut ballot := Ballot{}
		ballot.id = d.get_u32()!
		ballot.vote_id = d.get_u32()!
		ballot.user_id = d.get_u32()!
		ballot.vote_option_id = d.get_u8()!
		ballot.shares_count = d.get_int()!
		
		ballot_created_at_str := d.get_string()!
		ballot.created_at = ourtime.new(ballot_created_at_str)!
		
		vote.ballots[i] = ballot
	}

	// Decode private_group array
	private_group_len := d.get_u16()!
	vote.private_group = []u32{len: int(private_group_len)}
	for i in 0 .. private_group_len {
		vote.private_group[i] = d.get_u32()!
	}

	return vote
}

// index_keys returns the keys to be indexed for this vote
pub fn (vote Vote) index_keys() map[string]string {
	mut keys := map[string]string{}
	keys['id'] = vote.id.str()
	keys['company_id'] = vote.company_id.str()
	return keys
}
