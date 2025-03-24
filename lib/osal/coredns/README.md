# CoreDNS Redis Record Management

This module provides functionality for managing DNS records in Redis for use with CoreDNS. It supports various DNS record types and provides a simple interface for adding and managing DNS records.

```v
import freeflowuniverse.herolib.osal.coredns

// Create a new DNS record set
mut rs := coredns.new_dns_record_set()

// Create and populate DNS records
rs.set_soa(mbox: 'hostmaster.example.net.', ns: 'ns1.example.net.')
rs.add_srv(target: 'tcp.example.com.', port: 123)
rs.add_txt(text: 'this is a wildcard')
rs.add_mx(host: 'host1.example.net.')
rs.add_a(name: 'host1', ip: '5.5.5.5')
rs.add_aaaa(name: 'host1', ip: '2001:db8::1')
rs.add_ns(host: 'ns1.example.net.')
rs.add_ns(host: 'ns2.example.net.')

// Store records in Redis
rs.set('example.com')!
```


## Record Types

The following DNS record types are supported:

### SRV Record
```v
SRVRecord {
    target   string  // Required: Target hostname
    port     int     // Required: Port number
    priority int     // Default: 10
    weight   int     // Default: 100
    ttl      int     // Default: 300
}
```

### TXT Record
```v
TXTRecord {
    text string  // Required: Text content
    ttl  int     // Default: 300
}
```

### MX Record
```v
MXRecord {
    host       string  // Required: Mail server hostname
    preference int     // Default: 10
    ttl        int     // Default: 300
}
```

### A Record
```v
ARecord {
    name string  // Required: Hostname
    ip   string  // Required: IPv4 address
    ttl  int     // Default: 300
}
```

### AAAA Record
```v
AAAARecord {
    name string  // Required: Hostname
    ip   string  // Required: IPv6 address
    ttl  int     // Default: 300
}
```

### NS Record
```v
NSRecord {
    host string  // Required: Nameserver hostname
    ttl  int     // Default: 300
}
```

### SOA Record
```v
SOARecord {
    mbox    string  // Required: Email address of the admin
    ns      string  // Required: Primary nameserver
    refresh int     // Default: 44
    retry   int     // Default: 55
    expire  int     // Default: 66
    minttl  int     // Default: 100
    ttl     int     // Default: 300
}
```
