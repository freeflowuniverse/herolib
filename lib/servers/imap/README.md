# IMAP Server

A simple IMAP server implementation in V that supports basic mailbox operations.

## Features

- In-memory IMAP server implementation
- Support for multiple mailboxes
- Basic IMAP commands: LOGIN, SELECT, FETCH, STORE, LOGOUT
- Message flags support (e.g. \Seen, \Flagged)
- Concurrent client handling

## Usage

The server can be started with a simple function call:

```v
import freeflowuniverse.herolib.servers.imap

fn main() {
    // Start the IMAP server on port 143
    imap.start() or { panic(err) }
}
```

Save this to `example.v` and run with:

```bash
v run example.v
```

The server will start listening on port 143 (default IMAP port) and initialize with an example INBOX containing two messages.

## Testing with an IMAP Client

You can test the server using any IMAP client. Here's an example using the `curl` command:

```bash
# Connect and login (any username/password is accepted)
curl "imap://localhost/" -u "user:pass" --ssl-reqd

# List messages in INBOX
curl "imap://localhost/INBOX" -u "user:pass" --ssl-reqd
```

## Implementation Details

The server consists of three main components:

1. **Model** (`model.v`): Defines the core data structures
   - `Message`: Represents an email message with ID, subject, body and flags
   - `Mailbox`: Contains a collection of messages
   - `IMAPServer`: Holds the mailboxes map

2. **Server** (`server.v`): Handles the IMAP protocol implementation
   - TCP connection handling
   - IMAP command processing
   - Concurrent client support

3. **Factory** (`factory.v`): Provides easy server initialization
   - `start()` function to create and run the server
   - Initializes example INBOX with sample messages

## Supported Commands

- `CAPABILITY`: List server capabilities
- `LOGIN`: Authenticate (accepts any credentials)
- `SELECT`: Select a mailbox
- `FETCH`: Retrieve message data
- `STORE`: Update message flags
- `LOGOUT`: End the session

## Example Session

```
C: A001 CAPABILITY
S: * CAPABILITY IMAP4rev1 AUTH=PLAIN
S: A001 OK CAPABILITY completed

C: A002 LOGIN user pass
S: A002 OK LOGIN completed

C: A003 SELECT INBOX
S: * FLAGS (\Answered \Flagged \Deleted \Seen \Draft)
S: * 2 EXISTS
S: A003 OK SELECT completed

C: A004 FETCH 1:* BODY[TEXT]
S: * 1 FETCH (FLAGS (\Seen) BODY[TEXT] "Welcome to the IMAP server!")
S: * 2 FETCH (FLAGS () BODY[TEXT] "This is an update.")
S: A004 OK FETCH completed

C: A005 STORE 2 +FLAGS (\Seen)
S: A005 OK STORE completed

C: A006 CAPABILITY
S: * CAPABILITY IMAP4rev1 AUTH=PLAIN
S: A006 OK CAPABILITY completed

C: A007 LOGOUT
S: * BYE IMAP4rev1 Server logging out
S: A007 OK LOGOUT completed
```

## Notes

- The server runs on port 143, which typically requires root privileges. Make sure you have the necessary permissions.
- This is a basic implementation for demonstration purposes. For production use, consider adding:
  - Proper authentication
  - Persistent storage
  - Full IMAP command support
  - TLS encryption
  - Message parsing and MIME support
