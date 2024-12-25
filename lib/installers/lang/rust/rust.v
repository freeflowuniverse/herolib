module rust

import os
import freeflowuniverse.herolib.osal
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.installers.base

@[params]
pub struct InstallArgs {
pub mut:
	reset bool
}

pub fn install(args_ InstallArgs) ! {
	mut args := args_
	version := '1.78.0'

	res := os.execute('rustc -V')
	if res.exit_code == 0 {
		r := res.output.split_into_lines()
			.filter(it.contains('rustc'))

		if r.len != 1 {
			return error("couldn't parse rust version, expected 'rustc 1.' on 1 row.\n${res.output}")
		}
		mut vstring := r[0] or { panic('bug') }
		vstring = vstring.all_after_first(' ').all_before('(').trim_space()
		if texttools.version(version) > texttools.version(vstring) {
			args.reset = true
		}
	} else {
		args.reset = true
	}

	if args.reset == false {
		return
	}

	base.install()!

	pl := osal.platform()
	console.print_header('start install rust')

	if pl == .ubuntu {
		osal.package_install('build-essential,openssl,pkg-config,libssl-dev,gcc')!
	}
	if pl == .arch {
		osal.package_install('rust, cargo, pkg-config, openssl')!
		return
	} else {
		osal.execute_stdout("curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y")!
	}

	osal.profile_path_add_remove(paths2add: '${os.home_dir()}/.cargo/bin')!

	return
}
