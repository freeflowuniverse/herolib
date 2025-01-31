module model

import freeflowuniverse.herolib.data.ourtime

// Job represents a task to be executed by an agent
pub struct Job {
pub mut:
	guid               string   // unique id for the job
	agents             []string // the pub key of the agent(s) which will execute the command, only 1 will execute
	source             string   // pubkey from the agent who asked for the job
	circle             string = 'default' // our digital life is organized in circles
	context            string = 'default' // is the high level context in which actors will execute the work inside a circle
	actor              string            // e.g. vm_manager
	action             string            // e.g. start
	params             map[string]string // e.g. id:10
	timeout_schedule   u16  = 60   // timeout before its picked up
	timeout            u16  = 3600 // timeout in sec
	log                bool = true
	ignore_error       bool  // means if error will just exit and not raise, there will be no error reporting
	ignore_error_codes []int // of we want to ignore certain error codes
	debug              bool  // if debug will get more context
	retry              int   // default there is no debug
	status             JobStatus
	dependencies       []JobDependency // will not execute until other jobs are done
}

// JobStatus represents the current state of a job
pub struct JobStatus {
pub mut:
	guid    string       // unique id for the job
	created ourtime.OurTime // when we created the job
	start   ourtime.OurTime // when the job needs to start
	end     ourtime.OurTime // when the job ended, can be in error
	status  Status       // current status of the job
}

// JobDependency represents a dependency on another job
pub struct JobDependency {
pub mut:
	guid   string   // unique id for the job
	agents []string // the pub key of the agent(s) which can execute the command
}

// Status represents the possible states of a job
pub enum Status {
	created   // initial state
	scheduled // job has been scheduled
	planned   // arrived where actor will execute the job
	running   // job is currently running
	error     // job encountered an error
	ok        // job completed successfully
}
