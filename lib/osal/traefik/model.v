module traefik

// Base configuration structs for Traefik components

@[params]
struct RouteConfig {
pub mut:
	name        string @[required] // Name of the router
	rule        string @[required] // Routing rule (e.g., "Host(`example.com`)")
	service     string @[required] // Name of the service to forward to
	middlewares []string // List of middleware names to apply
	priority    int = 0 // Route priority
	tls         bool // Enable TLS for this router
}

@[params]
struct ServiceConfig {
pub mut:
	name          string             @[required] // Name of the service
	load_balancer LoadBalancerConfig @[required] // Load balancer configuration
}

@[params]
struct LoadBalancerConfig {
pub mut:
	servers []ServerConfig @[required] // List of backend servers
}

@[params]
struct ServerConfig {
pub mut:
	url string @[required] // URL of the backend server
}

@[params]
struct MiddlewareConfig {
pub mut:
	name     string @[required] // Name of the middleware
	typ      string @[required] // Type of middleware (e.g., "basicAuth", "stripPrefix")
	settings map[string]string // Middleware-specific settings
}

@[params]
struct TLSConfig {
pub mut:
	domain    string @[required] // Domain for the certificate
	cert_file string @[required] // Path to certificate file
	key_file  string @[required] // Path to private key file
}

// TraefikConfig represents a complete Traefik configuration
struct TraefikConfig {
pub mut:
	routers     []RouteConfig
	services    []ServiceConfig
	middlewares []MiddlewareConfig
	tls         []TLSConfig
	redis       ?&redisclient.Redis
}
