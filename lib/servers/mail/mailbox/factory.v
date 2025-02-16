
module mailbox

pub fn new() &MailServer {
	return &MailServer{
		accounts: map[string]&UserAccount{}
	}
}

pub fn new_with_demo_data() !&MailServer {
	mut s := &MailServer{
		accounts: map[string]&UserAccount{}
	}
	s.demodata()!
	return s
}
