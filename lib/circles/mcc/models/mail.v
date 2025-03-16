module mcc

// import freeflowuniverse.herolib.data.ourtime
import freeflowuniverse.herolib.data.encoder
// import strings
// import strconv

// Email represents an email message with all its metadata and content
pub struct Email {
pub mut:
	// Database ID
	id           u32          // Database ID (assigned by DBHandler)
	// Content fields
	uid          u32          // Unique identifier of the message (in the circle)
	seq_num      u32          // IMAP sequence number (in the mailbox)
	mailbox      string       // The mailbox this email belongs to
	message      string       // The email body content
	attachments  []Attachment // Any file attachments

	// IMAP specific fields
	flags        []string     // IMAP flags like \Seen, \Deleted, etc.
	internal_date i64         // Unix timestamp when the email was received
	size         u32          // Size of the message in bytes
	envelope     ?Envelope    // IMAP envelope information (contains From, To, Subject, etc.)
}

// Attachment represents an email attachment
pub struct Attachment {
pub mut:
	filename     string
	content_type string
	data         string // Base64 encoded binary data
}

// Envelope represents an IMAP envelope structure
pub struct Envelope {
pub mut:
	date        i64
	subject     string
	from        []string
	sender      []string
	reply_to    []string
	to          []string
	cc          []string
	bcc         []string
	in_reply_to string
	message_id  string
}

pub fn (e Email) index_keys() map[string]string {
	return {
		'uid': e.uid.str()
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
	enc.add_u32(e.uid)
	enc.add_u32(e.seq_num)
	enc.add_string(e.mailbox)
	enc.add_string(e.message)
	
	// Encode attachments array
	enc.add_u16(u16(e.attachments.len))
	for attachment in e.attachments {
		enc.add_string(attachment.filename)
		enc.add_string(attachment.content_type)
		enc.add_string(attachment.data)
	}
	
	// Encode flags array
	enc.add_u16(u16(e.flags.len))
	for flag in e.flags {
		enc.add_string(flag)
	}
	
	enc.add_i64(e.internal_date)
	enc.add_u32(e.size)
	
	// Encode envelope (optional)
	if envelope := e.envelope {
		enc.add_u8(1) // Has envelope
		enc.add_i64(envelope.date)
		enc.add_string(envelope.subject)
		
		// Encode from addresses
		enc.add_u16(u16(envelope.from.len))
		for addr in envelope.from {
			enc.add_string(addr)
		}
		
		// Encode sender addresses
		enc.add_u16(u16(envelope.sender.len))
		for addr in envelope.sender {
			enc.add_string(addr)
		}
		
		// Encode reply_to addresses
		enc.add_u16(u16(envelope.reply_to.len))
		for addr in envelope.reply_to {
			enc.add_string(addr)
		}
		
		// Encode to addresses
		enc.add_u16(u16(envelope.to.len))
		for addr in envelope.to {
			enc.add_string(addr)
		}
		
		// Encode cc addresses
		enc.add_u16(u16(envelope.cc.len))
		for addr in envelope.cc {
			enc.add_string(addr)
		}
		
		// Encode bcc addresses
		enc.add_u16(u16(envelope.bcc.len))
		for addr in envelope.bcc {
			enc.add_string(addr)
		}
		
		enc.add_string(envelope.in_reply_to)
		enc.add_string(envelope.message_id)
	} else {
		enc.add_u8(0) // No envelope
	}
	
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
	email.uid = d.get_u32()!
	email.seq_num = d.get_u32()!
	email.mailbox = d.get_string()!
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
	
	// Decode flags array
	flags_len := d.get_u16()!
	email.flags = []string{len: int(flags_len)}
	for i in 0 .. flags_len {
		email.flags[i] = d.get_string()!
	}
	
	email.internal_date = d.get_i64()!
	email.size = d.get_u32()!
	
	// Decode envelope (optional)
	has_envelope := d.get_u8()!
	if has_envelope == 1 {
		mut envelope := Envelope{}
		envelope.date = d.get_i64()!
		envelope.subject = d.get_string()!
		
		// Decode from addresses
		from_len := d.get_u16()!
		envelope.from = []string{len: int(from_len)}
		for i in 0 .. from_len {
			envelope.from[i] = d.get_string()!
		}
		
		// Decode sender addresses
		sender_len := d.get_u16()!
		envelope.sender = []string{len: int(sender_len)}
		for i in 0 .. sender_len {
			envelope.sender[i] = d.get_string()!
		}
		
		// Decode reply_to addresses
		reply_to_len := d.get_u16()!
		envelope.reply_to = []string{len: int(reply_to_len)}
		for i in 0 .. reply_to_len {
			envelope.reply_to[i] = d.get_string()!
		}
		
		// Decode to addresses
		to_len := d.get_u16()!
		envelope.to = []string{len: int(to_len)}
		for i in 0 .. to_len {
			envelope.to[i] = d.get_string()!
		}
		
		// Decode cc addresses
		cc_len := d.get_u16()!
		envelope.cc = []string{len: int(cc_len)}
		for i in 0 .. cc_len {
			envelope.cc[i] = d.get_string()!
		}
		
		// Decode bcc addresses
		bcc_len := d.get_u16()!
		envelope.bcc = []string{len: int(bcc_len)}
		for i in 0 .. bcc_len {
			envelope.bcc[i] = d.get_string()!
		}
		
		envelope.in_reply_to = d.get_string()!
		envelope.message_id = d.get_string()!
		
		email.envelope = envelope
	}
	
	return email
}


// sender returns the first sender address or an empty string if not available
pub fn (e Email) sender() string {
	if envelope := e.envelope {
		if envelope.sender.len > 0 {
			return envelope.sender[0]
		} else if envelope.from.len > 0 {
			return envelope.from[0]
		}
	}
	return ''
}

// recipients returns all recipient addresses (to, cc, bcc)
pub fn (e Email) recipients() []string {
	mut recipients := []string{}
	
	if envelope := e.envelope {
		recipients << envelope.to
		recipients << envelope.cc
		recipients << envelope.bcc
	}
	
	return recipients
}

// has_attachment returns true if the email has attachments
pub fn (e Email) has_attachments() bool {
	return e.attachments.len > 0
}

// is_read returns true if the email has been marked as read
pub fn (e Email) is_read() bool {
	return '\\\\Seen' in e.flags
}

// is_flagged returns true if the email has been flagged
pub fn (e Email) is_flagged() bool {
	return '\\\\Flagged' in e.flags
}

// date returns the date when the email was sent
pub fn (e Email) date() i64 {
	if envelope := e.envelope {
		return envelope.date
	}
	return e.internal_date
}

// calculate_size calculates the total size of the email in bytes
pub fn (e Email) calculate_size() u32 {
	mut size := u32(e.message.len)

	// Add size of attachments
	for attachment in e.attachments {
		size += u32(attachment.data.len)
	}

	// Add estimated size of envelope data if available
	if envelope := e.envelope {
		size += u32(envelope.subject.len)
		size += u32(envelope.message_id.len)
		size += u32(envelope.in_reply_to.len)

		// Add size of address fields
		for addr in envelope.from {
			size += u32(addr.len)
		}
		for addr in envelope.to {
			size += u32(addr.len)
		}
		for addr in envelope.cc {
			size += u32(addr.len)
		}
		for addr in envelope.bcc {
			size += u32(addr.len)
		}
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

// body_structure generates and returns a description of the MIME structure of the email
// This can be used by IMAP clients to understand the structure of the message
pub fn (e Email) body_structure() string {
	// If there are no attachments, return a simple text structure
	if e.attachments.len == 0 {
		return '("text" "plain" ("charset" "utf-8") NIL NIL "7bit" ' +
			'${e.message.len} ${count_lines(e.message)}' + ' NIL NIL NIL)'
	}

	// For emails with attachments, create a multipart/mixed structure
	mut result := '("multipart" "mixed" NIL NIL NIL "7bit" NIL NIL ('

	// Add the text part
	result += '("text" "plain" ("charset" "utf-8") NIL NIL "7bit" ' +
		'${e.message.len} ${count_lines(e.message)}' + ' NIL NIL NIL)'

	// Add each attachment
	for attachment in e.attachments {
		// Default to application/octet-stream if content type is empty
		mut content_type := attachment.content_type
		if content_type == '' {
			content_type = 'application/octet-stream'
		}

		// Split content type into type and subtype
		parts := content_type.split('/')
		mut subtype := 'octet-stream'
		if parts.len == 2 {
			subtype = parts[1]
		}

		// Add the attachment part
		result += ' ("application" "${subtype}" ("name" "${attachment.filename}") NIL NIL "base64" ${attachment.data.len} NIL ("attachment" ("filename" "${attachment.filename}")) NIL)'
	}

	// Close the structure
	result += ')'

	return result
}

// Helper methods to access fields from the Envelope

// from returns the From address from the Envelope
pub fn (e Email) from() string {
	if envelope := e.envelope {
		if envelope.from.len > 0 {
			return envelope.from[0]
		}
	}
	return ''
}

// to returns the To addresses from the Envelope
pub fn (e Email) to() []string {
	if envelope := e.envelope {
		return envelope.to
	}
	return []string{}
}

// cc returns the Cc addresses from the Envelope
pub fn (e Email) cc() []string {
	if envelope := e.envelope {
		return envelope.cc
	}
	return []string{}
}

// bcc returns the Bcc addresses from the Envelope
pub fn (e Email) bcc() []string {
	if envelope := e.envelope {
		return envelope.bcc
	}
	return []string{}
}

// subject returns the Subject from the Envelope
pub fn (e Email) subject() string {
	if envelope := e.envelope {
		return envelope.subject
	}
	return ''
}


// ensure_envelope ensures that the email has an envelope, creating one if needed
pub fn (mut e Email) ensure_envelope() {
	if e.envelope == none {
		e.envelope = Envelope{
			from: []string{}
			sender: []string{}
			reply_to: []string{}
			to: []string{}
			cc: []string{}
			bcc: []string{}
		}
	}
}

// set_from sets the From address in the Envelope
pub fn (mut e Email) set_from(from string) {
	e.ensure_envelope()
	mut envelope := e.envelope or { Envelope{} }
	envelope.from = [from]
	e.envelope = envelope
}

// set_to sets the To addresses in the Envelope
pub fn (mut e Email) set_to(to []string) {
	e.ensure_envelope()
	mut envelope := e.envelope or { Envelope{} }
	envelope.to = to.clone()
	e.envelope = envelope
}

// set_cc sets the Cc addresses in the Envelope
pub fn (mut e Email) set_cc(cc []string) {
	e.ensure_envelope()
	mut envelope := e.envelope or { Envelope{} }
	envelope.cc = cc.clone()
	e.envelope = envelope
}

// set_bcc sets the Bcc addresses in the Envelope
pub fn (mut e Email) set_bcc(bcc []string) {
	e.ensure_envelope()
	mut envelope := e.envelope or { Envelope{} }
	envelope.bcc = bcc.clone()
	e.envelope = envelope
}

// set_subject sets the Subject in the Envelope
pub fn (mut e Email) set_subject(subject string) {
	e.ensure_envelope()
	mut envelope := e.envelope or { Envelope{} }
	envelope.subject = subject
	e.envelope = envelope
}

// set_date sets the Date in the Envelope
pub fn (mut e Email) set_date(date i64) {
	e.ensure_envelope()
	mut envelope := e.envelope or { Envelope{} }
	envelope.date = date
	e.envelope = envelope
}
