module core

fn test_ipaddr_pub_get() {
	ipaddr := ipaddr_pub_get()!
	assert ipaddr != ''
}

fn test_ping() {
	x := ping(address: '127.0.0.1', count: 1)!
	assert x == .ok
}

fn test_ping_timeout() ! {
	x := ping(address: '192.168.145.154', count: 5, timeout: 1)!
	assert x == .timeout
}

fn test_ping_unknownhost() ! {
	x := ping(address: '12.902.219.1', count: 1, timeout: 1)!
	assert x == .unknownhost
}
