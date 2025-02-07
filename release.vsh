#!/usr/bin/env -S v run

import os
import net.http
import x.json2 as json
import regex

struct GithubRelease {
	tag_name string
}

fn get_latest_release() !string {
	url := 'https://api.github.com/repos/freeflowuniverse/herolib/releases/latest'
	resp := http.get(url)!
	release := json.decode[GithubRelease](resp.body) or {
		return error('Failed to decode GitHub response: ${err}')
	}
	return release.tag_name
}


// Show current version
latest_release := get_latest_release() or {
	eprintln('Error getting latest release: ${err}')
	exit(1)
}
println('Current latest release: ${latest_release}')

// Ask for new version
new_version := os.input('Enter new version (e.g., 1.0.4): ')

// Validate version format
version_re := regex.regex_opt(r'^[0-9]+\.[0-9]+\.[0-9]+$') or {
	eprintln('Error creating regex: ${err}')
	exit(1)
}
if !version_re.matches_string(new_version) {
	eprintln('Error: Version must be in format X.Y.Z (e.g., 1.0.4)')
	exit(1)
}

ourdir := dir(@FILE)


hero_v_path := '${ourdir}/cli/hero.v'

// Read hero.v
content := os.read_file(hero_v_path) or {
	eprintln('Error reading ${hero_v_path}: ${err}')
	exit(1)
}

// Find version line
mut version_line_idx := -1
mut lines := content.split_into_lines()
for i, line in lines {
	if line.contains('version:') {
		version_line_idx = i
		break
	}
}
if version_line_idx == -1 {
	eprintln('Error: Could not find version line in ${hero_v_path}')
	exit(1)
}

// Get indentation
old_line := lines[version_line_idx]
indent := old_line.all_before('version:')

// Create backup
os.cp(hero_v_path, '${hero_v_path}.backup') or {
	eprintln('Error creating backup: ${err}')
	exit(1)
}

// Replace version line
lines[version_line_idx] = '		version:     \'${new_version}\''

// Write back to file
os.write_file(hero_v_path, lines.join_lines()) or {
	eprintln('Error writing to ${hero_v_path}: ${err}')
	// Restore backup
	os.cp('${hero_v_path}.backup', hero_v_path) or {
		eprintln('Error restoring backup: ${err}')
	}
	exit(1)
}

// Clean up backup
os.rm('${hero_v_path}.backup') or {
	eprintln('Warning: Could not remove backup file: ${err}')
}

// Git operations
os.execute('git add ${hero_v_path}')
os.execute('git commit -m "chore: bump version to ${new_version}"')
os.execute('git pull')
os.execute('git push')
os.execute('git tag -a "v${new_version}" -m "Release version ${new_version}"')
os.execute('git push origin "v${new_version}"')

println('Release v${new_version} created and pushed!')
