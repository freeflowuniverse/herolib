module db

import os
import rand
import freeflowuniverse.herolib.circles.actionprocessor
import freeflowuniverse.herolib.circles.actions.models { Status, JobStatus }
import freeflowuniverse.herolib.data.ourtime

fn test_job_db() {
	// Create a temporary directory for testing
	test_dir := os.join_path(os.temp_dir(), 'hero_job_test_${rand.intn(9000) or { 0 } + 1000}')
	os.mkdir_all(test_dir) or { panic(err) }
	defer { os.rmdir_all(test_dir) or {} }
	
	mut runner := actionprocessor.new(path: test_dir)!

	// Create multiple jobs for testing
	mut job1 := runner.jobs.new()
	job1.guid = 'job-1'
	job1.actor = 'vm_manager'
	job1.action = 'start'
	job1.circle = 'circle1'
	job1.context = 'context1'
	job1.agents = ['agent1', 'agent2']
	job1.source = 'source1'
	job1.params = {
		'id': '10'
		'name': 'test-vm'
	}
	job1.status.guid = job1.guid
	job1.status.created = ourtime.now()
	job1.status.status = .created

	mut job2 := runner.jobs.new()
	job2.guid = 'job-2'
	job2.actor = 'vm_manager'
	job2.action = 'stop'
	job2.circle = 'circle1'
	job2.context = 'context2'
	job2.agents = ['agent1']
	job2.source = 'source1'
	job2.params = {
		'id': '11'
		'name': 'test-vm-2'
	}
	job2.status.guid = job2.guid
	job2.status.created = ourtime.now()
	job2.status.status = .created

	mut job3 := runner.jobs.new()
	job3.guid = 'job-3'
	job3.actor = 'network_manager'
	job3.action = 'create'
	job3.circle = 'circle2'
	job3.context = 'context1'
	job3.agents = ['agent3']
	job3.source = 'source2'
	job3.params = {
		'name': 'test-network'
		'type': 'bridge'
	}
	job3.status.guid = job3.guid
	job3.status.created = ourtime.now()
	job3.status.status = .created

	// Add the jobs
	println('Adding job 1')
	job1 = runner.jobs.set(job1)!
	
	println('Adding job 2')
	job2 = runner.jobs.set(job2)!
	
	println('Adding job 3')
	job3 = runner.jobs.set(job3)!

	// Test list functionality
	println('Testing list functionality')
	
	// Get all jobs
	all_jobs := runner.jobs.getall()!
	println('Retrieved ${all_jobs.len} jobs')
	for i, job in all_jobs {
		println('Job ${i}: id=${job.id}, guid=${job.guid}, actor=${job.actor}')
	}
	
	assert all_jobs.len == 3, 'Expected 3 jobs, got ${all_jobs.len}'
	
	// Verify all jobs are in the list
	mut found1 := false
	mut found2 := false
	mut found3 := false
	
	for job in all_jobs {
		if job.guid == 'job-1' {
			found1 = true
		} else if job.guid == 'job-2' {
			found2 = true
		} else if job.guid == 'job-3' {
			found3 = true
		}
	}
	
	assert found1, 'Job 1 not found in list'
	assert found2, 'Job 2 not found in list'
	assert found3, 'Job 3 not found in list'

	// Get and verify individual jobs
	println('Verifying individual jobs')
	retrieved_job1 := runner.jobs.get_by_guid('job-1')!
	assert retrieved_job1.guid == job1.guid
	assert retrieved_job1.actor == job1.actor
	assert retrieved_job1.action == job1.action
	assert retrieved_job1.circle == job1.circle
	assert retrieved_job1.context == job1.context
	assert retrieved_job1.agents.len == 2
	assert retrieved_job1.agents[0] == 'agent1'
	assert retrieved_job1.agents[1] == 'agent2'
	assert retrieved_job1.params['id'] == '10'
	assert retrieved_job1.params['name'] == 'test-vm'
	assert retrieved_job1.status.status == .created

	// Test get_by_actor method
	println('Testing get_by_actor method')
	
	// Debug: Print all jobs and their actors
	all_jobs_debug := runner.jobs.getall()!
	println('Debug - All jobs:')
	for job in all_jobs_debug {
		println('Job ID: ${job.id}, GUID: ${job.guid}, Actor: ${job.actor}')
	}
	
	// Debug: Print the index keys for job1 and job2
	println('Debug - Index keys for job1:')
	for k, v in job1.index_keys() {
		println('${k}: ${v}')
	}
	println('Debug - Index keys for job2:')
	for k, v in job2.index_keys() {
		println('${k}: ${v}')
	}
	
	vm_manager_jobs := runner.jobs.get_by_actor('vm_manager')!
	println('Found ${vm_manager_jobs.len} jobs with actor "vm_manager"')
	for i, job in vm_manager_jobs {
		println('VM Manager Job ${i}: ID=${job.id}, GUID=${job.guid}')
	}
	
	// Now we should find both jobs with actor "vm_manager"
	assert vm_manager_jobs.len == 2
	assert vm_manager_jobs[0].guid in ['job-1', 'job-2']
	assert vm_manager_jobs[1].guid in ['job-1', 'job-2']

	// Test get_by_circle method
	println('Testing get_by_circle method')
	circle1_jobs := runner.jobs.get_by_circle('circle1')!
	assert circle1_jobs.len == 2
	assert circle1_jobs[0].guid in ['job-1', 'job-2']
	assert circle1_jobs[1].guid in ['job-1', 'job-2']

	// Test get_by_context method
	println('Testing get_by_context method')
	context1_jobs := runner.jobs.get_by_context('context1')!
	assert context1_jobs.len == 2
	assert context1_jobs[0].guid in ['job-1', 'job-3']
	assert context1_jobs[1].guid in ['job-1', 'job-3']

	// Test get_by_circle_and_context method
	println('Testing get_by_circle_and_context method')
	circle1_context1_jobs := runner.jobs.get_by_circle_and_context('circle1', 'context1')!
	assert circle1_context1_jobs.len == 1
	assert circle1_context1_jobs[0].guid == 'job-1'

	// Test update_job_status method
	println('Testing update_job_status method')
	updated_job1 := runner.jobs.update_job_status('job-1', JobStatus{status: Status.running})!
	assert updated_job1.status.status == Status.running
	
	// Verify the status was updated in the database
	status_updated_job1 := runner.jobs.get_by_guid('job-1')!
	assert status_updated_job1.status.status == Status.running

	// Test delete functionality
	println('Testing delete functionality')
	// Delete job 2
	runner.jobs.delete_by_guid('job-2')!
	
	// Verify deletion with list
	jobs_after_delete := runner.jobs.getall()!
	assert jobs_after_delete.len == 2, 'Expected 2 jobs after deletion, got ${jobs_after_delete.len}'
	
	// Verify the remaining jobs
	mut found_after_delete1 := false
	mut found_after_delete2 := false
	mut found_after_delete3 := false
	
	for job in jobs_after_delete {
		if job.guid == 'job-1' {
			found_after_delete1 = true
		} else if job.guid == 'job-2' {
			found_after_delete2 = true
		} else if job.guid == 'job-3' {
			found_after_delete3 = true
		}
	}
	
	assert found_after_delete1, 'Job 1 not found after deletion'
	assert !found_after_delete2, 'Job 2 found after deletion (should be deleted)'
	assert found_after_delete3, 'Job 3 not found after deletion'

	// Delete another job
	println('Deleting another job')
	runner.jobs.delete_by_guid('job-3')!
	
	// Verify only one job remains
	jobs_after_second_delete := runner.jobs.getall()!
	assert jobs_after_second_delete.len == 1, 'Expected 1 job after second deletion, got ${jobs_after_second_delete.len}'
	assert jobs_after_second_delete[0].guid == 'job-1', 'Remaining job should be job-1'

	// Delete the last job
	println('Deleting last job')
	runner.jobs.delete_by_guid('job-1')!
	
	// Verify no jobs remain
	jobs_after_all_deleted := runner.jobs.getall() or {
		// This is expected to fail with 'No jobs found' error
		assert err.msg().contains('No index keys defined for this type') || err.msg().contains('No jobs found')
		[]models.Job{cap: 0}
	}
	assert jobs_after_all_deleted.len == 0, 'Expected 0 jobs after all deletions, got ${jobs_after_all_deleted.len}'

	println('All tests passed successfully')
}
