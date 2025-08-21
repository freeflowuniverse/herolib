module cloudslices

import time

// NodeInfo holds descriptive information about a node, aggregated from devices and other details.
pub struct NodeInfo {
pub mut:
	cpu_brand   string // Brand of the CPU
	cpu_version string // Version of the CPU
	mem         string // Memory description
	hdd         string // HDD description
	ssd         string // SSD description
	url         string // URL for node info
	continent   string // Continent code
	country     string // Country code
}

// NodeTotalSim represents the aggregated data for a node simulation, including hardware specs, pricing, and location.
pub struct NodeTotalSim {
pub mut:
	id               int          // Unique node ID
	cost             f64          // Total cost of the node
	deliverytime     time.Time    // Expected delivery time
	inca_reward      int          // Incentive reward
	reputation       int          // Reputation score (0-100)
	uptime           int          // Uptime percentage (0-100)
	price_simulation f64          // Simulated price for the node
	info             NodeInfo     // Aggregated descriptive info
	capacity         NodeCapacity // Aggregated hardware capacity
}

// total aggregates totals for a single NodeSim (e.g., storage, memory, price) from its slices and devices.
pub fn (n NodeSim) total() !NodeTotalSim {
	if n.computeslices.len == 0 && n.storageslices.len == 0 {
		return error('Node has no slices to aggregate')
	}

	mut total := NodeTotalSim{
		id: n.id
		cost: n.cost
		deliverytime: time.now() // Placeholder; replace with actual logic if needed
		inca_reward: 0 // Placeholder; compute from policy if available
		reputation: 50 // Default; compute from uptime/history
		uptime: n.uptime
		price_simulation: 0.0
		info: NodeInfo{
			// TODO: fix
			// cpu_brand: if n.devices.cpu.len > 0 { n.devices.cpu[0].cpu_brand } else { '' }
			// cpu_version: if n.devices.cpu.len > 0 { n.devices.cpu[0].cpu_version } else { '' }
			mem: '' // Aggregate from devices.memory if needed
			hdd: '' // Aggregate from devices.storage if needed
			ssd: '' // Aggregate from devices.storage if needed
			url: '' // Set from external data if available
			continent: '' // Set from country/external data
			country: n.country
		}
		capacity: NodeCapacity{}
	}

	// Aggregate from compute slices
	for slice in n.computeslices {
		total.capacity.storage_gb += slice.storage_gb
		total.capacity.mem_gb += slice.mem_gb
		total.capacity.mem_gb_gpu += 0 // Add GPU logic if GPUs are in slices
		total.capacity.passmark += slice.passmark
		total.capacity.vcores += slice.vcores
		total.price_simulation += slice.price_cc
	}

	// Aggregate from storage slices (focus on storage/price)
	for slice in n.storageslices {
		total.capacity.storage_gb += 1.0 // Assuming 1GB per storage slice as per model_slices.v
		total.price_simulation += slice.price_cc
	}

	// Aggregate passmark/vcores from devices (e.g., CPUs)
	for cpu in n.devices.cpu {
		total.capacity.passmark += cpu.passmark
		total.capacity.vcores += cpu.cores
	}

	// Additional aggregations (e.g., from GPUs if present)
	for gpu in n.devices.gpu {
		total.capacity.mem_gb_gpu += gpu.memory_gb
		total.capacity.vcores += gpu.cores // If GPUs contribute to vcores
	}

	return total
}
