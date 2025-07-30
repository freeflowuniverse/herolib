module actionprocessor

import freeflowuniverse.herolib.core.redisclient
import freeflowuniverse.herolib.data.ourtime
import freeflowuniverse.herolib.core.playbook
import json
import time

// ActionJobStatus represents the current status of an action job
pub enum ActionJobStatus {
	pending
	processing
	completed
	failed
	cancelled
}

// ActionJob represents a job to be processed by the action processor
@[heap]
pub struct ActionJob {
pub mut:
	guid       string
	heroscript string
	created    ourtime.OurTime
	deadline   ourtime.OurTime
	status     ActionJobStatus
	error      string // Error message if job failed
	async      bool   // Whether the job should be processed asynchronously
	circleid   string // ID of the circle this job belongs to
}

// ActionQueue is a queue of actions to be processed, which comes from a redis queue
@[heap]
pub struct ActionQueue {
pub mut:
	name  string
	queue &redisclient.RedisQueue
	redis &redisclient.Redis
}

// new_action_job creates a new ActionJob with the given heroscript
pub fn new_action_job(heroscript string) ActionJob {
	now := ourtime.now()
	// Default deadline is 1 hour from now
	mut deadline := ourtime.now()
	deadline.warp('+1h') or { panic('Failed to set deadline: ${err}') }

	return ActionJob{
		guid:       time.now().unix_milli().str()
		heroscript: heroscript
		created:    now
		deadline:   deadline
		status:     .pending
		async:      false
		circleid:   ''
	}
}

// new_action_job_with_deadline creates a new ActionJob with the given heroscript and deadline
pub fn new_action_job_with_deadline(heroscript string, deadline_str string) !ActionJob {
	mut job := new_action_job(heroscript)
	job.deadline = ourtime.new(deadline_str)!
	return job
}

// to_json converts the ActionJob to a JSON string
pub fn (job ActionJob) to_json() string {
	return json.encode(job)
}

// from_json creates an ActionJob from a JSON string
pub fn action_job_from_json(data string) !ActionJob {
	return json.decode(ActionJob, data)
}

// to_plbook converts the job's heroscript to a PlayBook object
pub fn (job ActionJob) to_plbook() !&playbook.PlayBook {
	if job.heroscript.trim_space() == '' {
		return error('No heroscript content in job')
	}

	// Create a new PlayBook with the heroscript content
	mut pb := playbook.new(text: job.heroscript)!

	// Check if any actions were found
	if pb.actions.len == 0 {
		return error('No actions found in heroscript')
	}

	return &pb
}

// add adds a job to the queue
pub fn (mut q ActionQueue) add_job(job ActionJob) ! {
	// Store the job in Redis using HSET
	job_key := 'heroactionjobs:${job.guid}'
	q.redis.hset(job_key, 'guid', job.guid)!
	q.redis.hset(job_key, 'heroscript', job.heroscript)!
	q.redis.hset(job_key, 'created', job.created.unix().str())!
	q.redis.hset(job_key, 'deadline', job.deadline.unix().str())!
	q.redis.hset(job_key, 'status', job.status.str())!
	q.redis.hset(job_key, 'async', job.async.str())!
	q.redis.hset(job_key, 'circleid', job.circleid)!
	if job.error != '' {
		q.redis.hset(job_key, 'error', job.error)!
	}

	// Add the job reference to the queue
	q.queue.add(job.guid)!
}

// get_job retrieves a job from Redis by its GUID
pub fn (mut q ActionQueue) get_job(guid string) !ActionJob {
	job_key := 'heroactionjobs:${guid}'

	// Check if the job exists
	if !q.redis.exists(job_key)! {
		return error('Job with GUID ${guid} not found')
	}

	// Retrieve job fields
	mut job := ActionJob{
		guid:       guid
		heroscript: q.redis.hget(job_key, 'heroscript')!
		status:     ActionJobStatus.pending // Default value, will be overwritten
		error:      ''       // Default empty error message
		async:      false    // Default to synchronous
		circleid:   ''       // Default to empty circle ID
	}

	// Parse created time
	created_str := q.redis.hget(job_key, 'created')!
	created_unix := created_str.i64()
	job.created = ourtime.new_from_epoch(u64(created_unix))

	// Parse deadline
	deadline_str := q.redis.hget(job_key, 'deadline')!
	deadline_unix := deadline_str.i64()
	job.deadline = ourtime.new_from_epoch(u64(deadline_unix))

	// Parse status
	status_str := q.redis.hget(job_key, 'status')!
	match status_str {
		'pending' { job.status = .pending }
		'processing' { job.status = .processing }
		'completed' { job.status = .completed }
		'failed' { job.status = .failed }
		'cancelled' { job.status = .cancelled }
		else { job.status = .pending } // Default to pending if unknown
	}

	// Get error message if exists
	job.error = q.redis.hget(job_key, 'error') or { '' }

	// Get async flag
	async_str := q.redis.hget(job_key, 'async') or { 'false' }
	job.async = async_str == 'true'

	// Get circle ID
	job.circleid = q.redis.hget(job_key, 'circleid') or { '' }

	return job
}

// update_job_status updates the status of a job in Redis
pub fn (mut q ActionQueue) update_job_status(guid string, status ActionJobStatus) ! {
	job_key := 'heroactionjobs:${guid}'

	// Check if the job exists
	if !q.redis.exists(job_key)! {
		return error('Job with GUID ${guid} not found')
	}

	// Update status
	q.redis.hset(job_key, 'status', status.str())!
}

// set_job_failed marks a job as failed with an error message
pub fn (mut q ActionQueue) set_job_failed(guid string, error_msg string) ! {
	job_key := 'heroactionjobs:${guid}'

	// Check if the job exists
	if !q.redis.exists(job_key)! {
		return error('Job with GUID ${guid} not found')
	}

	// Update status and error message
	q.redis.hset(job_key, 'status', ActionJobStatus.failed.str())!
	q.redis.hset(job_key, 'error', error_msg)!
}

// count_waiting_jobs returns the number of jobs waiting in the queue
pub fn (mut q ActionQueue) count_waiting_jobs() !int {
	// Get the length of the queue
	return q.redis.llen('actionqueue:${q.name}')!
}

// find_failed_jobs returns a list of failed jobs
pub fn (mut q ActionQueue) find_failed_jobs() ![]ActionJob {
	// Use Redis KEYS to find all job keys (since SCAN is more complex)
	// In a production environment with many keys, KEYS should be avoided
	// and replaced with a more efficient implementation using SCAN
	keys := q.redis.keys('heroactionjobs:*')!
	mut failed_jobs := []ActionJob{}

	for key in keys {
		// Check if job is failed
		status := q.redis.hget(key, 'status') or { continue }
		if status == ActionJobStatus.failed.str() {
			// Get the job GUID from the key
			guid := key.all_after('heroactionjobs:')

			// Get the full job
			job := q.get_job(guid) or { continue }
			failed_jobs << job
		}
	}

	return failed_jobs
}

// delete_job deletes a job from Redis
pub fn (mut q ActionQueue) delete_job(guid string) ! {
	job_key := 'heroactionjobs:${guid}'

	// Check if the job exists
	if !q.redis.exists(job_key)! {
		return error('Job with GUID ${guid} not found')
	}

	// Delete the job
	q.redis.del(job_key)!
}

// add adds a string value to the queue
pub fn (mut q ActionQueue) add(val string) ! {
	q.queue.add(val)!
}

// get retrieves a value from the queue with timeout
// timeout in msec
pub fn (mut q ActionQueue) get(timeout u64) !string {
	return q.queue.get(timeout)!
}

// pop retrieves a value from the queue without timeout
// get without timeout, returns none if nil
pub fn (mut q ActionQueue) pop() !string {
	return q.queue.pop()!
}

// fetch_job retrieves the next job from the queue
pub fn (mut q ActionQueue) fetch_job(timeout u64) !ActionJob {
	guid := q.queue.get(timeout)!
	return q.get_job(guid)!
}

// pop_job retrieves the next job from the queue without timeout
pub fn (mut q ActionQueue) pop_job() !ActionJob {
	guid := q.queue.pop()!
	return q.get_job(guid)!
}

// delete clears the queue (removes all items)
pub fn (mut q ActionQueue) delete() ! {
	// Since RedisQueue doesn't have a delete method, we'll implement our own
	// by deleting the key in Redis
	q.redis.del('actionqueue:${q.name}')!
}
