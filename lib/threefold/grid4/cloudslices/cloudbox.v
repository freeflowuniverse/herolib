module cloudslices

import time

pub struct CloudBox {
pub mut:
	amount           int
	description      string
	storage_gb       f64
	passmark         int
	vcores           int
	mem_gb           f64
	price_range      []f64 = [0.0, 0.0]
	price_simulation f64
	ssd_nr           int
}

pub struct AIBox {
pub mut:
	amount           int
	gpu_brand        string
	gpu_version      string
	description      string
	storage_gb       f64
	passmark         int
	vcores           int
	mem_gb           f64
	mem_gb_gpu       f64
	price_range      []f64 = [0.0, 0.0]
	price_simulation f64
	hdd_nr           int
	ssd_nr           int
}

pub struct StorageBox {
pub mut:
	amount           int
	description      string
	price_range      []f64 = [0.0, 0.0]
	price_simulation f64
}
