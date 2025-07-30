module playcmds

import freeflowuniverse.herolib.osal.sshagent
import freeflowuniverse.herolib.core.playbook {PlayBook}

fn play_ssh(args_ PlayArgs) !PlayBook {
	mut args := args_
	mut plbook := args.plbook or {
		playbook.new(text: args.heroscript, path: args.heroscript_path)!
	}

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
				return error('action name ${action.name} not supported')
			}
		}
		action.done = true
	}
	return plbook
}
