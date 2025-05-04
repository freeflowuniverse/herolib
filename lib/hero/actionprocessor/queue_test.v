module actionprocessor

import time
import freeflowuniverse.herolib.data.ourtime

fn test_action_job() {
	// Create a new action job
	heroscript := '!!action.test name:test1'
	job := new_action_job(heroscript)

	// Verify job properties
	assert job.guid != ''
	assert job.heroscript == heroscript
	assert job.status == ActionJobStatus.pending
	assert !job.created.empty()
	assert !job.deadline.empty()

	// Test JSON serialization
	json_str := job.to_json()
	job2 := action_job_from_json(json_str) or {
		assert false, 'Failed to decode job from JSON: ${err}'
		return
	}

	// Verify deserialized job
	assert job2.guid == job.guid
	assert job2.heroscript == job.heroscript
	assert job2.status == job.status

	// Test creating job with custom deadline
	job3 := new_action_job_with_deadline(heroscript, '+2h') or {
		assert false, 'Failed to create job with deadline: ${err}'
		return
	}
	assert job3.deadline.unix() > job.deadline.unix()
}

fn test_action_queue() {
	// Skip this test if Redis is not available
	$if !test_with_redis ? {
		println('Skipping Redis test (use -d test_with_redis to run)')
		return
	}

	// Create a new action queue
	queue_name := 'test_queue_${time.now().unix_milli()}'
	mut queue := new_action_queue(ActionQueueArgs{
		name: queue_name
	}) or {
		assert false, 'Failed to create action queue: ${err}'
		return
	}

	// Create test jobs
	mut job1 := new_action_job('!!action.test1 name:test1')
	mut job2 := new_action_job('!!action.test2 name:test2')
	mut job3 := new_action_job('!!action.test3 name:test3')
	mut job4 := new_action_job('!!action.test4 name:test4')

	// Add jobs to the queue
	queue.add_job(job1) or {
		assert false, 'Failed to add job1: ${err}'
		return
	}
	queue.add_job(job2) or {
		assert false, 'Failed to add job2: ${err}'
		return
	}
	queue.add_job(job3) or {
		assert false, 'Failed to add job3: ${err}'
		return
	}

	// Test count_waiting_jobs
	wait_count := queue.count_waiting_jobs() or {
		assert false, 'Failed to count waiting jobs: ${err}'
		return
	}
	assert wait_count == 3, 'Expected 3 waiting jobs, got ${wait_count}'

	// Fetch jobs from the queue
	fetched_job1 := queue.pop_job() or {
		assert false, 'Failed to pop job1: ${err}'
		return
	}
	assert fetched_job1.guid == job1.guid
	assert fetched_job1.heroscript == job1.heroscript

	fetched_job2 := queue.pop_job() or {
		assert false, 'Failed to pop job2: ${err}'
		return
	}
	assert fetched_job2.guid == job2.guid
	assert fetched_job2.heroscript == job2.heroscript

	// Update job status
	queue.update_job_status(job3.guid, .processing) or {
		assert false, 'Failed to update job status: ${err}'
		return
	}

	// Fetch job with updated status
	fetched_job3 := queue.pop_job() or {
		assert false, 'Failed to pop job3: ${err}'
		return
	}
	assert fetched_job3.guid == job3.guid
	assert fetched_job3.status == .processing

	// Test setting a job as failed with error message
	queue.add_job(job4) or {
		assert false, 'Failed to add job4: ${err}'
		return
	}

	// Set job as failed
	queue.set_job_failed(job4.guid, 'Test error message') or {
		assert false, 'Failed to set job as failed: ${err}'
		return
	}

	// Get the failed job and verify error message
	failed_job := queue.get_job(job4.guid) or {
		assert false, 'Failed to get failed job: ${err}'
		return
	}
	assert failed_job.status == .failed
	assert failed_job.error == 'Test error message'

	// Test finding failed jobs
	failed_jobs := queue.find_failed_jobs() or {
		assert false, 'Failed to find failed jobs: ${err}'
		return
	}
	assert failed_jobs.len > 0, 'Expected at least one failed job'
	assert failed_jobs[0].guid == job4.guid
	assert failed_jobs[0].error == 'Test error message'

	// Delete a job
	queue.delete_job(job3.guid) or {
		assert false, 'Failed to delete job: ${err}'
		return
	}

	// Try to get deleted job (should fail)
	queue.get_job(job3.guid) or {
		// Expected error
		assert err.str().contains('not found')
		return
	}

	// Test direct put and fetch to verify heroscript preservation
	test_heroscript := '!!action.special name:direct_test param1:value1 param2:value2'
	mut direct_job := new_action_job(test_heroscript)

	// Add the job
	queue.add_job(direct_job) or {
		assert false, 'Failed to add direct job: ${err}'
		return
	}

	// Fetch the job by GUID
	fetched_direct_job := queue.get_job(direct_job.guid) or {
		assert false, 'Failed to get direct job: ${err}'
		return
	}

	// Verify the heroscript is preserved exactly
	assert fetched_direct_job.heroscript == test_heroscript, 'Heroscript was not preserved correctly'

	// Clean up
	queue.delete() or {
		assert false, 'Failed to delete queue: ${err}'
		return
	}
}
