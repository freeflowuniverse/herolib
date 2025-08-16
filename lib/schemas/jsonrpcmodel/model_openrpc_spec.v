module jsonrpcmodel

// OpenRPCSpec represents the OpenRPC specification structure
pub struct OpenRPCSpec {
pub mut:
	openrpc string          @[json: 'openrpc'] // OpenRPC version
	info    OpenRPCInfo     @[json: 'info']    // API information
	methods []OpenRPCMethod @[json: 'methods'] // Available methods
	servers []OpenRPCServer @[json: 'servers'] // Server information
}

// OpenRPCInfo represents API information
pub struct OpenRPCInfo {
pub mut:
	version     string         @[json: 'version']     // API version
	title       string         @[json: 'title']       // API title
	description string         @[json: 'description'] // API description
	license     OpenRPCLicense @[json: 'license']     // License information
}

// OpenRPCLicense represents license information
pub struct OpenRPCLicense {
pub mut:
	name string @[json: 'name'] // License name
}

// OpenRPCMethod represents an RPC method
pub struct OpenRPCMethod {
pub mut:
	name        string @[json: 'name']        // Method name
	description string @[json: 'description'] // Method description
	// Note: params and result are dynamic and would need more complex handling
}

// OpenRPCServer represents server information
pub struct OpenRPCServer {
pub mut:
	name string @[json: 'name'] // Server name
	url  string @[json: 'url']  // Server URL
}
