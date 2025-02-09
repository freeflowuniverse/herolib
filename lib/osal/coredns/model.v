// Input parameter structs for each record type
@[params]
struct SRVRecord {
pub mut:
	target   string @[required]
	port     int    @[required]
	priority int = 10
	weight   int = 100
	ttl      int = 300
}

@[params]
struct TXTRecord {
pub mut:
	text string @[required]
	ttl  int = 300
}

@[params]
struct MXRecord {
pub mut:
	host       string @[required]
	preference int = 10
	ttl        int = 300
}

@[params]
struct ARecord {
pub mut:
	name string @[required]
	ip   string @[required]
	ttl  int = 300
}

@[params]
struct AAAARecord {
pub mut:
	name string @[required]
	ip   string @[required]
	ttl  int = 300
}

@[params]
struct NSRecord {
pub mut:
	host string @[required]
	ttl  int = 300
}

@[params]
struct SOARecord {
pub mut:
	mbox    string @[required]
	ns      string @[required]
	refresh int = 44
	retry   int = 55
	expire  int = 66
	minttl  int = 100
	ttl     int = 300
}

// DNSRecordSet represents a set of DNS records
struct DNSRecordSet {
pub mut:
	srv   []SRVRecord
	txt   []TXTRecord
	mx    []MXRecord
	a     []ARecord
	aaaa  []AAAARecord
	ns    []NSRecord
	soa   ?SOARecord
	redis ?&redisclient.Redis
}
