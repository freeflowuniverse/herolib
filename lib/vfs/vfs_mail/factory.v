module vfs_mail

import freeflowuniverse.herolib.vfs
import freeflowuniverse.herolib.circles.mcc.db as core

// new creates a new mail VFS instance
pub fn new(mail_db &core.MailDB) !vfs.VFSImplementation {
	return new_mail_vfs(mail_db)!
}
