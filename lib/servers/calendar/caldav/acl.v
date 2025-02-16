module caldav

// CalDAV privileges
pub const (
	read_free_busy = 'read-free-busy' // Allows reading free/busy information
	read           = 'read'           // Allows reading calendar data
	write          = 'write'          // Allows writing calendar data
	write_content  = 'write-content'  // Allows modifying calendar object resources
	write_props    = 'write-props'    // Allows modifying collection properties
	bind           = 'bind'           // Allows creating new calendar object resources
	unbind         = 'unbind'         // Allows deleting calendar object resources
	admin          = 'admin'          // Allows administrative operations
)

// Principal represents a user or group
pub struct Principal {
pub mut:
	id          string
	name        string
	email       string
	calendar_home_set string
}

// ACLEntry represents an access control entry
pub struct ACLEntry {
pub mut:
	principal Principal
	privileges []string
	inherited bool
	protected bool
}

// ACL represents an access control list
pub struct ACL {
pub mut:
	entries []ACLEntry
}

// Creates a new ACL
pub fn new_acl() ACL {
	return ACL{
		entries: []ACLEntry{}
	}
}

// Adds an ACL entry
pub fn (mut acl ACL) add_entry(principal Principal, privileges []string, inherited bool, protected bool) {
	acl.entries << ACLEntry{
		principal: principal
		privileges: privileges
		inherited: inherited
		protected: protected
	}
}

// Checks if a principal has a privilege
pub fn (acl ACL) has_privilege(principal Principal, privilege string) bool {
	for entry in acl.entries {
		if entry.principal.id == principal.id {
			return privilege in entry.privileges
		}
	}
	return false
}

// Gets all privileges for a principal
pub fn (acl ACL) get_privileges(principal Principal) []string {
	for entry in acl.entries {
		if entry.principal.id == principal.id {
			return entry.privileges
		}
	}
	return []string{}
}

// Removes an ACL entry
pub fn (mut acl ACL) remove_entry(principal Principal) {
	for i, entry in acl.entries {
		if entry.principal.id == principal.id {
			acl.entries.delete(i)
			break
		}
	}
}

// Checks if a principal has read access
pub fn (acl ACL) can_read(principal Principal) bool {
	return acl.has_privilege(principal, read) || acl.has_privilege(principal, admin)
}

// Checks if a principal has write access
pub fn (acl ACL) can_write(principal Principal) bool {
	return acl.has_privilege(principal, write) || acl.has_privilege(principal, admin)
}

// Checks if a principal has free/busy read access
pub fn (acl ACL) can_read_freebusy(principal Principal) bool {
	return acl.has_privilege(principal, read_free_busy) || acl.can_read(principal)
}

// Checks if a principal can bind (create) resources
pub fn (acl ACL) can_bind(principal Principal) bool {
	return acl.has_privilege(principal, bind) || acl.has_privilege(principal, write)
}

// Checks if a principal can unbind (delete) resources
pub fn (acl ACL) can_unbind(principal Principal) bool {
	return acl.has_privilege(principal, unbind) || acl.has_privilege(principal, write)
}

// Checks if a principal has admin access
pub fn (acl ACL) is_admin(principal Principal) bool {
	return acl.has_privilege(principal, admin)
}
