module mailbox
import time

// Represents the mail server that manages user accounts
@[heap]
pub struct MailServer {
mut:
	accounts map[string]&UserAccount  // Map of username to user account
}

// Creates a new user account
pub fn (mut self MailServer) account_create(username string, description string, emails []string) ! {
	if username in self.accounts {
		return error('User ${username} already exists')
	}

	// Verify emails are unique across all accounts
	for _, account in self.accounts {
		for email in emails {
			if email in account.emails {
				return error('Email ${email} is already registered to another account')
			}
		}
	}

	mut account := &UserAccount{
		name: username
		description: description
		emails: emails.clone()
		mailboxes: map[string]&Mailbox{}
	}
	self.accounts[username] = account

	// Create default INBOX mailbox
	account.create_mailbox('INBOX') or { return err }
}

// Deletes a user account
pub fn (mut self MailServer) account_delete(username string) ! {
	if username !in self.accounts {
		return error('User ${username} not found')
	}
	self.accounts.delete(username)
}

// Lists all usernames
pub fn (self MailServer) account_list() []string {
	return self.accounts.keys()
}

// Finds account by email address
pub fn (mut self MailServer) account_find_by_email(email string) !string {
	for _, account in self.accounts {
		if email in account.emails {
			return account.name
		}
	}
	return error('No account found with email ${email}')
}

// Gets a user account by username (internal only)
fn (mut self MailServer) account_get(username string) !&UserAccount {
	if account := self.accounts[username] {
		return account
	}
	return error('User ${username} not found')
}

// Lists all mailboxes for a user
pub fn (mut self MailServer) mailbox_list(username string) ![]string {
	account := self.account_get(username)!
	return account.list_mailboxes()
}

// Creates a new mailbox for a user
pub fn (mut self MailServer) mailbox_create(username string, mailbox string) ! {
	mut account := self.account_get(username)!
	account.create_mailbox(mailbox)!
}

// Deletes a mailbox for a user
pub fn (mut self MailServer) mailbox_delete(username string, mailbox string) ! {
	mut account := self.account_get(username)!
	account.delete_mailbox(mailbox)!
}

// Returns all messages in the mailbox
pub fn (mut self MailServer) message_list(username string, mailbox string) ![]Message {
	mut account := self.account_get(username)!
	mut mb := account.get_mailbox(mailbox)!
	return mb.list()
}

// Gets a message by its UID
pub fn (mut self MailServer) message_get(username string, mailbox string, uid u32) !Message {
	mut account := self.account_get(username)!
	mut mb := account.get_mailbox(mailbox)!
	return mb.get(uid)
}

// Deletes a message by its UID
pub fn (mut self MailServer) message_delete(username string, mailbox string, uid u32) ! {
	mut account := self.account_get(username)!
	mut mb := account.get_mailbox(mailbox)!
	mb.delete(uid)!
}

// Sets/updates a message with the given UID
pub fn (mut self MailServer) message_set(username string, mailbox string, uid u32, msg Message) ! {
	mut account := self.account_get(username)!
	mut mb := account.get_mailbox(mailbox)!
	mb.set(uid, msg)!
}

// Finds messages matching the given criteria
pub fn (mut self MailServer) message_find(username string, mailbox string, args FindArgs) ![]Message {
	mut account := self.account_get(username)!
	mut mb := account.get_mailbox(mailbox)!
	return mb.find(args)
}

// Returns the number of messages in a mailbox
pub fn (mut self MailServer) message_len(username string, mailbox string) !int {
	mut account := self.account_get(username)!
	mut mb := account.get_mailbox(mailbox)!
	return mb.len()
}
