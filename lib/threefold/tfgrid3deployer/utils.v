module tfgrid3deployer

import freeflowuniverse.herolib.threefold.gridproxy
import freeflowuniverse.herolib.threefold.grid
import freeflowuniverse.herolib.threefold.grid.models as grid_models
import freeflowuniverse.herolib.threefold.gridproxy.model as gridproxy_models
import rand
import freeflowuniverse.herolib.ui.console

// Resolves the correct grid network based on the `cn.network` value.
//
// This utility function converts the custom network type of GridContracts
// to the appropriate value in `gridproxy.TFGridNet`.
//
// Returns:
//   - A `gridproxy.TFGridNet` value corresponding to the grid network.
fn resolve_network() !gridproxy.TFGridNet {
	mut cfg := get()!
	return match cfg.network {
		.dev { gridproxy.TFGridNet.dev }
		.test { gridproxy.TFGridNet.test }
		.main { gridproxy.TFGridNet.main }
		.qa { gridproxy.TFGridNet.qa }
	}
}

/*
 * This should be the node's subnet and the wireguard routing ip that should start with 100.64 then the 2nd and 3rd part of the node's subnet
*/
fn wireguard_routing_ip(ip string) string {
	parts := ip.split('.')
	return '100.64.${parts[1]}.${parts[2]}/32'
}

/*
 * Just generate a hex key for the mycelium network
*/
fn get_mycelium() grid_models.Mycelium {
	return grid_models.Mycelium{
		hex_key: rand.string(32).bytes().hex()
		peers:   []
	}
}

@[params]
pub struct FilterNodesArgs {
	gridproxy_models.NodeFilter
pub:
	on_hetzner bool
}

pub fn filter_nodes(args FilterNodesArgs) ![]gridproxy_models.Node {
	// Resolve the network configuration
	net := resolve_network()!

	// Create grid proxy client and retrieve the matching nodes
	mut gp_client := gridproxy.new(net: net, cache: true)!

	mut filter := args.NodeFilter
	if args.on_hetzner {
		filter.features << ['zmachine-light']
	}

	nodes := gp_client.get_nodes(filter)!
	return nodes
}

// fn get_hetzner_node_ids(nodes []gridproxy_models.Node) ![]u64 {
// 	// get farm ids that are know to be hetzner's
// 	// if we need to iterate over all nodes, maybe we should use multi-threading
// 	panic('Not Implemented')
// 	return []
// }

fn convert_to_gigabytes(bytes u64) u64 {
	return bytes * 1024 * 1024 * 1024
}

fn pick_node(mut deployer grid.Deployer, nodes []gridproxy_models.Node) !gridproxy_models.Node {
	mut node := ?gridproxy_models.Node(none)
	mut checked := []bool{len: nodes.len}
	mut checked_cnt := 0
	for checked_cnt < nodes.len {
		idx := int(rand.u32() % u32(nodes.len))
		if checked[idx] {
			continue
		}

		checked[idx] = true
		checked_cnt += 1
		if ping_node(mut deployer, u32(nodes[idx].twin_id)) {
			node = nodes[idx]
			break
		}
	}

	if v := node {
		return v
	} else {
		return error('No node is reachable.')
	}
}

fn ping_node(mut deployer grid.Deployer, twin_id u32) bool {
	if _ := deployer.client.get_zos_version(twin_id) {
		return true
	} else {
		console.print_stderr('Failed to ping node with twin: ${twin_id}')
		return false
	}
}
