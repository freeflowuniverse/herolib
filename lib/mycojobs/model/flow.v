module model

// what get's executed by an actor and needs to be tracked as a whole, can be represented as a DAG graph
// this is the high level representation of a workflow to execute on work, its fully decentralized and distributed
// only the actor who created the flow can modify it and holds it in DB
// stored in the context db at flow:<id> (flow is hset)
@[heap]
pub struct Flow {
pub mut:
	id         u32               // this job id is given by the actor who called for it
	caller_id  u32               // is the actor which called for this job
	context_id u32               // each job is executed in a context
	jobs       []u32             // links to all jobs which make up this flow, this can be dynamically modified
	env_vars   map[string]string // they are copied to every job done
	result     map[string]string // the result of the flow
	created_at u32               // epoch
	updated_at u32               // epoch
	status     FlowStatus
}

pub fn (self Flow) redis_key() string {
	return 'flow:${self.id}'
}

// FlowStatus represents the status of a flow
pub enum FlowStatus {
	dispatched
	started
	error
	finished
}

// str returns the string representation of FlowStatus
pub fn (self FlowStatus) str() string {
	return match self {
		.dispatched { 'dispatched' }
		.started { 'started' }
		.error { 'error' }
		.finished { 'finished' }
	}
}
