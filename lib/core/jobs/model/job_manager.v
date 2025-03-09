module model

import freeflowuniverse.herolib.data.ourtime
import json
import time

// JobManager handles all job-related operations
pub struct JobManager {
}

// job_path returns the path for a job
fn job_path(guid string) string {
	// We'll organize jobs by first 2 characters of the GUID to avoid too many files in one directory
	prefix := if guid.len >= 2 { guid[..2] } else { guid }
	return '/jobs/${prefix}/${guid}.json'
}

// new creates a new Job instance
pub fn (mut m JobManager) new() Job {
	return Job{
		guid:   '' // Empty GUID to be filled by caller
		status: JobStatus{
			guid:    ''
			created: ourtime.now()
			start:   ourtime.OurTime{}
			end:     ourtime.OurTime{}
			status:  .created
		}
	}
}

// set adds or updates a job
pub fn (mut m JobManager) set(job Job) ! {
	// Ensure the job has a valid GUID
	if job.guid.len == 0 {
		return error('Cannot store job with empty GUID')
	}

	// Implementation removed
}

// get retrieves a job by its GUID
pub fn (mut m JobManager) get(guid string) !Job {
	// Ensure the GUID is valid
	if guid.len == 0 {
		return error('Cannot get job with empty GUID')
	}

	// Implementation removed
	return Job{}
}

// list returns all jobs
pub fn (mut m JobManager) list() ![]Job {
	mut jobs := []Job{}

	// Implementation removed

	return jobs
}

// delete removes a job by its GUID
pub fn (mut m JobManager) delete(guid string) ! {
	// Ensure the GUID is valid
	if guid.len == 0 {
		return error('Cannot delete job with empty GUID')
	}

	// Implementation removed
}

// update_status updates just the status of a job
pub fn (mut m JobManager) update_status(guid string, status Status) ! {
	// Implementation removed
}

// cleanup removes jobs older than the specified number of days
pub fn (mut m JobManager) cleanup(days int) !int {
	if days <= 0 {
		return error('Days must be a positive number')
	}

	// Implementation removed
	
	return 0
}
