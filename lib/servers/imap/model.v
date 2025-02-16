module imap
import net
import io

// Represents an email message.
pub struct Message {
pub mut:	
	id      int
	subject string
	body    string
	flags []string // e.g.: ["\\Seen", "\\Flagged"]
}

// Represents a mailbox holding messages.
pub struct Mailbox {
pub mut:
	name     string
	messages []Message
}

// Our in-memory server holds a map of mailbox names to pointers to Mailbox.
pub struct IMAPServer {
pub mut:
	mailboxes map[string]&Mailbox
}

pub struct Session {
pub mut:
	server &IMAPServer
	mailbox string //the name of the mailbox
	conn net.TcpConn
	reader &io.BufferedReader
}


pub fn (mut self Session) mailbox_new(name string) !&Mailbox{
	self.mailboxes[name] = &Mailbox{name:name}
	return self.mailboxes[name]
}

pub fn (mut self Session) mailbox() !&Mailbox{
	if !(mailbox_name in server.mailboxes) {
		return error ("mailbox ${self.mailbox} does not exist")
	}
	return self.mailboxes[self.mailbox] or { panic(err) }
	
}