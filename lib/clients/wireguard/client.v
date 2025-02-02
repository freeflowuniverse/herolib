module wireguard

import os

pub struct WGPeer {
pub mut:
	endpoint             string
	allowed_ips          string
	latest_handshake     string
	transfer             string
	persistent_keepalive string
}

pub struct WGInterface {
pub mut:
	name           string
	public_key     string
	listening_port int
}

pub struct WGInfo {
pub mut:
	interface_ WGInterface
	peers      map[string]WGPeer
}

pub struct WGShow {
pub mut:
	configs map[string]WGInfo
}

pub fn (wg WireGuard) show() !WGShow {
	cmd := 'wg show'
	res := os.execute(cmd)
	if res.exit_code != 0 {
		return error('failed to execute show command due to: ${res.output}')
	}

	return wg.parse_show_command_output(res.output)
}

@[params]
pub struct ShowConfigArgs {
pub:
	interface_name string @[required]
}

pub fn (wg WireGuard) show_config(args ShowConfigArgs) !WGInfo {
	configs := wg.show()!.configs
	config := configs[args.interface_name] or {
		return error('key ${args.interface_name} does not exists.')
	}
	return config
}

@[params]
pub struct StartArgs {
pub:
	config_file_path string @[required]
}

pub fn (wg WireGuard) start(args StartArgs) ! {
	if os.exists(args.config_file_path) {
		return error('File ${args.config_file_path} does not exists.')
	}

	cmd := 'sudo wg-quick up ${args.config_file_path}'
	println('cmd: ${cmd}')
	res := os.execute(cmd)
	if res.exit_code != 0 {
		return error('failed to execute start command due to: ${res.output}')
	}
}

@[params]
pub struct DownArgs {
pub:
	config_file_path string @[required]
}

pub fn (wg WireGuard) down(args DownArgs) ! {
	if os.exists(args.config_file_path) {
		return error('File ${args.config_file_path} does not exists.')
	}

	cmd := 'sudo wg-quick down ${args.config_file_path}'
	res := os.execute(cmd)
	if res.exit_code != 0 {
		return error('failed to execute down command due to: ${res.output}')
	}
}

pub fn (wg WireGuard) generate_private_key() !string {
	cmd := 'wg genkey'
	res := os.execute(cmd)
	if res.exit_code != 0 {
		return error('failed to execute genkey command due to: ${res.output}')
	}
	return res.output.trim_space()
}

@[params]
pub struct GetPublicKeyArgs {
pub:
	private_key string @[required]
}

pub fn (wg WireGuard) get_public_key(args GetPublicKeyArgs) !string {
	cmd := 'echo ${args.private_key} | wg pubkey'
	res := os.execute(cmd)
	if res.exit_code != 0 {
		return error('failed to execute pubkey command due to: ${res.output}')
	}
	return res.output.trim_space()
}
