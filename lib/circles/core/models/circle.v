module models

import freeflowuniverse.herolib.data.encoder

// Role represents the role of a member in a circle
pub enum Role {
	admin
	stakeholder
	member
	contributor
	guest
}

// Member represents a member of a circle
pub struct Member {
pub mut:
	pubkeys     []string // public keys of the member
	emails      []string // list of emails
	name        string   // name of the member
	description string   // optional description
	role        Role     // role of the member in the circle
}

// Circle represents a collection of members (users or other circles)
pub struct Circle {
pub mut:
	id          u32      // unique id
	name        string   // name of the circle
	description string   // optional description
	members     []Member // members of the circle
}

pub fn (c Circle) index_keys() map[string]string {
	return {"name": c.name}
}


// dumps serializes the Circle struct to binary format using the encoder
// This implements the Serializer interface
pub fn (c Circle) dumps() ![]u8 {
	mut e := encoder.new()

	// Add unique encoding ID to identify this type of data
	e.add_u16(200)
		
	
	// Encode Circle fields
	e.add_u32(c.id)
	e.add_string(c.name)
	e.add_string(c.description)
	
	// Encode members array
	e.add_u16(u16(c.members.len))
	for member in c.members {
		// Encode Member fields
		// Encode pubkeys array
		e.add_u16(u16(member.pubkeys.len))
		for pubkey in member.pubkeys {
			e.add_string(pubkey)
		}
		
		// Encode emails array
		e.add_u16(u16(member.emails.len))
		for email in member.emails {
			e.add_string(email)
		}
		
		e.add_string(member.name)
		e.add_string(member.description)
		e.add_u8(u8(member.role))
	}
	
	return e.data
}

// loads deserializes binary data into a Circle struct
pub fn circle_loads(data []u8) !Circle {
	mut d := encoder.decoder_new(data)
	mut circle := Circle{}

	// Check encoding ID to verify this is the correct type of data
	encoding_id := d.get_u16()!
	if encoding_id != 200 {
		return error('Wrong file type: expected encoding ID 200, got ${encoding_id}, for circle')
	}
	
	// Decode Circle fields
	circle.id = d.get_u32()!
	circle.name = d.get_string()!
	circle.description = d.get_string()!
	
	// Decode members array
	members_len := d.get_u16()!
	circle.members = []Member{len: int(members_len)}
	for i in 0 .. members_len {
		mut member := Member{}
		
		// Decode Member fields
		// Decode pubkeys array
		pubkeys_len := d.get_u16()!
		member.pubkeys = []string{len: int(pubkeys_len)}
		for j in 0 .. pubkeys_len {
			member.pubkeys[j] = d.get_string()!
		}
		
		// Decode emails array
		emails_len := d.get_u16()!
		member.emails = []string{len: int(emails_len)}
		for j in 0 .. emails_len {
			member.emails[j] = d.get_string()!
		}
		
		member.name = d.get_string()!
		member.description = d.get_string()!
		role_val := d.get_u8()!
		member.role = match role_val {
			0 { Role.admin }
			1 { Role.stakeholder }
			2 { Role.member }
			3 { Role.contributor }
			4 { Role.guest }
			else { return error('Invalid Role value: ${role_val}') }
		}
		
		circle.members[i] = member
	}
	
	return circle
}
