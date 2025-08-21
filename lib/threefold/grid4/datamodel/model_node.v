module cloudslices

@[heap]
pub struct Node {
pub mut:
	id           int
	nodegroupid  int
	uptime       int // 0..100
	computeslices     []ComputeSlice
	storageslices     []StorageSlice
	devices          DeviceInfo
	country          string // 2 letter code as specified in lib/data/countries/data/countryInfo.txt, use that library for validation
	capacity        NodeCapacity // Hardware capacity details
	provisiontime   u32 //lets keep it simple and compatible
}


pub struct DeviceInfo {
pub mut:
	vendor          string
	storage   []StorageDevice
	memory     []MemoryDevice
	cpu     []CPUDevice
	gpu     []GPUDevice
	network []NetworkDevice
}
pub struct StorageDevice {
pub mut:
	id string //can be used in node
	size_gb f64 // Size of the storage device in gigabytes
	description string // Description of the storage device
}

pub struct MemoryDevice {
pub mut:
	id string //can be used in node
	size_gb f64 // Size of the memory device in gigabytes
	description string // Description of the memory device
}

pub struct CPUDevice {
pub mut:
	id string //can be used in node
	cores int // Number of CPU cores
	passmark int
	description string // Description of the CPU
	cpu_brand   string // Brand of the CPU
	cpu_version string // Version of the CPU
}

pub struct GPUDevice {
pub mut:
	id string //can be used in node
	cores int // Number of GPU cores
	memory_gb f64 // Size of the GPU memory in gigabytes
	description string // Description of the GPU
	gpu_brand        string
	gpu_version      string	

}

pub struct NetworkDevice {
pub mut:
	id string //can be used in node
	speed_mbps int // Network speed in Mbps
	description string // Description of the network device
}

// NodeCapacity represents the hardware capacity details of a node.
pub struct NodeCapacity {
pub mut:
	storage_gb f64 // Total storage in gigabytes
	mem_gb     f64 // Total memory in gigabytes
	mem_gb_gpu f64 // Total GPU memory in gigabytes
	passmark   int // Passmark score for the node
	vcores     int // Total virtual cores
}

pub struct NodeGrant {
pub mut:
	grant_month_usd   string
	grant_month_inca  string
	grant_max_nrnodes int
}

fn (mut n Node) check() ! {
	//todo
}
