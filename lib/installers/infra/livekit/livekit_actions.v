module livekit

import freeflowuniverse.herolib.osal
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.core.pathlib
import net.http
import json
import os

// checks if a certain version or above is installed
fn installed_() !bool {
	res := os.execute('${osal.profile_path_source_and()!} livekit-server -v')
	if res.exit_code != 0 {
		return false
	}
	r := res.output.split_into_lines().filter(it.contains('version'))
	if r.len != 1 {
		return error("couldn't parse livekit version.\n${res.output}")
	}
	installedversion := r[0].all_after_first('version')
	if texttools.version(version) != texttools.version(installedversion) {
		return false
	}
	return true
}

fn install_() ! {
	console.print_header('install livekit')
	mut installer := get()!
	osal.execute_silent('
            curl -s https://livekit.io/install.sh | bash
        ')!
}

fn startupcmd() ![]zinit.ZProcessNewArgs {
	mut res := []zinit.ZProcessNewArgs{}
	mut installer := get()!
	res << zinit.ZProcessNewArgs
	{
		name: 'livekit'
		cmd:  'livekit-server --config ${installer.configpath} --bind 0.0.0.0'
	}

	return res
}

fn running_() !bool {
	mut installer := get()!

	myport := installer.nr * 2 + 7880
	endpoint := 'http://localhost:${myport}/api/v1/health'

	response := http.get(endpoint) or {
		console.print_stderr('Error connecting to LiveKit server: ${err}')
		return false
	}

	if response.status_code != 200 {
		console.print_stderr('LiveKit server returned non-200 status code: ${response.status_code}')
		return false
	}

	health_info := json.decode(map[string]string, response.body) or {
		console.print_stderr('Error decoding LiveKit server response: ${err}')
		return false
	}

	if health_info['status'] != 'ok' {
		console.print_stderr('LiveKit server health check failed: ${health_info['status']}')
		return false
	}

	return true
}

fn start_pre() ! {
	// Pre-start initialization if needed
}

fn start_post() ! {
	// Post-start operations if needed
}

fn stop_pre() ! {
	// Pre-stop operations if needed
}

fn stop_post() ! {
	// Post-stop cleanup if needed
}

fn destroy_() ! {
	mut installer := get()!
	os.rm(installer.configpath) or {}
	os.rm('livekit-server') or {}
}
