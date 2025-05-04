module circle

import freeflowuniverse.herolib.data.encoder
import freeflowuniverse.herolib.hero.db.models.circle { Role, User }

// dumps serializes a User struct to binary data
pub fn (user UserObj) dumps() ![]u8 {
	mut e := encoder.new()

	// Add version byte (v1)
	e.add_u8(1)

	// Encode Base struct fields
	e.add_u32(user.Base.id)
	e.add_ourtime(user.Base.creation_time)
	e.add_ourtime(user.Base.mod_time)

	// Encode comments array from Base
	e.add_u16(u16(user.Base.comments.len))
	for id in user.Base.comments {
		e.add_u32(id)
	}

	// Encode User-specific fields
	e.add_string(user.name)
	e.add_string(user.description)
	e.add_u8(u8(user.role)) // Encode enum as u8

	// Encode contact_ids array
	e.add_u16(u16(user.contact_ids.len))
	for id in user.contact_ids {
		e.add_u32(id)
	}

	// Encode wallet_ids array
	e.add_u16(u16(user.wallet_ids.len))
	for id in user.wallet_ids {
		e.add_u32(id)
	}

	// Encode pubkey
	e.add_string(user.pubkey)

	return e.data
}

// loads deserializes binary data to a User struct
pub fn loads_user(data []u8) !User {
	mut d := encoder.decoder_new(data)

	// Read version byte
	version := d.get_u8()!
	if version != 1 {
		return error('Unsupported version: ${version}')
	}

	// Create a new User instance
	mut user := User{}

	// Decode Base struct fields
	user.id = d.get_u32()!
	user.creation_time = d.get_ourtime()!
	user.mod_time = d.get_ourtime()!

	// Decode comments array from Base
	comments_count := d.get_u16()!
	user.comments = []u32{cap: int(comments_count)}
	for _ in 0 .. comments_count {
		user.comments << d.get_u32()!
	}

	// Decode User-specific fields
	user.name = d.get_string()!
	user.description = d.get_string()!
	// Get the u8 value first
	role_value := d.get_u8()!

	// Validate and convert to Role enum
	if role_value <= u8(Role.external) {
		// Use unsafe block for casting number to enum as required by V
		unsafe {
			user.role = Role(role_value)
		}
	} else {
		return error('Invalid role value: ${role_value}')
	}

	// Decode contact_ids array
	contact_count := d.get_u16()!
	user.contact_ids = []u32{cap: int(contact_count)}
	for _ in 0 .. contact_count {
		user.contact_ids << d.get_u32()!
	}

	// Decode wallet_ids array
	wallet_count := d.get_u16()!
	user.wallet_ids = []u32{cap: int(wallet_count)}
	for _ in 0 .. wallet_count {
		user.wallet_ids << d.get_u32()!
	}

	// Decode pubkey
	user.pubkey = d.get_string()!

	return user
}
