module model

import freeflowuniverse.herolib.core.redisclient
import freeflowuniverse.herolib.data.ourtime
import json

const (
	jobs_key = 'herorunner:jobs' // Redis key for storing jobs
)

// JobManager handles all job-related operations
pub struct JobManager {
mut:
	redis &redisclient.Redis
}

// new creates a new Job instance
pub fn (mut m JobManager) new() Job {
	return Job{
		guid: '' // Empty GUID to be filled by caller
		status: JobStatus{
			guid: ''
			created: ourtime.Time{}
			start: ourtime.Time{}
			end: ourtime.Time{}
			status: .created
		}
	}
}

// add adds a new job to Redis
pub fn (mut m JobManager) set(job Job) ! {
	// Store job in Redis hash where key is job.guid and value is JSON of job
	job_json := json.encode(job)
	m.redis.hset(jobs_key, job.guid, job_json)!
}

// get retrieves a job by its GUID
pub fn (mut m JobManager) get(guid string) !Job {
	job_json := m.redis.hget(jobs_key, guid)!
	return json.decode(Job, job_json)
}

// list returns all jobs
pub fn (mut m JobManager) list() ![]Job {
	mut jobs := []Job{}
	
	// Get all jobs from Redis hash
	jobs_map := m.redis.hgetall(jobs_key)!
	
	// Convert each JSON value to Job struct
	for _, job_json in jobs_map {
		job := json.decode(Job, job_json)!
		jobs << job
	}
	
	return jobs
}

// delete removes a job by its GUID
pub fn (mut m JobManager) delete(guid string) ! {
	m.redis.hdel(jobs_key, guid)!
}

// update_status updates just the status of a job
pub fn (mut m JobManager) update_status(guid string, status Status) ! {
	mut job := m.get(guid)!
	job.status.status = status
	m.update(job)!
}
