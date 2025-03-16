module db

import freeflowuniverse.herolib.circles.base { DBHandler, SessionState, new_dbhandler }
import freeflowuniverse.herolib.circles.actions.models { Job, job_loads, JobStatus }

@[heap]
pub struct JobDB {
pub mut:
	db DBHandler[Job]
}

pub fn new_jobdb(session_state SessionState) !JobDB {
	return JobDB{
		db: new_dbhandler[Job]('job', session_state)
	}
}

pub fn (mut m JobDB) new() Job {
	return Job{}
}

// set adds or updates a job
pub fn (mut m JobDB) set(job Job) !Job {
	return m.db.set(job)!
}

// get retrieves a job by its ID
pub fn (mut m JobDB) get(id u32) !Job {
	return m.db.get(id)!
}

// list returns all job IDs
pub fn (mut m JobDB) list() ![]u32 {
	return m.db.list()!
}

pub fn (mut m JobDB) getall() ![]Job {
	return m.db.getall()!
}

// delete removes a job by its ID
pub fn (mut m JobDB) delete(id u32) ! {
	m.db.delete(id)!
}

//////////////////CUSTOM METHODS//////////////////////////////////

// get_by_guid retrieves a job by its GUID
pub fn (mut m JobDB) get_by_guid(guid string) !Job {
	return m.db.get_by_key('guid', guid)!
}

// delete_by_guid removes a job by its GUID
pub fn (mut m JobDB) delete_by_guid(guid string) ! {
	// Get the job by GUID
	job := m.get_by_guid(guid) or {
		// Job not found, nothing to delete
		return
	}
	
	// Delete the job by ID
	m.delete(job.id)!
}

// get_by_actor retrieves all jobs for a specific actor
pub fn (mut m JobDB) get_by_actor(actor string) ![]Job {
	// Get all jobs with this actor
	return m.db.getall_by_prefix('actor', actor)!
}

// get_by_circle retrieves all jobs for a specific circle
pub fn (mut m JobDB) get_by_circle(circle string) ![]Job {
	// Get all jobs with this circle
	return m.db.getall_by_prefix('circle', circle)!
}

// get_by_context retrieves all jobs for a specific context
pub fn (mut m JobDB) get_by_context(context string) ![]Job {
	// Get all jobs with this context
	return m.db.getall_by_prefix('context', context)!
}

// get_by_circle_and_context retrieves all jobs for a specific circle and context
pub fn (mut m JobDB) get_by_circle_and_context(circle string, context string) ![]Job {
	// Get all jobs for this circle
	circle_jobs := m.get_by_circle(circle)!
	
	// Filter for the specific context
	mut result := []Job{}
	for job in circle_jobs {
		if job.context == context {
			result << job
		}
	}
	
	return result
}

// update_job_status updates the status of a job
pub fn (mut m JobDB) update_job_status(guid string, new_status JobStatus) !Job {
	// Get the job by GUID
	mut job := m.get_by_guid(guid)!
	
	// Update the job status
	job.status = new_status
	
	// Save the updated job
	return m.set(job)!
}
