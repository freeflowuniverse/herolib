module model

// Service represents a service that can be provided by agents
pub struct Service {
pub mut:
	actor       string          // name of the actor providing the service
	actions     []ServiceAction // available actions for this service
	description string          // optional description
	status      ServiceState    // current state of the service
	acl         ?ACL            // access control list for the service
}

// ServiceAction represents an action that can be performed by a service
pub struct ServiceAction {
pub mut:
	action         string            // which action
	description    string            // optional description
	params         map[string]string // e.g. name:'name of the vm' ...
	params_example map[string]string // e.g. name:'myvm'
	acl            ?ACL              // if not used then everyone can use
}

// ACL represents an access control list
pub struct ACL {
pub mut:
	name string
	ace  []ACE
}

// ACE represents an access control entry
pub struct ACE {
pub mut:
	groups []string // guid's of the groups who have access
	users  []string // in case groups are not used then is users
	right  string   // e.g. read, write, admin, block
}

// ServiceState represents the possible states of a service
pub enum ServiceState {
	ok     // service is functioning normally
	down   // service is not available
	error  // service encountered an error
	halted // service has been manually stopped
}
