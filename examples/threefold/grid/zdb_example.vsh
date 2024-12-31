#!/usr/bin/env -S v -n -w -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run


struct ZDBSpecs{
	deployment_name string
	nodeid string
	namespace string
	secret string
}

struct ZDBDeployed{
	nodeid string
	namespace string
	secret string
}


//test zdb is answering
pub fn (vm ZDBDeployed) ping() bool {

}

pub fn (vm ZDBDeployed) redisclient() redisclient... {

}

//only connect to yggdrasil and mycelium
//
fn zdb_deploy(args_ ZDBSpecs) ZDBDeployed{

}