module model

import freeflowuniverse.herolib.data.encoder

// record types for a DNS record
pub enum RecordType {
	a
	aaaa
	cname
	mx
	ns
	ptr
	soa
	srv
	txt
}

// represents a DNS record
pub struct Record {
pub mut:
	name        string   // name of the record
	category    RecordType     // role of the member in the circle
}

// Circle represents a collection of members (users or other circles)
pub struct Name {
pub mut:
	id          u32   // unique id
	description string   // optional description
	records     []Record // members of the circle
}

// dumps serializes the Circle struct to binary format using the encoder
pub fn (c Name) dumps() ![]u8 {
	mut e := encoder.new()

	// Add unique encoding ID to identify this type of data
	e.add_u16(300)
		
	//TODO implement

	return e.data
}

// loads deserializes binary data into a Circle struct
pub fn name_loads(data []u8) !Name {
	mut d := encoder.decoder_new(data)
	mut name := Name{}

	// Check encoding ID to verify this is the correct type of data
	encoding_id := d.get_u16()!
	if encoding_id != 300 {
		return error('Wrong file type: expected encoding ID 300, got ${encoding_id}, for name')
	}
	
	// Decode Name fields
	name.id = d.get_u32()!
	name.description = d.get_string()!

	//TODO implement

	return name
}
