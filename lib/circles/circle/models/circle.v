module models

import freeflowuniverse.herolib.data.encoder
// We need to use the Member and Role types from the same module

// Circle represents a collection of members (users or other circles)
pub struct Circle {
pub mut:
	id          u32      // unique id
	name        string   // name of the circle
	description string   // optional description
	members     []u32 // pointers to the members of this circle
}

pub fn (c Circle) index_keys() map[string]string {
	return {
		'name': c.name
	}
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
	
	// Encode members array (simplified for testing)
	e.add_u16(u16(c.members.len))
	for member_id in c.members {
		e.add_u32(member_id)
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

	// Decode members array (just the member IDs)
	members_len := d.get_u16()!
	circle.members = []u32{len: int(members_len)}
	for i in 0 .. members_len {
		circle.members[i] = d.get_u32()!
	}

	return circle
}
