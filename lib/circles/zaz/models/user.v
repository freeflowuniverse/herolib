module models

import freeflowuniverse.herolib.data.ourtime
import freeflowuniverse.herolib.data.encoder

// User represents a user in the Freezone Manager system
pub struct User {
pub mut:
	id        u32
	name      string
	email     string
	password  string
	company   string //here its just a best effort
	role      string
	created_at ourtime.OurTime
	updated_at ourtime.OurTime
}

// dumps serializes the User to a byte array
pub fn (user User) dumps() ![]u8 {
	mut enc := encoder.new()

	// Add unique encoding ID to identify this type of data
	enc.add_u16(401) // Unique ID for User type

	// Encode User fields
	enc.add_u32(user.id)
	enc.add_string(user.name)
	enc.add_string(user.email)
	enc.add_string(user.password)
	enc.add_string(user.company)
	enc.add_string(user.role)
	enc.add_string(user.created_at.str())
	enc.add_string(user.updated_at.str())

	return enc.data
}

// loads deserializes a byte array to a User
pub fn user_loads(data []u8) !User {
	mut d := encoder.decoder_new(data)
	mut user := User{}

	// Check encoding ID to verify this is the correct type of data
	encoding_id := d.get_u16()!
	if encoding_id != 401 {
		return error('Wrong file type: expected encoding ID 401, got ${encoding_id}, for user')
	}

	// Decode User fields
	user.id = d.get_u32()!
	user.name = d.get_string()!
	user.email = d.get_string()!
	user.password = d.get_string()!
	user.company = d.get_string()!
	user.role = d.get_string()!
	
	created_at_str := d.get_string()!
	user.created_at = ourtime.new(created_at_str)!
	
	updated_at_str := d.get_string()!
	user.updated_at = ourtime.new(updated_at_str)!

	return user
}

// index_keys returns the keys to be indexed for this user
pub fn (user User) index_keys() map[string]string {
	mut keys := map[string]string{}
	keys['id'] = user.id.str()
	keys['email'] = user.email
	return keys
}
