#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.circles.actions.play { Player, ReturnFormat }
import os
import flag

fn main() {
	mut fp := flag.new_flag_parser(os.args)
	fp.application('play_jobs.vsh')
	fp.version('v0.1.0')
	fp.description('Process heroscript job commands for circles actions')
	fp.skip_executable()

	input_file := fp.string('file', `f`, '', 'Input heroscript file')
	input_text := fp.string('text', `t`, '', 'Input heroscript text')
	actor := fp.string('actor', `a`, 'job', 'Actor name to process')
	json_output := fp.bool('json', `j`, false, 'Output in JSON format')
	help_requested := fp.bool('help', `h`, false, 'Show help message')

	if help_requested {
		println(fp.usage())
		exit(0)
	}

	additional_args := fp.finalize() or {
		eprintln(err)
		println(fp.usage())
		exit(1)
	}

	// Determine return format
	return_format := if json_output { ReturnFormat.json } else { ReturnFormat.heroscript }

	// Create a new player
	mut player := play.new_player(actor, return_format) or {
		eprintln('Failed to create player: ${err}')
		exit(1)
	}

	// Load heroscript from file or text
	mut input := ''
	mut is_text := false
	
	if input_file != '' {
		input = input_file
		is_text = false
	} else if input_text != '' {
		input = input_text
		is_text = true
	} else {
		eprintln('Either --file or --text must be provided')
		println(fp.usage())
		exit(1)
	}

	// Process the heroscript
	player.play(input, is_text) or {
		eprintln('Failed to process heroscript: ${err}')
		exit(1)
	}
}
