module vfs_calendar

import freeflowuniverse.herolib.vfs
import freeflowuniverse.herolib.circles.mcc.db as core

// new creates a new calendar_db VFS instance
pub fn new(calendar_db &core.CalendarDB) !vfs.VFSImplementation {
	return new_calendar_vfs(calendar_db)!
}
