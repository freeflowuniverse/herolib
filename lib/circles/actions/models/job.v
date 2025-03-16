module models

import freeflowuniverse.herolib.data.ourtime
import freeflowuniverse.herolib.data.encoder

// Job represents a task to be executed by an agent
pub struct Job {
pub mut:
	id                 u32      // unique numeric id for the job
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
	guid    string          // unique id for the job
	created ourtime.OurTime // when we created the job
	start   ourtime.OurTime // when the job needs to start
	end     ourtime.OurTime // when the job ended, can be in error
	status  Status          // current status of the job
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

pub fn (j Job) index_keys() map[string]string {
	return {
		'guid': j.guid,
		'actor': j.actor,
		'circle': j.circle,
		'context': j.context
	}
}

// dumps serializes the Job struct to binary format using the encoder
// This implements the Serializer interface
pub fn (j Job) dumps() ![]u8 {
	mut e := encoder.new()

	// Add unique encoding ID to identify this type of data
	e.add_u16(300)
	
	// Encode Job fields
	e.add_u32(j.id)
	e.add_string(j.guid)
	
	// Encode agents array
	e.add_u16(u16(j.agents.len))
	for agent in j.agents {
		e.add_string(agent)
	}
	
	e.add_string(j.source)
	e.add_string(j.circle)
	e.add_string(j.context)
	e.add_string(j.actor)
	e.add_string(j.action)
	
	// Encode params map
	e.add_u16(u16(j.params.len))
	for key, value in j.params {
		e.add_string(key)
		e.add_string(value)
	}
	
	e.add_u16(j.timeout_schedule)
	e.add_u16(j.timeout)
	e.add_bool(j.log)
	e.add_bool(j.ignore_error)
	
	// Encode ignore_error_codes array
	e.add_u16(u16(j.ignore_error_codes.len))
	for code in j.ignore_error_codes {
		e.add_i32(code)
	}
	
	e.add_bool(j.debug)
	e.add_i32(j.retry)
	
	// Encode JobStatus
	e.add_string(j.status.guid)
	e.add_i64(j.status.created.unix)
	e.add_i64(j.status.start.unix)
	e.add_i64(j.status.end.unix)
	e.add_u8(u8(j.status.status))
	
	// Encode dependencies array
	e.add_u16(u16(j.dependencies.len))
	for dependency in j.dependencies {
		e.add_string(dependency.guid)
		
		// Encode dependency agents array
		e.add_u16(u16(dependency.agents.len))
		for agent in dependency.agents {
			e.add_string(agent)
		}
	}
	
	return e.data
}

// loads deserializes binary data into a Job struct
pub fn job_loads(data []u8) !Job {
	mut d := encoder.decoder_new(data)
	mut job := Job{}

	// Check encoding ID to verify this is the correct type of data
	encoding_id := d.get_u16()!
	if encoding_id != 300 {
		return error('Wrong file type: expected encoding ID 300, got ${encoding_id}, for job')
	}
	
	// Decode Job fields
	job.id = d.get_u32()!
	job.guid = d.get_string()!
	
	// Decode agents array
	agents_len := d.get_u16()!
	job.agents = []string{len: int(agents_len)}
	for i in 0 .. agents_len {
		job.agents[i] = d.get_string()!
	}
	
	job.source = d.get_string()!
	job.circle = d.get_string()!
	job.context = d.get_string()!
	job.actor = d.get_string()!
	job.action = d.get_string()!
	
	// Decode params map
	params_len := d.get_u16()!
	job.params = map[string]string{}
	for _ in 0 .. params_len {
		key := d.get_string()!
		value := d.get_string()!
		job.params[key] = value
	}
	
	job.timeout_schedule = d.get_u16()!
	job.timeout = d.get_u16()!
	job.log = d.get_bool()!
	job.ignore_error = d.get_bool()!
	
	// Decode ignore_error_codes array
	error_codes_len := d.get_u16()!
	job.ignore_error_codes = []int{len: int(error_codes_len)}
	for i in 0 .. error_codes_len {
		job.ignore_error_codes[i] = d.get_i32()!
	}
	
	job.debug = d.get_bool()!
	job.retry = d.get_i32()!
	
	// Decode JobStatus
	job.status.guid = d.get_string()!
	job.status.created.unix = d.get_i64()!
	job.status.start.unix = d.get_i64()!
	job.status.end.unix = d.get_i64()!
	status_val := d.get_u8()!
	job.status.status = match status_val {
		0 { Status.created }
		1 { Status.scheduled }
		2 { Status.planned }
		3 { Status.running }
		4 { Status.error }
		5 { Status.ok }
		else { return error('Invalid Status value: ${status_val}') }
	}
	
	// Decode dependencies array
	dependencies_len := d.get_u16()!
	job.dependencies = []JobDependency{len: int(dependencies_len)}
	for i in 0 .. dependencies_len {
		mut dependency := JobDependency{}
		dependency.guid = d.get_string()!
		
		// Decode dependency agents array
		dep_agents_len := d.get_u16()!
		dependency.agents = []string{len: int(dep_agents_len)}
		for j in 0 .. dep_agents_len {
			dependency.agents[j] = d.get_string()!
		}
		
		job.dependencies[i] = dependency
	}
	
	return job
}
