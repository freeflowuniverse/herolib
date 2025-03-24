in @lib/circles/mcc 
generate openapi 3.1 spec
based on the models and db implementation

implement well chosen examples in the openapi spec

note: in OpenAPI 3.1.0, the example property is deprecated in favor of examples.

do this for the models & methods as defined below

do it for custom and generic methods, don't forget any

```v

// CalendarEvent represents a calendar event with all its properties
pub struct CalendarEvent {
pub mut:
    id           u32      // Unique identifier
    title        string   // Event title
    description  string   // Event details
    location     string   // Event location
    start_time   ourtime.OurTime  
    end_time     ourtime.OurTime  // End time
    all_day      bool     // True if it's an all-day event
    recurrence   string   // RFC 5545 Recurrence Rule (e.g., "FREQ=DAILY;COUNT=10")
    attendees    []string // List of emails or user IDs
    organizer    string   // Organizer email
    status       string   // "CONFIRMED", "CANCELLED", "TENTATIVE"
    caldav_uid   string   // CalDAV UID for syncing
    sync_token   string   // Sync token for tracking changes
    etag         string   // ETag for caching
    color        string   // User-friendly color categorization
}


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
```

methods

```v
pub fn (mut m MailDB) new() Email {
}

// set adds or updates an email
pub fn (mut m MailDB) set(email Email) !Email {
}

// get retrieves an email by its ID
pub fn (mut m MailDB) get(id u32) !Email {
}

// list returns all email IDs
pub fn (mut m MailDB) list() ![]u32 {
}

pub fn (mut m MailDB) getall() ![]Email {
}

// delete removes an email by its ID
pub fn (mut m MailDB) delete(id u32) ! {
}

//////////////////CUSTOM METHODS//////////////////////////////////

// get_by_uid retrieves an email by its UID
pub fn (mut m MailDB) get_by_uid(uid u32) !Email {
}

// get_by_mailbox retrieves all emails in a specific mailbox
pub fn (mut m MailDB) get_by_mailbox(mailbox string) ![]Email {
}

// delete_by_uid removes an email by its UID
pub fn (mut m MailDB) delete_by_uid(uid u32) ! {
}

// delete_by_mailbox removes all emails in a specific mailbox
pub fn (mut m MailDB) delete_by_mailbox(mailbox string) ! {
}

// update_flags updates the flags of an email
pub fn (mut m MailDB) update_flags(uid u32, flags []string) !Email {
}

// search_by_subject searches for emails with a specific subject substring
pub fn (mut m MailDB) search_by_subject(subject string) ![]Email {
}

// search_by_address searches for emails with a specific email address in from, to, cc, or bcc fields
pub fn (mut m MailDB) search_by_address(address string) ![]Email {
}

pub fn (mut c CalendarDB) new() CalendarEvent {
    CalendarEvent {}
}

// set adds or updates a calendar event
pub fn (mut c CalendarDB) set(event CalendarEvent) CalendarEvent {
    CalendarEvent {}
}

// get retrieves a calendar event by its ID
pub fn (mut c CalendarDB) get(id u32) CalendarEvent {
    CalendarEvent {}
}

// list returns all calendar event IDs
pub fn (mut c CalendarDB) list() []u32 {
    []
}

pub fn (mut c CalendarDB) getall() []CalendarEvent {
    []
}

// delete removes a calendar event by its ID
pub fn (mut c CalendarDB) delete(id u32) {
}

//////////////////CUSTOM METHODS//////////////////////////////////

// get_by_caldav_uid retrieves a calendar event by its CalDAV UID
pub fn (mut c CalendarDB) get_by_caldav_uid(caldav_uid String) CalendarEvent {
    CalendarEvent {}
}

// get_events_by_date retrieves all events that occur on a specific date
pub fn (mut c CalendarDB) get_events_by_date(date String) []CalendarEvent {
    []
}

// get_events_by_organizer retrieves all events organized by a specific person
pub fn (mut c CalendarDB) get_events_by_organizer(organizer String) []CalendarEvent {
    []
}

// get_events_by_attendee retrieves all events that a specific person is attending
pub fn (mut c CalendarDB) get_events_by_attendee(attendee String) []CalendarEvent {
    []
}

// search_events_by_title searches for events with a specific title substring
pub fn (mut c CalendarDB) search_events_by_title(title String) []CalendarEvent {
    []
}

// update_status updates the status of an event
pub fn (mut c CalendarDB) update_status(id u32, status String) CalendarEvent {
    CalendarEvent {}
}

// delete_by_caldav_uid removes an event by its CalDAV UID
pub fn (mut c CalendarDB) delete_by_caldav_uid(caldav_uid String) {
}

```