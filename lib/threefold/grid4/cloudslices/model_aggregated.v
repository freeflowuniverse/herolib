module cloudslices

import time

// NodeTotal represents the aggregated data for a node, including hardware specifications, pricing, and location details.
pub struct NodeTotal {
    pub mut:
        id           int    // Unique identifier for the node
        cost         f64    // Total cost of the node
        deliverytime time.Time // Expected delivery time
        inca_reward  int    // Incentive reward for the node
        reputation   int    // Reputation score of the node
        uptime       int    // Uptime percentage
        price_simulation f64 // Simulated price for the node
        info         NodeInfo // Descriptive information about the node
        capacity     NodeCapacity // Hardware capacity details
}

// node_total calculates the total values for storage, memory, price simulation, passmark, and vcores by summing up the contributions from different types of boxes.
pub fn (n Node) node_total() NodeTotal {
    mut total := NodeTotal{
        id:           n.id
        cost:         n.cost
        deliverytime: n.deliverytime
        inca_reward:  n.inca_reward
        reputation:   n.reputation
        uptime:       n.uptime
        info: NodeInfo{
            name:        n.name
            description: n.description
            cpu_brand:   n.cpu_brand
            cpu_version: n.cpu_version
            image:       n.image
            mem:         n.mem
            hdd:         n.hdd
            ssd:         n.ssd
            url:         n.url
            continent:   n.continent
            country:     n.country
        },
        capacity:     NodeCapacity{}
    }
    for box in n.cloudbox {
        total.capacity.storage_gb += box.storage_gb * f64(box.amount)
        total.capacity.mem_gb += box.mem_gb * f64(box.amount)
        total.price_simulation += box.price_simulation * f64(box.amount)
        total.capacity.passmark += box.passmark * box.amount
        total.capacity.vcores += box.vcores * box.amount
    }

    for box in n.aibox {
        total.capacity.storage_gb += box.storage_gb * f64(box.amount)
        total.capacity.mem_gb += box.mem_gb * f64(box.amount)
        total.capacity.mem_gb_gpu += box.mem_gb_gpu * f64(box.amount)
        total.price_simulation += box.price_simulation * f64(box.amount)
        total.capacity.passmark += box.passmark * box.amount
        total.capacity.vcores += box.vcores * box.amount
    }

    for box in n.storagebox {
        total.price_simulation += box.price_simulation * f64(box.amount)
    }

    return total
}
