module systemd

import freeflowuniverse.herolib.osal.core as osal

pub struct JournalArgs {
pub:
	service string // name of service for which logs will be retrieved
	limit   int = 100 // number of last log lines to be shown
}

pub fn journalctl(args JournalArgs) !string {
	cmd := 'journalctl --no-pager -n ${args.limit} -u ${name_fix(args.service)}'
	response := osal.execute_silent(cmd) or { return err }
	return response
}
