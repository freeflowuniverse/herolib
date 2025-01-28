#!/usr/bin/env -S v -n -w -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run

struct WebGWArgs {
	deployment_name string
	//...
}

// connect domain name, or exising to it
fn webgateway_rule_deploy(args_ WebGWArgs) []VMDeployed {
}
