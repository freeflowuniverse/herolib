module garage_s3

import freeflowuniverse.herolib.osal
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.core.texttools
import os

pub fn installll(args_ S3Config) ! {
	mut args := args_
	version := '1.0.0'

	res := os.execute('garage --version')
	if res.exit_code == 0 {
		r := res.output.split(' ')
		if r.len < 2 {
			return error("couldn't parse garage version, expected 'garage v*'.\n${res.output}")
		}

		v := r[1]
		if texttools.version(v) < texttools.version(version) {
			args.reset = true
		}
	} else {
		args.reset = true
	}

	if args.reset {
		console.print_header('install garage')

		mut url := ''
		if core.is_linux_arm()! {
			url = 'https://garagehq.deuxfleurs.fr/_releases/v${version}/aarch64-unknown-linux-musl/garage'
		} else if core.is_linux_intel()! {
			url = 'https://garagehq.deuxfleurs.fr/_releases/v${version}/x86_64-unknown-linux-musl/garage'
		} else {
			return error('unsported platform')
		}

		mut dest := osal.download(
			url:        url
			minsize_kb: 15 * 1024
			dest:       '/tmp/garage'
			reset:      true
		)!
		console.print_debug('download garage done')
		osal.cmd_add(
			cmdname: 'garage'
			source:  '${dest.path}'
		)!
	}

	if args.start {
		start(args)!
	}
}
