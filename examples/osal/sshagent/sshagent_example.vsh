#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.osal.sshagent
import freeflowuniverse.herolib.ui.console

fn do_sshagent_example() ! {
	console.print_header('SSH Agent Basic Example')

	mut agent := sshagent.new()!
	console.print_debug('SSH Agent created')
	println(agent)

	// Generate a test key if no keys exist
	if agent.keys.len == 0 {
		console.print_debug('No keys found, generating test key...')
		mut test_key := agent.generate('test_example_key', '')!
		test_key.load()!
		console.print_debug('Test key generated and loaded')
	}

	// Try to get a specific key (this will fail if key doesn't exist)
	console.print_debug('Looking for existing keys...')

	if agent.keys.len > 0 {
		// Work with the first available key
		mut first_key := agent.keys[0]
		console.print_debug('Found key: ${first_key.name}')

		if !first_key.loaded {
			console.print_debug('Loading key...')
			first_key.load()!
			console.print_debug('Key loaded')
		}

		console.print_debug('Key details:')
		println(first_key)

		// Show agent status after loading
		console.print_debug('Agent status after loading:')
		println(agent)

		// Note: We don't call forget() in this example to avoid removing keys
		// first_key.forget()!
	} else {
		console.print_debug('No keys available in agent')
	}
}

fn main() {
	do_sshagent_example() or {
		console.print_debug('Error: ${err}')
		panic(err)
	}
	console.print_header('SSH Agent example completed successfully!')
}
