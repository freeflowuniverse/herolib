module play

import freeflowuniverse.herolib.data.paramsparser
import json

// get processes a job retrieval action
pub fn (mut p Player) get(params paramsparser.Params) ! {
	mut job_result := ''

	if params.exists('id') {
		id := u32(params.get_int('id')!)
		job := p.job_db.get(id)!

		// Return result based on format
		match p.return_format {
			.heroscript {
				job_result = '!!job.result id:${job.id} guid:\'${job.guid}\' actor:\'${job.actor}\' action:\'${job.action}\' status:\'${job.status.status}\''
			}
			.json {
				job_result = json.encode(job)
			}
		}
	} else if params.exists('guid') {
		guid := params.get('guid')!
		job := p.job_db.get_by_guid(guid)!

		// Return result based on format
		match p.return_format {
			.heroscript {
				job_result = '!!job.result id:${job.id} guid:\'${job.guid}\' actor:\'${job.actor}\' action:\'${job.action}\' status:\'${job.status.status}\''
			}
			.json {
				job_result = json.encode(job)
			}
		}
	} else {
		return error('Either id or guid must be provided for job.get')
	}

	println(job_result)
}
