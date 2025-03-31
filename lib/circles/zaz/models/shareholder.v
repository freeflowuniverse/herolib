module models

import freeflowuniverse.herolib.data.ourtime
import freeflowuniverse.herolib.data.encoder

// ShareholderType represents the type of shareholder
pub enum ShareholderType {
	individual
	corporate
}

// Shareholder represents a shareholder of a company
pub struct Shareholder {
pub mut:
	id         u32
	company_id u32
	user_id    u32
	name       string
	shares     f64
	percentage f64
	type_      ShareholderType
	since      ourtime.OurTime
	created_at ourtime.OurTime
	updated_at ourtime.OurTime
}

// dumps serializes the Shareholder to a byte array
pub fn (shareholder Shareholder) dumps() ![]u8 {
	mut enc := encoder.new()

	// Add unique encoding ID to identify this type of data
	enc.add_u16(403) // Unique ID for Shareholder type

	// Encode Shareholder fields
	enc.add_u32(shareholder.id)
	enc.add_u32(shareholder.company_id)
	enc.add_u32(shareholder.user_id)
	enc.add_string(shareholder.name)
	enc.add_string(shareholder.shares.str()) // Store shares as string to preserve precision
	enc.add_string(shareholder.percentage.str()) // Store percentage as string to preserve precision
	enc.add_u8(u8(shareholder.type_))
	enc.add_string(shareholder.since.str())
	enc.add_string(shareholder.created_at.str())
	enc.add_string(shareholder.updated_at.str())

	return enc.data
}

// loads deserializes a byte array to a Shareholder
pub fn shareholder_loads(data []u8) !Shareholder {
	mut d := encoder.decoder_new(data)
	mut shareholder := Shareholder{}

	// Check encoding ID to verify this is the correct type of data
	encoding_id := d.get_u16()!
	if encoding_id != 403 {
		return error('Wrong file type: expected encoding ID 403, got ${encoding_id}, for shareholder')
	}

	// Decode Shareholder fields
	shareholder.id = d.get_u32()!
	shareholder.company_id = d.get_u32()!
	shareholder.user_id = d.get_u32()!
	shareholder.name = d.get_string()!
	shares_str := d.get_string()!
	shareholder.shares = shares_str.f64()
	
	percentage_str := d.get_string()!
	shareholder.percentage = percentage_str.f64()
	
    shareholder.type_ = unsafe { ShareholderType(d.get_u8()!) }
	
	since_str := d.get_string()!
	shareholder.since = ourtime.new(since_str)!
	
	created_at_str := d.get_string()!
	shareholder.created_at = ourtime.new(created_at_str)!
	
	updated_at_str := d.get_string()!
	shareholder.updated_at = ourtime.new(updated_at_str)!

	return shareholder
}

// index_keys returns the keys to be indexed for this shareholder
pub fn (shareholder Shareholder) index_keys() map[string]string {
	mut keys := map[string]string{}
	keys['id'] = shareholder.id.str()
	keys['company_id'] = shareholder.company_id.str()
	keys['user_id'] = shareholder.user_id.str()
	return keys
}
