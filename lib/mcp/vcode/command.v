module vcode

import cli

const command := cli.Command{
	sort_flags:  true
	name:        'vcode'
	execute:     cmd_vcode
	description: 'will list existing mdbooks'
}

fn cmd_vcode(cmd cli.Command) ! {
	mut server := new_mcp_server(&VCode{})!
	server.start()!
}
