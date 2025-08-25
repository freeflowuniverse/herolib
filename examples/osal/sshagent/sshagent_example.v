module main

import freeflowuniverse.herolib.osal.sshagent
import freeflowuniverse.herolib.osal.linux

fn do1() ! {
	mut agent := sshagent.new()!
	println(agent)
	k := agent.get(name: 'kds') or { panic('notgound') }
	println(k)

	mut k2 := agent.get(name: 'books') or { panic('notgound') }
	k2.load()!
	println(k2.agent)

	println(agent)

	k2.forget()!
	println(k2.agent)

	// println(agent)
}

fn test_user_mgmt() ! {
	mut lf := linux.new()!
	// Test user creation
	lf.user_create(
		name:   'testuser'
		sshkey: 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM3/2K7R8A/l0kM0/d'
	)!

	// Test ssh key creation
	lf.sshkey_create(
		username:    'testuser'
		sshkey_name: 'testkey'
	)!

	// Test ssh key deletion
	lf.sshkey_delete(
		username:    'testuser'
		sshkey_name: 'testkey'
	)!

	// Test user deletion
	lf.user_delete(name: 'testuser')!
}

fn main() {
	do1() or { panic(err) }
	test_user_mgmt() or { panic(err) }
}
