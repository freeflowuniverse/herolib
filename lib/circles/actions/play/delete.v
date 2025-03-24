module play

import freeflowuniverse.herolib.data.paramsparser

// delete processes a job deletion action
pub fn (mut p Player) delete(params paramsparser.Params) ! {
	if params.exists('id') {
		id := u32(params.get_int('id')!)
		p.job_db.delete(id)!
		
		// Return result based on format
		match p.return_format {
			.heroscript {
				println('!!job.deleted id:${id}')
			}
			.json {
				println('{"action": "job.deleted", "id": ${id}}')
			}
		}
	} else if params.exists('guid') {
		guid := params.get('guid')!
		p.job_db.delete_by_guid(guid)!
		
		// Return result based on format
		match p.return_format {
			.heroscript {
				println('!!job.deleted guid:\'${guid}\'')
			}
			.json {
				println('{"action": "job.deleted", "guid": "${guid}"}')
			}
		}
	} else {
		return error('Either id or guid must be provided for job.delete')
	}
}
