module play

import freeflowuniverse.herolib.data.paramsparser
import freeflowuniverse.herolib.circles.actions.models { JobStatus, Status }
import freeflowuniverse.herolib.data.ourtime

// update_status processes a job status update action
pub fn (mut p Player) update_status(params paramsparser.Params) ! {
	if params.exists('guid') && params.exists('status') {
		guid := params.get('guid')!
		status_str := params.get('status')!

		// Convert status string to Status enum
		mut new_status := Status.created
		match status_str {
			'created' {
				new_status = Status.created
			}
			'scheduled' {
				new_status = Status.scheduled
			}
			'planned' {
				new_status = Status.planned
			}
			'running' {
				new_status = Status.running
			}
			'error' {
				new_status = Status.error
			}
			'ok' {
				new_status = Status.ok
			}
			else {
				return error('Invalid status value: ${status_str}')
			}
		}

		// Create job status object
		mut job_status := JobStatus{
			guid:    guid
			created: ourtime.now()
			status:  new_status
		}

		// Set start time if provided
		if params.exists('start') {
			job_status.start = params.get_time('start')!
		} else {
			job_status.start = ourtime.now()
		}

		// Set end time if provided
		if params.exists('end') {
			job_status.end = params.get_time('end')!
		} else if new_status in [Status.error, Status.ok] {
			// Automatically set end time for terminal statuses
			job_status.end = ourtime.now()
		}

		// Update job status
		p.job_db.update_job_status(guid, job_status)!

		// Return result based on format
		match p.return_format {
			.heroscript {
				println('!!job.status_updated guid:\'${guid}\' status:\'${status_str}\'')
			}
			.json {
				println('{"action": "job.status_updated", "guid": "${guid}", "status": "${status_str}"}')
			}
		}
	} else {
		return error('Both guid and status must be provided for job.update_status')
	}
}
