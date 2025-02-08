#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

struct NodeQuery {
	location                  string // how to define location
	capacity_available_hdd_gb int
	capacity_available_ssd_gb int
	capacity_available_mem_gb int
	capacity_available_vcpu   int // vcpu core's
	capacity_free_hdd_gb      int
	capacity_free_ssd_gb      int
	capacity_free_mem_gb      int
	capacity_free_vcpu        int // vcpu core's
	uptime_min                int = 70 // 0..99
	bw_min_mb_sec             int = 0  // bandwith in mbit per second, min
}

struct NodeInfo {
	location                  string // how to define location
	capacity_available_hdd_gb int
	capacity_available_ssd_gb int
	capacity_available_mem_gb int
	capacity_available_vcpu   int // vcpu core's
	capacity_free_hdd_gb      int
	capacity_free_ssd_gb      int
	capacity_free_mem_gb      int
	capacity_free_vcpu        int // vcpu core's
	uptime_min                int = 70 // 0..99
	bw_min_mb_sec             int = 0  // bandwith in mbit per second, min
	guid                      string
	status                    string
	last_update               i64 // unix timestamp
}

fn node_find(args NodeQuery) []NodeInfo {
	// Implementation would need to:
	// 1. Query nodes based on the criteria in args
	// 2. Filter nodes that match the requirements
	// 3. Return array of matching NodeInfo
	return []NodeInfo{}
}
