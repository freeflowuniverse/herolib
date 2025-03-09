module cloudslices

import time

pub struct Node {
pub mut:
	id           int
	cost         f64
	deliverytime time.Time
	inca_reward  int
	reputation   int
	uptime       int // 0..100
	cloudbox     []CloudBox
	aibox        []AIBox
	storagebox   []StorageBox
	vendor       string
	grant        NodeGrant
	info         NodeInfo // Descriptive information about the node
	capacity     NodeCapacity // Hardware capacity details	
}


// NodeInfo represents the descriptive information about a node.
pub struct NodeInfo {
    pub mut:
        cpu_brand   string // Brand of the CPU
        cpu_version string // Version of the CPU
        mem         string // Memory specification
        hdd         string // HDD specification
        ssd         string // SSD specification
        url         string // URL for more information
        continent   string // Continent where the node is located
        country     string // Country where the node is located
}

// NodeCapacity represents the hardware capacity details of a node.
pub struct NodeCapacity {
    pub mut:
        storage_gb f64 // Total storage in gigabytes
        mem_gb     f64 // Total memory in gigabytes
        mem_gb_gpu f64 // Total GPU memory in gigabytes
        passmark   int  // Passmark score for the node
        vcores     int  // Total virtual cores
}


pub struct NodeGrant {
pub mut:
	grant_month_usd   string
	grant_month_inca  string
	grant_max_nrnodes int
}


fn (mut n Node) validate_percentage(v int) ! {
	if v < 0 || v > 100 {
		return error('Value must be between 0 and 100')
	}
}

pub fn preprocess_value(v string) string {
	// Implement the preprocessing logic here
	return v
}

pub fn (mut n Node) preprocess_location(v string) ! {
	n.info.continent = preprocess_value(v)
	n.info.country = preprocess_value(v)
}

// pub fn (mut n Node) parse_deliverytime(v string) ! {
//     n.deliverytime = time.parse(v, 'YYYY-MM-DD')!
// }
