module core

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
	text string
	category    RecordType     // role of the member in the circle
	addr []string //the multiple ipaddresses for this record
}

// Circle represents a collection of members (users or other circles)
pub struct Name {
pub mut:
	id          u32   // unique id
	domain string
	description string   // optional description
	records     []Record // members of the circle
	admins []string //pubkeys who can change it
}

pub fn (n Name) index_keys() map[string]string {
	return {"domain": n.domain}
}

// dumps serializes the Name struct to binary format using the encoder
// This implements the Serializer interface
pub fn (n Name) dumps() ![]u8 {
	mut e := encoder.new()

	// Add unique encoding ID to identify this type of data
	e.add_u16(300)
		
	// Encode Name fields
	e.add_u32(n.id)
	e.add_string(n.domain)
	e.add_string(n.description)
	
	// Encode records array
	e.add_u16(u16(n.records.len))
	for record in n.records {
		// Encode Record fields
		e.add_string(record.name)
		e.add_string(record.text)
		e.add_u8(u8(record.category))
		
		// Encode addresses array
		e.add_u16(u16(record.addr.len))
		for addr in record.addr {
			e.add_string(addr)
		}
	}
	
	// Encode admins array
	e.add_u16(u16(n.admins.len))
	for admin in n.admins {
		e.add_string(admin)
	}
	
	return e.data
}

// loads deserializes binary data into a Name struct
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
	name.domain = d.get_string()!
	name.description = d.get_string()!
	
	// Decode records array
	records_len := d.get_u16()!
	name.records = []Record{len: int(records_len)}
	for i in 0 .. records_len {
		mut record := Record{}
		
		// Decode Record fields
		record.name = d.get_string()!
		record.text = d.get_string()!
		category_val := d.get_u8()!
		record.category = match category_val {
			0 { RecordType.a }
			1 { RecordType.aaaa }
			2 { RecordType.cname }
			3 { RecordType.mx }
			4 { RecordType.ns }
			5 { RecordType.ptr }
			6 { RecordType.soa }
			7 { RecordType.srv }
			8 { RecordType.txt }
			else { return error('Invalid RecordType value: ${category_val}') }
		}
		
		// Decode addr array
		addr_len := d.get_u16()!
		record.addr = []string{len: int(addr_len)}
		for j in 0 .. addr_len {
			record.addr[j] = d.get_string()!
		}
		
		name.records[i] = record
	}
	
	// Decode admins array
	admins_len := d.get_u16()!
	name.admins = []string{len: int(admins_len)}
	for i in 0 .. admins_len {
		name.admins[i] = d.get_string()!
	}
	
	return name
}



