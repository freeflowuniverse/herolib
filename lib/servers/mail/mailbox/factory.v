
module mailbox

fn new() &MailServer {
	return &MailServer{
		accounts: map[string]&UserAccount{}
	}
}


fn new_with_demo_data() &MailServer {
	mut s:= &MailServer{
		accounts: map[string]&UserAccount{}
	}
	s.demodata()
	return s
}


