module mail
import freeflowuniverse.herolib.baobab.osis {OSIS}
module mail

import freeflowuniverse.herolib.baobab.osis { OSIS }

// Interface for Mail API
pub interface IHeroLibCirclesMailAPI {
mut:
	list_emails(string) ![]Email
	create_email(EmailCreate) !Email
	get_email_by_id(u32) !Email
	update_email(u32, EmailUpdate) !Email
	delete_email(u32) !
	search_emails(string, string, string, string, i64, i64, bool) ![]Email
	get_emails_by_mailbox(string) ![]Email
	update_email_flags(u32, UpdateEmailFlags) !Email
}