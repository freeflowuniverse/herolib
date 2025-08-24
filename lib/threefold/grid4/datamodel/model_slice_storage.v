module datamodel

// 1GB of storage
@[heap]
pub struct StorageSlice {
pub mut:
	nodeid         u32           // the node in the grid
	id             int           // the id of the slice in the node, are tracked in the node itself
	price_cc       f64           // price per slice (even if the grouped one)
	pricing_policy PricingPolicy // copied from node which is part of nodegroup
	sla_policy     SLAPolicy
}
