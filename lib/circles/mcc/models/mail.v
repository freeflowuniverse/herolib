module models

import freeflowuniverse.herolib.data.encoder
import time

// Email represents an email message with all its metadata and content
pub struct Email {
pub mut:
	// Database ID
	id u32 // Database ID (assigned by DBHandler)
	message_id  string       // Unique identifier for the email
	folder      string       // The folder this email belongs to (inbox, sent, drafts, etc.)
	message     string       // The email body content
	attachments []Attachment // Any file attachments
	
	date        i64          // Unix timestamp when the email was sent/received
	size        u32          // Size of the message in bytes
	read        bool         // Whether the email has been read
	flagged     bool         // Whether the email has been flagged/starred
	
	// Header information
	subject     string
	from        []string
	sender      []string
	reply_to    []string
	to          []string
	cc          []string
	bcc         []string
	in_reply_to string
}

// Attachment represents an email attachment
pub struct Attachment {
pub mut:
	filename     string
	content_type string
	data         string // Base64 encoded binary data
}

pub fn (e Email) index_keys() map[string]string {
	return {
		'message_id': e.message_id
	}
}

// dumps serializes the Email struct to binary format using the encoder
// This implements the Serializer interface
pub fn (e Email) dumps() ![]u8 {
	mut enc := encoder.new()

	// Add unique encoding ID to identify this type of data
	enc.add_u16(301) // Unique ID for Email type

	// Encode Email fields
	enc.add_u32(e.id)
	enc.add_string(e.message_id)
	enc.add_string(e.folder)
	enc.add_string(e.message)

	// Encode attachments array
	enc.add_u16(u16(e.attachments.len))
	for attachment in e.attachments {
		enc.add_string(attachment.filename)
		enc.add_string(attachment.content_type)
		enc.add_string(attachment.data)
	}

	enc.add_i64(e.date)
	enc.add_u32(e.size)
	enc.add_u8(if e.read { 1 } else { 0 })
	enc.add_u8(if e.flagged { 1 } else { 0 })
	
	// Encode header information
	enc.add_string(e.subject)
	
	// Encode from addresses
	enc.add_u16(u16(e.from.len))
	for addr in e.from {
		enc.add_string(addr)
	}
	
	// Encode sender addresses
	enc.add_u16(u16(e.sender.len))
	for addr in e.sender {
		enc.add_string(addr)
	}
	
	// Encode reply_to addresses
	enc.add_u16(u16(e.reply_to.len))
	for addr in e.reply_to {
		enc.add_string(addr)
	}
	
	// Encode to addresses
	enc.add_u16(u16(e.to.len))
	for addr in e.to {
		enc.add_string(addr)
	}
	
	// Encode cc addresses
	enc.add_u16(u16(e.cc.len))
	for addr in e.cc {
		enc.add_string(addr)
	}
	
	// Encode bcc addresses
	enc.add_u16(u16(e.bcc.len))
	for addr in e.bcc {
		enc.add_string(addr)
	}
	
	enc.add_string(e.in_reply_to)

	return enc.data
}

// loads deserializes binary data into an Email struct
pub fn email_loads(data []u8) !Email {
	mut d := encoder.decoder_new(data)
	mut email := Email{}

	// Check encoding ID to verify this is the correct type of data
	encoding_id := d.get_u16()!
	if encoding_id != 301 {
		return error('Wrong file type: expected encoding ID 301, got ${encoding_id}, for email')
	}

	// Decode Email fields
	email.id = d.get_u32()!
	email.message_id = d.get_string()!
	email.folder = d.get_string()!
	email.message = d.get_string()!

	// Decode attachments array
	attachments_len := d.get_u16()!
	email.attachments = []Attachment{len: int(attachments_len)}
	for i in 0 .. attachments_len {
		mut attachment := Attachment{}
		attachment.filename = d.get_string()!
		attachment.content_type = d.get_string()!
		attachment.data = d.get_string()!
		email.attachments[i] = attachment
	}

	email.date = d.get_i64()!
	email.size = d.get_u32()!
	email.read = d.get_u8()! == 1
	email.flagged = d.get_u8()! == 1
	
	// Decode header information
	email.subject = d.get_string()!
	
	// Decode from addresses
	from_len := d.get_u16()!
	email.from = []string{len: int(from_len)}
	for i in 0 .. from_len {
		email.from[i] = d.get_string()!
	}
	
	// Decode sender addresses
	sender_len := d.get_u16()!
	email.sender = []string{len: int(sender_len)}
	for i in 0 .. sender_len {
		email.sender[i] = d.get_string()!
	}
	
	// Decode reply_to addresses
	reply_to_len := d.get_u16()!
	email.reply_to = []string{len: int(reply_to_len)}
	for i in 0 .. reply_to_len {
		email.reply_to[i] = d.get_string()!
	}
	
	// Decode to addresses
	to_len := d.get_u16()!
	email.to = []string{len: int(to_len)}
	for i in 0 .. to_len {
		email.to[i] = d.get_string()!
	}
	
	// Decode cc addresses
	cc_len := d.get_u16()!
	email.cc = []string{len: int(cc_len)}
	for i in 0 .. cc_len {
		email.cc[i] = d.get_string()!
	}
	
	// Decode bcc addresses
	bcc_len := d.get_u16()!
	email.bcc = []string{len: int(bcc_len)}
	for i in 0 .. bcc_len {
		email.bcc[i] = d.get_string()!
	}
	
	email.in_reply_to = d.get_string()!

	return email
}

// sender returns the first sender address or an empty string if not available
pub fn (e Email) sender() string {
	if e.sender.len > 0 {
		return e.sender[0]
	} else if e.from.len > 0 {
		return e.from[0]
	}
	return ''
}

// recipients returns all recipient addresses (to, cc, bcc)
pub fn (e Email) recipients() []string {
	mut recipients := []string{}
	recipients << e.to
	recipients << e.cc
	recipients << e.bcc
	return recipients
}

// has_attachment returns true if the email has attachments
pub fn (e Email) has_attachments() bool {
	return e.attachments.len > 0
}

// calculate_size calculates the total size of the email in bytes
pub fn (e Email) calculate_size() u32 {
	mut size := u32(e.message.len)

	// Add size of attachments
	for attachment in e.attachments {
		size += u32(attachment.data.len)
	}

	// Add size of header data
	size += u32(e.subject.len)
	size += u32(e.message_id.len)
	size += u32(e.in_reply_to.len)

	// Add size of address fields
	for addr in e.from {
		size += u32(addr.len)
	}
	for addr in e.to {
		size += u32(addr.len)
	}
	for addr in e.cc {
		size += u32(addr.len)
	}
	for addr in e.bcc {
		size += u32(addr.len)
	}

	return size
}

// count_lines counts the number of lines in a string
fn count_lines(s string) int {
	if s == '' {
		return 0
	}
	return s.count('\n') + 1
}

// get_mime_type returns the MIME type of the email
pub fn (e Email) get_mime_type() string {
	if e.attachments.len == 0 {
		return 'text/plain'
	}
	return 'multipart/mixed'
}

// format_date returns the date formatted as a string
pub fn (e Email) format_date() string {
	return time.unix(e.date).format_rfc3339()
}

// set_from sets the From address
pub fn (mut e Email) set_from(from string) {
	e.from = [from]
}

// set_to sets the To addresses
pub fn (mut e Email) set_to(to []string) {
	e.to = to.clone()
}

// set_cc sets the Cc addresses
pub fn (mut e Email) set_cc(cc []string) {
	e.cc = cc.clone()
}

// set_bcc sets the Bcc addresses
pub fn (mut e Email) set_bcc(bcc []string) {
	e.bcc = bcc.clone()
}

// set_subject sets the Subject
pub fn (mut e Email) set_subject(subject string) {
	e.subject = subject
}

// set_date sets the Date
pub fn (mut e Email) set_date(date i64) {
	e.date = date
}

// mark_as_read marks the email as read
pub fn (mut e Email) mark_as_read() {
	e.read = true
}

// mark_as_unread marks the email as unread
pub fn (mut e Email) mark_as_unread() {
	e.read = false
}

// toggle_flag toggles the flagged status of the email
pub fn (mut e Email) toggle_flag() {
	e.flagged = !e.flagged
}

// add_attachment adds an attachment to the email
pub fn (mut e Email) add_attachment(filename string, content_type string, data string) {
	e.attachments << Attachment{
		filename: filename
		content_type: content_type
		data: data
	}
	e.size = e.calculate_size()
}
