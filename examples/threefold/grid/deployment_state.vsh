#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

struct DeploymentStateDB {
	secret string // to encrypt symmetric
	data   map[string]string
}

struct DeploymentState {
	name string
	vms  []VMDeployed
	zdbs []ZDBDeployed
}

pub fn (mut db DeploymentStateDB) set(deployment_name string, key string, val string) ! {
	// store e.g. \n separated list of all keys per deployment_name
	// encrypt
	db.data['${deployment_name}_${key}'] = val
}

pub fn (db DeploymentStateDB) get(deployment_name string, key string) !string {
	return db.data['${deployment_name}_${key}'] or { return error('key not found') }
}

pub fn (mut db DeploymentStateDB) delete(deployment_name string, key string) ! {
	db.data.delete('${deployment_name}_${key}')
}

pub fn (db DeploymentStateDB) keys(deployment_name string) ![]string {
	mut keys := []string{}
	for k, _ in db.data {
		if k.starts_with('${deployment_name}_') {
			keys << k.all_after('${deployment_name}_')
		}
	}
	return keys
}

pub fn (db DeploymentStateDB) load(deployment_name string) !DeploymentState {
	mut state := DeploymentState{
		name: deployment_name
	}
	// Implementation would need to load VMs and ZDBs based on stored data
	return state
}
