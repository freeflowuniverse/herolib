module play

import freeflowuniverse.herolib.data.paramsparser
import json

// list processes a job listing action
pub fn (mut p Player) list(params paramsparser.Params) ! {
	// Get all job IDs
	ids := p.job_db.list()!
	
	if params.get_default_false('verbose') {
		// Get all jobs if verbose mode is enabled
		jobs := p.job_db.getall()!
		
		// Return result based on format
		match p.return_format {
			.heroscript {
				println('!!job.list_result count:${jobs.len}')
				for job in jobs {
					println('!!job.item id:${job.id} guid:\'${job.guid}\' actor:\'${job.actor}\' action:\'${job.action}\' status:\'${job.status.status}\'')
				}
			}
			.json {
				println(json.encode(jobs))
			}
		}
	} else {
		// Return result based on format
		match p.return_format {
			.heroscript {
				println('!!job.list_result count:${ids.len} ids:\'${ids.map(it.str()).join(",")}\'')
			}
			.json {
				println('{"action": "job.list_result", "count": ${ids.len}, "ids": ${json.encode(ids)}}')
			}
		}
	}
}
