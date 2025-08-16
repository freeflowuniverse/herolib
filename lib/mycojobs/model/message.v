module model

// Messages is what goes over mycelium (which is our messaging system), they can have a job inside
// stored in the context db at msg:<callerid>:<id> (msg is hset)
// there are 2 queues in the context db: queue: msg_out and msg_in these are generic queues which get all messages from mycelium (in) and the ones who need to be sent (out) are in the outqueue
@[heap]
pub struct Message {
pub mut:
	id                  u32 // is unique id for the message, has been given by the caller
	caller_id           u32 // is the actor whos send this message
	context_id          u32 // each message is for a specific context
	message             string
	message_type        ScriptType
	message_format_type MessageFormatType
	timeout             u32 // in sec, to arrive destination
	timeout_ack         u32 // in sec, to acknowledge receipt
	timeout_result      u32 // in sec, to process result and have it back
	job                 []Job
	logs                []Log // e.g. for streaming logs back to originator
	created_at          u32   // epoch
	updated_at          u32   // epoch
	status              MessageStatus
}

// MessageType represents the type of message
pub enum MessageType {
	job
	chat
	mail
}

// MessageFormatType represents the format of a message
pub enum MessageFormatType {
	html
	text
	md
}

pub fn (self Message) redis_key() string {
	return 'message:${self.caller_id}:${self.id}'
}

// queue_suffix returns the queue suffix for the message type
pub fn (mt MessageType) queue_suffix() string {
	return match mt {
		.job { 'job' }
		.chat { 'chat' }
		.mail { 'mail' }
	}
}

// MessageStatus represents the status of a message
pub enum MessageStatus {
	dispatched
	acknowledged
	error
	processed // e.g. can be something which comes back
}

// str returns the string representation of MessageStatus
pub fn (ms MessageStatus) str() string {
	return match ms {
		.dispatched { 'dispatched' }
		.acknowledged { 'acknowledged' }
		.error { 'error' }
		.processed { 'processed' }
	}
}
