module startupmanager

import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.osal.screen
import freeflowuniverse.herolib.osal.systemd
import freeflowuniverse.herolib.osal.zinit

// // TODO: check if using this interface would simplify things
// pub interface StartupManagerI {
// 	new(args startupmanager.ZProcessNewArgs)!
// 	start(name string)!
// 	stop(name string)!
// 	restart(name string)!
// 	delete(name string)!
// 	status(name string) !ProcessStatus
// 	running(name string) !bool
// 	output(name string) !string
// 	exists(name string) !bool
// 	list_services() ![]string
// }

pub struct StartupManager {
pub mut:
	cat StartupManagerType
}

// @[params]
// pub struct StartupManagerArgs {
// pub mut:
// 	cat StartupManagerType
// }

pub fn get(cat StartupManagerType) !StartupManager {
	console.print_debug('startupmanager get ${cat}')
	mut sm := StartupManager{
		cat: cat
	}
	if sm.cat == .auto {
		if zinit.check() {
			sm.cat = .zinit
		} else {
			sm.cat = .screen
		}
	}	
	if sm.cat == .unknown {
		print_backtrace()
		return error("can't determine startup manager type, need to be a known one.")
	}
	return sm
}

// launch a new process
//```
// name        string            @[required]
// cmd         string            @[required]
// cmd_stop    string
// cmd_test    string 		//command line to test service is running
// status  ZProcessStatus
// pid     int
// after   []string 	//list of service we depend on
// env     map[string]string
// oneshot bool
// start 	  bool = true
// restart     bool = true // whether the process should be restarted on failure
// description string //not used in zinit
//```
pub fn (mut sm StartupManager) new(args ZProcessNewArgs) ! {
	console.print_debug("startupmanager start:${args.name} cmd:'${args.cmd}' restart:${args.restart}")
	mut mycat := sm.cat
	match mycat {
		.screen {
			mut scr := screen.new(reset: false)!
			console.print_debug('screen startup manager ${args.name} cmd:${args.cmd}')
			_ = scr.add(name: args.name, cmd: args.cmd, reset: args.restart)!
		}
		.systemd {
			// console.print_debug('systemd start  ${args.name}')
			mut systemdfactory := systemd.new()!
			systemdfactory.new(
				cmd:     args.cmd
				name:    args.name
				start:   args.start
				restart: args.restart
				env:     args.env
			)!
		}
		.zinit {
			console.print_debug('zinit start ${args.name}')
			mut zinitfactory := zinit.new()!
			zinitfactory.new(
				name:     args.name
				cmd:      args.cmd
				cmd_stop: args.cmd_stop
				cmd_test: args.cmd_test
				workdir:  args.workdir
				after:    args.after
				env:      args.env
				oneshot:  args.oneshot
				start:    args.start
				restart:  args.restart
			)!
		}
		else {
			panic('to implement, startup manager only support screen & systemd for now: ${mycat}')
		}
	}
}

pub fn (mut sm StartupManager) start(name string) ! {
	match sm.cat {
		.screen {
			return
		}
		.systemd {
			console.print_debug('systemd process start ${name}')
			mut systemdfactory := systemd.new()!
			if systemdfactory.exists(name) {
				// console.print_header("*************")
				mut systemdprocess := systemdfactory.get(name)!
				systemdprocess.start()!
			} else {
				return error('process in systemd with name ${name} not found')
			}
		}
		.zinit {
			console.print_debug('zinit process start ${name}')
			mut zinitfactory := zinit.new()!
			zinitfactory.start(name)!
		}
		else {
			panic('to implement, startup manager only support screen for now')
		}
	}
}

pub fn (mut sm StartupManager) stop(name string) ! {
	match sm.cat {
		.screen {
			mut screen_factory := screen.new(reset: false)!
			mut scr := screen_factory.get(name) or { return }
			scr.cmd_send('^C')!
			screen_factory.kill(name)!
		}
		.systemd {
			console.print_debug('systemd stop ${name}')
			mut systemdfactory := systemd.new()!
			if systemdfactory.exists(name) {
				mut systemdprocess := systemdfactory.get(name)!
				systemdprocess.stop()!
			}
		}
		.zinit {
			console.print_debug('zinit stop ${name}')
			mut zinitfactory := zinit.new()!
			zinitfactory.load()!
			if zinitfactory.exists(name) {
				zinitfactory.stop(name)!
			}
		}
		else {
			panic('to implement, startup manager only support screen for now')
		}
	}
}

// kill the process by name
pub fn (mut sm StartupManager) restart(name string) ! {
	match sm.cat {
		.screen {
			panic('implement')
		}
		.systemd {
			console.print_debug('systemd restart ${name}')
			mut systemdfactory := systemd.new()!
			mut systemdprocess := systemdfactory.get(name)!
			systemdprocess.restart()!
		}
		.zinit {
			console.print_debug('zinit restart ${name}')
			mut zinitfactory := zinit.new()!
			zinitfactory.stop(name)!
			zinitfactory.start(name)!
		}
		else {
			panic('to implement, startup manager only support screen for now')
		}
	}
}

// remove from the startup manager
pub fn (mut sm StartupManager) delete(name string) ! {
	match sm.cat {
		.screen {
			mut screen_factory := screen.new(reset: false)!
			mut scr := screen_factory.get(name) or { return }
			scr.cmd_send('^C')!
			screen_factory.kill(name)!
		}
		.systemd {
			mut systemdfactory := systemd.new()!
			mut systemdprocess := systemdfactory.get(name)!
			systemdprocess.delete()!
		}
		.zinit {
			mut zinitfactory := zinit.new()!
			zinitfactory.load()!
			if zinitfactory.exists(name) {
				zinitfactory.delete(name)!
			}
		}
		else {
			panic('to implement, startup manager only support screen & systemd for now  ${sm.cat}')
		}
	}
}

pub enum ProcessStatus {
	unknown
	active
	inactive
	failed
	activating
	deactivating
}

// remove from the startup manager
pub fn (mut sm StartupManager) status(name string) !ProcessStatus {
	match sm.cat {
		.screen {
			mut screen_factory := screen.new(reset: false)!
			mut scr := screen_factory.get(name) or {
				return error('process with name ${name} not found')
			}
			match scr.status()! {
				.active { return .active }
				.inactive { return .inactive }
				.unknown { return .unknown }
			}
		}
		.systemd {
			mut systemdfactory := systemd.new()!
			mut systemdprocess := systemdfactory.get(name) or { return .unknown }
			systemd_status := systemdprocess.status() or {
				return error('Failed to get status of process ${name}\n${err}')
			}
			s := ProcessStatus.from(systemd_status.str())!
			return s
		}
		.zinit {
			mut zinitfactory := zinit.new()!
			mut p := zinitfactory.get(name) or { return .unknown }
			// unknown
			// init
			// ok
			// killed
			// error
			// blocked
			// spawned			
			match mut p.status()! {
				.init { return .activating }
				.ok { return .active }
				.error { return .failed }
				.blocked { return .inactive }
				.killed { return .inactive }
				.spawned { return .activating }
				.unknown { return .unknown }
			}
		}
		else {
			panic('to implement, startup manager only support screen & systemd for now  ${sm.cat}')
		}
	}
}

pub fn (mut sm StartupManager) running(name string) !bool {
	if !sm.exists(name)! {
		return false
	}
	mut s := sm.status(name)!
	return s == .active
}

// remove from the startup manager
pub fn (mut sm StartupManager) output(name string) !string {
	match sm.cat {
		.screen {
			panic('implement')
		}
		.systemd {
			return systemd.journalctl(service: name)!
		}
		else {
			panic('to implement, startup manager only support screen & systemd for now  ${sm.cat}')
		}
	}
}

pub fn (mut sm StartupManager) exists(name string) !bool {

	if sm.cat == .unknown {
		if zinit.check() {
			sm.cat = .zinit
		} else {
			sm.cat = .screen
		}
	}
	match sm.cat {
		.screen {
			mut scr := screen.new(reset: false) or { panic("can't get screen") }
			return scr.exists(name)
		}
		.systemd {
			// console.print_debug("exists sm systemd ${name}")
			mut systemdfactory := systemd.new()!
			return systemdfactory.exists(name)
		}
		.zinit {
			// console.print_debug("exists sm zinit check ${name}")
			mut zinitfactory := zinit.new()!
			zinitfactory.load()!
			return zinitfactory.exists(name)
		}
		else {
			panic('to implement. startup manager only support screen & systemd for now  ${sm.cat}')
		}
	}
}

// list all services as known to the startup manager
pub fn (mut sm StartupManager) list() ![]string {
	match sm.cat {
		.screen {
			// mut scr := screen.new(reset: false) or { panic("can't get screen") }
			panic('implement')
		}
		.systemd {
			mut systemdfactory := systemd.new()!
			return systemdfactory.names()
		}
		.zinit {
			mut zinitfactory := zinit.new()!
			return zinitfactory.names()
		}
		else {
			panic('to implement. startup manager only support screen & systemd for now:  ${sm.cat}')
		}
	}
}
