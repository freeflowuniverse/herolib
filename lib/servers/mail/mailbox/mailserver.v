module mailbox
import time

// Represents the mail server that manages user accounts
@[heap]
pub struct MailServer {
pub mut:
	accounts map[string]&UserAccount  // Map of username to user account
}

// Creates a new user account
pub fn (mut self MailServer) create_account(username string, description string, emails []string) !&UserAccount {
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

	return account
}

// Gets a user account by username
pub fn (mut self MailServer) get_account(username string) !&UserAccount {
	if account := self.accounts[username] {
		return account
	}
	return error('User ${username} not found')
}

// Deletes a user account
pub fn (mut self MailServer) delete_account(username string) ! {
	if username !in self.accounts {
		return error('User ${username} not found')
	}
	self.accounts.delete(username)
}

// Lists all usernames
pub fn (self MailServer) list_accounts() []string {
	return self.accounts.keys()
}

// Finds account by email address
pub fn (mut self MailServer) find_account_by_email(email string) !&UserAccount {
	for _, account in self.accounts {
		if email in account.emails {
			return account
		}
	}
	return error('No account found with email ${email}')
}
