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
	id          u32      // unique id
	pubkeys     []string // public keys of the member
	emails      []string // list of emails
	name        string   // name of the member
	description string   // optional description
	role        Role     // role of the member in the circle
	contact_ids []u32    // IDs of contacts linked to this member
	wallet_ids  []u32    // IDs of wallets owned by this member
}

pub fn (m Member) index_keys() map[string]string {
	return {
		'name': m.name
	}
}

// dumps serializes the Member struct to binary format using the encoder
// This implements the Serializer interface
pub fn (m Member) dumps() ![]u8 {
	mut e := encoder.new()

	// Add unique encoding ID to identify this type of data
	e.add_u16(201)

	// Encode Member fields
	e.add_u32(m.id)
	
	// Encode pubkeys array
	e.add_u16(u16(m.pubkeys.len))
	for pubkey in m.pubkeys {
		e.add_string(pubkey)
	}

	// Encode emails array
	e.add_u16(u16(m.emails.len))
	for email in m.emails {
		e.add_string(email)
	}

	e.add_string(m.name)
	e.add_string(m.description)
	e.add_u8(u8(m.role))

	// Encode contact_ids array
	e.add_u16(u16(m.contact_ids.len))
	for contact_id in m.contact_ids {
		e.add_u32(contact_id)
	}

	// Encode wallet_ids array
	e.add_u16(u16(m.wallet_ids.len))
	for wallet_id in m.wallet_ids {
		e.add_u32(wallet_id)
	}

	return e.data
}

// loads deserializes binary data into a Member struct
pub fn member_loads(data []u8) !Member {
	mut d := encoder.decoder_new(data)
	mut member := Member{}

	// Check encoding ID to verify this is the correct type of data
	encoding_id := d.get_u16()!
	if encoding_id != 201 {
		return error('Wrong file type: expected encoding ID 201, got ${encoding_id}, for member')
	}

	// Decode Member fields
	member.id = d.get_u32()!

	// Decode pubkeys array
	pubkeys_len := d.get_u16()!
	member.pubkeys = []string{len: int(pubkeys_len)}
	for i in 0 .. pubkeys_len {
		member.pubkeys[i] = d.get_string()!
	}

	// Decode emails array
	emails_len := d.get_u16()!
	member.emails = []string{len: int(emails_len)}
	for i in 0 .. emails_len {
		member.emails[i] = d.get_string()!
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

	// Decode contact_ids array
	contact_ids_len := d.get_u16()!
	member.contact_ids = []u32{len: int(contact_ids_len)}
	for i in 0 .. contact_ids_len {
		member.contact_ids[i] = d.get_u32()!
	}

	// Decode wallet_ids array
	wallet_ids_len := d.get_u16()!
	member.wallet_ids = []u32{len: int(wallet_ids_len)}
	for i in 0 .. wallet_ids_len {
		member.wallet_ids[i] = d.get_u32()!
	}

	return member
}

// add_email adds an email to this member
pub fn (mut m Member) add_email(email string) {
	if email !in m.emails {
		m.emails << email
	}
}

// link_contact links a contact to this member
pub fn (mut m Member) link_contact(contact_id u32) {
	if contact_id !in m.contact_ids {
		m.contact_ids << contact_id
	}
}

// link_wallet links a wallet to this member
pub fn (mut m Member) link_wallet(wallet_id u32) {
	if wallet_id !in m.wallet_ids {
		m.wallet_ids << wallet_id
	}
}