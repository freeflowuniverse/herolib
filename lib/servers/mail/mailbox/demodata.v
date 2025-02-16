module mailbox
import time

// Creates demo data with 5 user accounts, each having 2 mailboxes and 20 messages
pub fn (mut self MailServer) demodata() {
	usernames := ['user1', 'user2', 'user3', 'user4', 'user5']
	names := ['First User', 'Second User', 'Third User', 'Fourth User', 'Fifth User']
	
	for i, username in usernames {
		// Create primary and alternate email addresses
		primary_email := '${username}@example.com'
		alt_email := '${username}.alt@example.com'
		emails := [primary_email, alt_email]
		
		// Create user account (INBOX is created by default)
		self.account_create(username, names[i], emails)!
		
		// Create second mailbox
		self.mailbox_create(username, 'Sent')!
		
		// Add 10 messages to each mailbox
		for j in 0..10 {
			// Add message to INBOX
			inbox_msg := Message{
				uid: u32(j + 1)  // UIDs start at 1
				subject: 'Inbox Message ${j + 1}'
				body: 'This is inbox message ${j + 1} for ${username}'
				flags: if j % 2 == 0 { ['\\Seen'] } else { [] }
				internal_date: time.now()
			}
			self.message_set(username, 'INBOX', inbox_msg.uid, inbox_msg)!
			
			// Add message to Sent
			sent_msg := Message{
				uid: u32(j + 1)  // UIDs start at 1
				subject: 'Sent Message ${j + 1}'
				body: 'This is sent message ${j + 1} from ${username}'
				flags: ['\\Seen']
				internal_date: time.now()
			}
			self.message_set(username, 'Sent', sent_msg.uid, sent_msg)!
		}
	}
}
