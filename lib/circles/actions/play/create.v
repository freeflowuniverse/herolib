module play

import freeflowuniverse.herolib.data.ourtime
import freeflowuniverse.herolib.circles.actions.models { JobStatus, Status }
import freeflowuniverse.herolib.data.paramsparser
import crypto.rand
import encoding.hex

// create processes a job creation action
pub fn (mut p Player) create(params paramsparser.Params) ! {
	// Create a new job
	mut job := p.job_db.new()

	// Set job properties from parameters
	job.guid = params.get_default('guid', generate_random_id()!)!
	job.actor = params.get_default('actor', '')!
	job.action = params.get_default('action', '')!
	job.circle = params.get_default('circle', 'default')!
	job.context = params.get_default('context', 'default')!

	// Set agents if provided
	if params.exists('agents') {
		job.agents = params.get_list('agents')!
	}

	// Set source if provided
	if params.exists('source') {
		job.source = params.get('source')!
	}

	// Set timeouts if provided
	if params.exists('timeout_schedule') {
		job.timeout_schedule = u16(params.get_int('timeout_schedule')!)
	}

	if params.exists('timeout') {
		job.timeout = u16(params.get_int('timeout')!)
	}

	// Set flags
	job.log = params.get_default_true('log')
	job.ignore_error = params.get_default_false('ignore_error')
	job.debug = params.get_default_false('debug')

	if params.exists('retry') {
		job.retry = u8(params.get_int('retry')!)
	}

	// Set initial status
	job.status = JobStatus{
		guid:    job.guid
		created: ourtime.now()
		status:  Status.created
	}

	// // Set any additional parameters
	// for key, value in params.get_map() {
	// 	if key !in ['guid', 'actor', 'action', 'circle', 'context', 'agents',
	// 		'source', 'timeout_schedule', 'timeout', 'log', 'ignore_error', 'debug', 'retry'] {
	// 		job.params[key] = value
	// 	}
	// }

	// Save the job
	saved_job := p.job_db.set(job)!

	// Return result based on format
	match p.return_format {
		.heroscript {
			println('!!job.created guid:\'${saved_job.guid}\' id:${saved_job.id}')
		}
		.json {
			println('{"action": "job.created", "guid": "${saved_job.guid}", "id": ${saved_job.id}}')
		}
	}
}

// generate_random_id creates a random ID string
fn generate_random_id() !string {
	random_bytes := rand.bytes(16)!
	return hex.encode(random_bytes)
}
