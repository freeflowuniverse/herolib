module python

import freeflowuniverse.herolib.osal
import freeflowuniverse.herolib.core.texttools

pub fn (py PythonEnv) shell(name_ string) ! {
	_ := texttools.name_fix(name_)
	cmd := '
	cd ${py.path.path}
	source bin/activate
	
	'
	osal.exec(cmd: cmd)!
}
