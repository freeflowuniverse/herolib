# Mailbox Module

A V language implementation of a mailbox system that provides core functionality for managing email messages. This module is designed to be used as part of an email server implementation, providing the fundamental storage and retrieval operations for email messages.

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

### MailServer

The MailServer struct provides the following public methods:

#### Account Management
- `account_create(username string, description string, emails []string) !` - Creates a new user account
- `account_delete(username string) !` - Deletes a user account
- `account_list() []string` - Lists all usernames
- `account_find_by_email(email string) !string` - Finds account by email address

#### Mailbox Management
- `mailbox_list(username string) ![]string` - Lists all mailboxes for a user
- `mailbox_create(username string, mailbox string) !` - Creates a new mailbox for a user
- `mailbox_delete(username string, mailbox string) !` - Deletes a mailbox for a user

#### Message Management
- `message_list(username string, mailbox string) ![]Message` - Returns all messages in the mailbox
- `message_get(username string, mailbox string, uid u32) !Message` - Gets a message by its UID
- `message_delete(username string, mailbox string, uid u32) !` - Deletes a message by its UID
- `message_set(username string, mailbox string, uid u32, msg Message) !` - Sets/updates a message with the given UID
- `message_find(username string, mailbox string, args FindArgs) ![]Message` - Finds messages matching the given criteria
- `message_len(username string, mailbox string) !int` - Returns the number of messages in a mailbox

## Usage Example

```v
// Create a new mail server
mut server := new()

// Create a user account
server.account_create('user1', 'First User', ['user1@example.com'])!

// Create a new mailbox
server.mailbox_create('user1', 'Important')!

// Add a message
msg := Message{
    uid: 1
    subject: 'Hello'
    body: 'World'
    flags: ['\\Seen']
}
server.message_set('user1', 'Important', msg.uid, msg)!

// List messages
messages := server.message_list('user1', 'Important')!

// Find messages
results := server.message_find('user1', 'Important', FindArgs{
    subject: 'Hello'
    content: 'World'
    flags: ['\\Seen']
})!

// Delete a message
server.message_delete('user1', 'Important', 1)!
```

## Notes

- Each message has a unique identifier (UID) that remains constant
- Messages can be flagged with standard IMAP flags (e.g. \\Seen, \\Flagged)
- Search operations support filtering by subject, content, and flags
