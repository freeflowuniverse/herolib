module model

// Job represents a job, a job is only usable in the context of a runner (which is part of a hero)
// stored in the context db at job:<callerid>:<id> (job is hset)
@[heap]
pub struct RunnerJob {
pub mut:
	id            u32 // this job id is given by the actor who called for it
	caller_id     u32 // is the actor which called for this job
	context_id    u32 // each job is executed in a context
	script        string
	script_type   ScriptType
	timeout       u32 // in sec
	retries       u8
	env_vars      map[string]string
	result        map[string]string
	prerequisites []string
	dependends    []u32
	created_at    u32 // epoch
	updated_at    u32 // epoch
	status        JobStatus
}

// ScriptType represents the type of script
pub enum ScriptType {
	osis
	sal
	v
	python
}

pub fn (self RunnerJob) redis_key() string {
	return 'job:${self.caller_id}:${self.id}'
}

// queue_suffix returns the queue suffix for the script type
pub fn (st ScriptType) queue_suffix() string {
	return match st {
		.osis { 'osis' }
		.sal { 'sal' }
		.v { 'v' }
		.python { 'python' }
	}
}

// JobStatus represents the status of a job
pub enum JobStatus {
	dispatched
	waiting_for_prerequisites
	started
	error
	finished
}

// str returns the string representation of JobStatus
pub fn (js JobStatus) str() string {
	return match js {
		.dispatched { 'dispatched' }
		.waiting_for_prerequisites { 'waiting_for_prerequisites' }
		.started { 'started' }
		.error { 'error' }
		.finished { 'finished' }
	}
}
