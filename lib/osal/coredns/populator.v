module coredns

import json
import freeflowuniverse.herolib.core.redisclient

// new_dns_record_set creates a new DNSRecordSet
pub fn new_dns_record_set() DNSRecordSet {
    return DNSRecordSet{
        srv: []SRVRecord{}
        txt: []TXTRecord{}
        mx: []MXRecord{}
        a: []ARecord{}
        aaaa: []AAAARecord{}
        ns: []NSRecord{}
    }
}

// add_srv adds an SRV record to the set
pub fn (mut rs DNSRecordSet) add_srv(args SRVRecord) {
    rs.srv << SRVRecord{
        target: args.target
        port: args.port
        priority: args.priority
        weight: args.weight
        ttl: args.ttl
    }
}

// add_txt adds a TXT record to the set
pub fn (mut rs DNSRecordSet) add_txt(args TXTRecord) {
    rs.txt << TXTRecord{
        text: args.text
        ttl: args.ttl
    }
}

// add_mx adds an MX record to the set
pub fn (mut rs DNSRecordSet) add_mx(args MXRecord) {
    rs.mx << MXRecord{
        host: args.host
        preference: args.preference
        ttl: args.ttl
    }
}

// add_a adds an A record to the set
pub fn (mut rs DNSRecordSet) add_a(args ARecord) {
    rs.a << ARecord{
        name: args.name
        ip: args.ip
        ttl: args.ttl
    }
}

// add_aaaa adds an AAAA record to the set
pub fn (mut rs DNSRecordSet) add_aaaa(args AAAARecord) {
    rs.aaaa << AAAARecord{
        name: args.name
        ip: args.ip
        ttl: args.ttl
    }
}

// add_ns adds an NS record to the set
pub fn (mut rs DNSRecordSet) add_ns(args NSRecord) {
    rs.ns << NSRecord{
        host: args.host
        ttl: args.ttl
    }
}

// set_soa sets the SOA record for the set
pub fn (mut rs DNSRecordSet) set_soa(args SOARecord) {
    rs.soa = SOARecord{
        mbox: args.mbox
        ns: args.ns
        refresh: args.refresh
        retry: args.retry
        expire: args.expire
        minttl: args.minttl
        ttl: args.ttl
    }
}

// populate_redis populates Redis with the DNS records
//domain e.g. example.com.  (not sure the . is at end)
pub fn (rs DNSRecordSet) set(domain string) ! {
    mut redis := rs.redis or {redisclient.core_get()!}

    // Store SRV records
    for srv in rs.srv {
        key := '_ssh._tcp.host1'
        value := json.encode({
            'srv': {
                'ttl': srv.ttl
                'target': srv.target
                'port': srv.port
                'priority': srv.priority
                'weight': srv.weight
            }
        })
        redis.hset(domain, key, value)!
    }

    // Store TXT and MX records for wildcard
    if rs.txt.len > 0 || rs.mx.len > 0 {
        mut records := map[string]map[string]json.Any{}
        if rs.txt.len > 0 {
            records['txt'] = {
                'text': rs.txt[0].text
                'ttl': "${rs.txt[0].ttl}"
            }
        }
        if rs.mx.len > 0 {
            records['mx'] = {
                'host': rs.mx[0].host
                'priority': rs.mx[0].preference
                'ttl': rs.mx[0].ttl
            }
        }
        redis.hset(domain, '*', json.encode(records))!
    }

    // Store A records
    for a in rs.a {
        value := json.encode({
            'a': {
                'ip4': a.ip
                'ttl': "${a.ttl}"
            }
        })
        redis.hset(domain, a.name, value)!
    }

    // Store AAAA records
    for aaaa in rs.aaaa {
        value := json.encode({
            'aaaa': {
                'ip6': aaaa.ip
                'ttl': aaaa.ttl
            }
        })
        redis.hset(domain, aaaa.name, value)!
    }

    // Store NS records
    if rs.ns.len > 0 {
        mut ns_records := []map[string]json.Any{}
        for ns in rs.ns {
            ns_records << {
                'host': ns.host
                'ttl': ns.ttl
            }
        }
        value := json.encode({
            'ns': ns_records
        })
        redis.hset(domain, 'subdel', value)!
    }

    // Store SOA and root NS records at @
    if soa := rs.soa {
        mut root_records := map[string]json.Any{}
        root_records['soa'] = {
            'ttl': soa.ttl
            'minttl': soa.minttl
            'mbox': soa.mbox
            'ns': soa.ns
            'refresh': soa.refresh
            'retry': soa.retry
            'expire': soa.expire
        }
        
        if rs.ns.len > 0 {
            mut ns_records := []map[string]json.Any{}
            for ns in rs.ns {
                ns_records << {
                    'host': ns.host
                    'ttl': ns.ttl
                }
            }
            root_records['ns'] = ns_records
        }
        
        redis.hset(domain, '@', json.encode(root_records))!
    }
}

pub fn (mut rs DNSRecordSet) example() ! {
    // Create and populate DNS records
    rs.set_soa(mbox: 'hostmaster.example.net.', ns: 'ns1.example.net.')
    rs.add_srv(target: 'tcp.example.com.', port: 123)
    rs.add_txt(text: 'this is a wildcard')
    rs.add_mx(host: 'host1.example.net.')
    rs.add_a(name: 'host1', ip: '5.5.5.5')
    rs.add_aaaa(name: 'host1', ip: '2001:db8::1')
    rs.add_txt(text: 'this is not a wildcard')
    rs.add_ns(host: 'ns1.subdel.example.net.')
    rs.add_ns(host: 'ns2.subdel.example.net.')
    rs.add_ns(host: 'ns1.example.net.')
    rs.add_ns(host: 'ns2.example.net.')
    
    // Store records in Redis
    rs.set("example.com")!
}