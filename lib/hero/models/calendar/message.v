module calendar

import freeflowuniverse.herolib.hero.models.core

// MessageStatus represents the delivery status of a message
pub enum MessageStatus {
	draft
	sent
	delivered
	read
	failed
}

// MessageType categorizes different types of messages
pub enum MessageType {
	email
	sms
	notification
	reminder
}

// Message represents a communication message
pub struct Message {
	core.Base
pub mut:
	sender_id    u32 @[index]
	recipient_id u32 @[index]
	subject      string
	body         string
	message_type MessageType
	status       MessageStatus
	scheduled_at u64
	sent_at      u64
	read_at      u64
	priority     u8       // 1-5 scale
	attachments  []string // file paths or URLs
	tags         []string
}

// Reminder represents a scheduled reminder
pub struct Reminder {
	core.Base
pub mut:
	event_id      u32 @[index]
	message       string
	reminder_time u64 @[index]
	is_sent       bool
	snooze_count  u8
}
