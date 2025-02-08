module wireguard

fn (wg WireGuard) parse_show_command_output(res string) !WGShow {
	mut configs := map[string]WGInfo{}
	mut lines := res.split('\n')
	mut current_interface := ''
	mut current_peers := map[string]WGPeer{}
	mut iface := WGInterface{}
	mut peer_key := ''

	for line in lines {
		mut parts := line.trim_space().split(': ')
		if parts.len < 2 {
			continue
		}

		key := parts[0]
		value := parts[1]

		if key.starts_with('interface') {
			if current_interface != '' {
				configs[current_interface] = WGInfo{
					interface_: iface
					peers:      current_peers.clone()
				}
				current_peers.clear()
			}

			current_interface = value
			iface = WGInterface{
				name:           current_interface
				public_key:     ''
				listening_port: 0
			}
		} else if key == 'public key' {
			iface.public_key = value
		} else if key == 'listening port' {
			iface.listening_port = value.int()
		} else if key.starts_with('peer') {
			peer_key = value
			mut peer := WGPeer{
				endpoint:             ''
				allowed_ips:          ''
				latest_handshake:     ''
				transfer:             ''
				persistent_keepalive: ''
			}
			current_peers[peer_key] = peer
		} else if key == 'endpoint' {
			current_peers[peer_key].endpoint = value
		} else if key == 'allowed ips' {
			current_peers[peer_key].allowed_ips = value
		} else if key == 'latest handshake' {
			current_peers[peer_key].latest_handshake = value
		} else if key == 'transfer' {
			current_peers[peer_key].transfer = value
		} else if key == 'persistent keepalive' {
			current_peers[peer_key].persistent_keepalive = value
		}
	}

	if current_interface != '' {
		configs[current_interface] = WGInfo{
			interface_: iface
			peers:      current_peers.clone()
		}
	}

	return WGShow{
		configs: configs
	}
}
