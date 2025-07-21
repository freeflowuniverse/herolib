module builder

import freeflowuniverse.herolib.osal.core.screen
import freeflowuniverse.herolib.data.ipaddress
import freeflowuniverse.herolib.ui.console

@[params]
pub struct ForwardArgsToLocal {
pub mut:
	name        string @[required]
	address     string @[required]
	remote_port int    @[required]
	local_port  int
	user        string = 'root'
}

// forward a remote port on ssh host to a local port
pub fn portforward_to_local(args_ ForwardArgsToLocal) ! {
	mut args := args_
	if args.local_port == 0 {
		args.local_port = args.remote_port
	}
	mut addr := ipaddress.new(args.address)!
	mut cmd := 'ssh -L ${args.local_port}:localhost:${args.remote_port} ${args.user}@${args.address}'
	if addr.cat == .ipv6 {
		cmd = 'ssh -L ${args.local_port}:localhost:${args.remote_port} ${args.user}@${args.address.trim('[]')}'
	}
	console.print_debug(cmd)
	mut scr := screen.new(reset: false)!
	_ = scr.add(name: args.name, cmd: cmd)!
}
