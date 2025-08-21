module datamodel

//typically 1GB of memory, but can be adjusted based based on size of machine
pub struct ComputeSlice {
pub mut:
	nodeid u32 //the node in the grid, there is an object describing the node
	id int //the id of the slice in the node 
	mem_gb           f64
	storage_gb       f64
	passmark         int
	vcores           int
	cpu_oversubscription int
	storage_oversubscription int	
	price_range      []f64 = [0.0, 0.0]
	gpus			 u8 //nr of GPU's see node to know what GPU's are
	price_cc         f64 //price per slice (even if the grouped one)
	pricing_policy   PricingPolicy
	sla_policy       SLAPolicy

}

//1GB of storage
pub struct StorageSlice {
pub mut:
	nodeid u32 //the node in the grid
	id int //the id of the slice in the node, are tracked in the node itself
	price_cc         f64 //price per slice (even if the grouped one)
	pricing_policy   PricingPolicy
	sla_policy       SLAPolicy
}


