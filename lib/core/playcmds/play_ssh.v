module playcmds

import freeflowuniverse.herolib.osal.sshagent
import freeflowuniverse.herolib.core.playbook { PlayBook }

fn play_ssh(mut plbook PlayBook) ! {
	mut agent := sshagent.new()!
	for mut action in plbook.find(filter: 'sshagent.*')! {
		mut p := action.params
		match action.name {
			'key_add' {
				name := p.get('name')!
				privkey := p.get('privkey')!
				agent.add(name, privkey)!
			}
			else {
				// Currently only `key_add` is supported
				return error('action name ${action.name} not supported')
			}
		}
		action.done = true
	}
}
