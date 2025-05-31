module zinit

import freeflowuniverse.herolib.schemas.jsonrpc

// Client is an OpenRPC client for Zinit
pub struct Client {
mut:
	rpc_client &jsonrpc.Client
}


@[params]
pub struct ClientParams {
	path   string = '/tmp/zinit.sock' // Path to the Zinit RPC socket
}
// new_client creates a new Zinit RPC client with a custom socket path
pub fn new_client(args_ ClientParams) &Client {
	mut args:=args_
	mut cl := jsonrpc.new_unix_socket_client(args.path)
	return &Client{
		rpc_client: cl
	}
}
