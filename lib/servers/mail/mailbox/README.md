# Mailbox Module

A V language implementation of a mailbox system that provides core functionality for managing email messages. This module is designed to be used as part of an email server implementation, providing the fundamental storage and retrieval operations for email messages.

## Features

- Message management with unique identifiers (UIDs)
- CRUD operations for messages (Create, Read, Update, Delete)
- Message searching capabilities
- Support for message flags (e.g., \Seen, \Flagged)
- Read-only mailbox support

## Core Components

### Message

```v
pub struct Message {
pub mut:	
    uid           u32        // Unique identifier for the message
    subject       string
    body          string
    flags         []string   // e.g.: ["\Seen", "\Flagged"]
    internal_date time.Time  // Message arrival time
}
```

### Mailbox

```v
pub struct Mailbox {
pub mut:
    name         string
    messages     []Message
    next_uid     u32    // Next unique identifier to be assigned
    uid_validity u32    // Unique identifier validity value
    read_only    bool   // Whether mailbox is read-only
}
```

## Usage Examples

### Basic Operations

```v
// Create a new mailbox
mut mb := Mailbox{
    name: 'INBOX'
    next_uid: 1
    uid_validity: 1
}

// Add a message
msg := Message{
    uid: 1
    subject: 'Hello'
    body: 'World'
    flags: ['\Seen']
}
mb.set(msg.uid, msg)!

// Get a message
found_msg := mb.get(1)!

// List all messages
messages := mb.list()!

// Delete a message
mb.delete(1)!
```

### Searching Messages

```v
// Search for messages with specific criteria
results := mb.find(FindArgs{
    subject: 'Hello'
    content: 'World'
    flags: ['\Seen']
})!
```

## Notes

- Each message has a unique identifier (UID) that remains constant
- The `uid_validity` value helps clients detect mailbox changes
- Messages can be flagged with standard IMAP flags
- Search operations support filtering by subject, content, and flags
