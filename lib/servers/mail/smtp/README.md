# SMTP Server

A simple SMTP server implementation in V that integrates with the mailbox module for message storage.

## Features

- SMTP server implementation with persistent storage via mailbox module
- Support for basic SMTP commands (HELO/EHLO, MAIL FROM, RCPT TO, DATA)
- Authentication support (PLAIN and LOGIN methods)
- TLS capability advertising
- Concurrent client handling
- Integration with mailbox module for message storage

## Usage

The server can be started with a simple function call:

```v
import freeflowuniverse.herolib.servers.mail.smtp
import freeflowuniverse.herolib.servers.mail.mailbox

fn main() {
    // Create the mail server
    mut mailserver := mailbox.new_mail_server()
    
    // Create the SMTP server wrapping the mail server
    mut smtp_server := smtp.new(mailserver)!
    
    // Start the SMTP server on port 25
    smtp_server.start()!
}
```

Save this to `example.v` and run with:

```bash
v run example.v
```

The server will start listening on port 25 (default SMTP port).

## Testing with SMTP Client

You can test the server using any SMTP client. Here's an example using the `telnet` command:

```bash
# Connect to server
telnet localhost 25

# Example session:
EHLO example.com
MAIL FROM:<sender@example.com>
RCPT TO:<recipient@example.com>
DATA
Subject: Test Message
Hello World!
.
QUIT
```

## Implementation Details

The server consists of two main components:

1. **Mailbox Module** (`mailbox/`): Core mail functionality
   - User account management
   - Message storage and retrieval
   - Mailbox operations

2. **SMTP Server** (`smtp/`): SMTP protocol implementation
   - TCP connection handling and session management
   - SMTP command processing
   - Maps SMTP operations to mailbox module functionality
   - Concurrent client support

## Supported Commands

- `HELO/EHLO`: Initial greeting and capability negotiation
- `MAIL FROM`: Specify sender address
- `RCPT TO`: Specify recipient address(es)
- `DATA`: Input email content
- `RSET`: Reset session state
- `QUIT`: End session
- `AUTH`: Authentication (PLAIN/LOGIN methods)
- `NOOP`: No operation

## Example Session

```
S: 220 SMTP server ready
C: EHLO example.com
S: 250-example.com
S: 250-8BITMIME
S: 250-PIPELINING
S: 250-STARTTLS
S: 250-AUTH PLAIN LOGIN
S: 250 HELP
C: MAIL FROM:<sender@example.com>
S: 250 OK
C: RCPT TO:<recipient@example.com>
S: 250 OK
C: DATA
S: 354 Start mail input; end with <CRLF>.<CRLF>
C: Subject: Test Email
C: 
C: This is a test message.
C: .
S: 250 OK
C: QUIT
S: 221 Goodbye
```

## Notes

- The server runs on port 25, which typically requires root privileges. Make sure you have the necessary permissions.
- This is a basic implementation for demonstration purposes. For production use, consider adding:
  - TLS encryption implementation
  - Full message parsing and MIME support
  - More robust authentication
  - Rate limiting and spam protection
  - Extended SMTP features (SIZE, DSN, etc.)
