# IMAP Server

A simple IMAP server implementation in V that supports basic mailbox operations.

## Features

- IMAP server implementation with persistent storage via mailbox module
- Support for multiple mailboxes
- Basic IMAP commands: LOGIN, SELECT, FETCH, STORE, LOGOUT
- Message flags support (e.g. \Seen, \Flagged)
- Concurrent client handling

## Usage

The server can be started with a simple function call:

```v
import freeflowuniverse.herolib.servers.mail.imap
import freeflowuniverse.herolib.servers.mail.mailbox

fn main() {
    // Create the mail server
    mut mailserver := mailbox.new_mail_server()
    
    // Create the IMAP server wrapping the mail server
    mut imap_server := imap.new_server(mailserver)
    
    // Start the IMAP server on port 143
    imap_server.start() or { panic(err) }
}
```

Save this to `example.v` and run with:

```bash
v run example.v
```

The server will start listening on port 143 (default IMAP port).

## Testing with an IMAP Client

You can test the server using any IMAP client. Here's an example using the `curl` command:

```bash
# Connect and login (any username/password is accepted)
curl "imap://localhost/" -u "user:pass" --ssl-reqd

# List messages in INBOX
curl "imap://localhost/INBOX" -u "user:pass" --ssl-reqd
```

## Implementation Details

The server consists of two main components:

1. **Mailbox Module** (`mailbox/`): Core mail functionality
   - User account management
   - Mailbox operations (create, delete, list)
   - Message storage and retrieval
   - Message flag management
   - Search capabilities

2. **IMAP Server** (`imap/`): IMAP protocol implementation
   - TCP connection handling and session management
   - IMAP command processing
   - Maps IMAP operations to mailbox module functionality
   - Concurrent client support

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
  - Full IMAP command support
  - TLS encryption
  - Message parsing and MIME support
