module model

import freeflowuniverse.herolib.core.redisclient
import freeflowuniverse.herolib.data.ourtime

fn test_jobs() {
	mut runner := new()!

	// Create a new job using the manager
	mut job := runner.jobs.new()
	job.guid = 'test-job-1'
	job.actor = 'vm_manager'
	job.action = 'start'
	job.params = {
		'id': '10'
	}

	// Add the job
	runner.jobs.set(job)!

	// Get the job and verify fields
	retrieved_job := runner.jobs.get(job.guid)!
	assert retrieved_job.guid == job.guid
	assert retrieved_job.actor == job.actor
	assert retrieved_job.action == job.action
	assert retrieved_job.params['id'] == job.params['id']
	assert retrieved_job.status.status == .created

	// Update job status
	runner.jobs.update_status(job.guid, .running)!
	updated_job := runner.jobs.get(job.guid)!
	assert updated_job.status.status == .running

	// List all jobs
	jobs := runner.jobs.list()!
	assert jobs.len > 0
	assert jobs[0].guid == job.guid

	// Delete the job
	runner.jobs.delete(job.guid)!

	// Verify deletion
	jobs_after := runner.jobs.list()!
	for j in jobs_after {
		assert j.guid != job.guid
	}
}
