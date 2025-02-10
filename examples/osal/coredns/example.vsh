#!/usr/bin/env -S v -n -w -cg -d use_openssl -enable-globals run

import freeflowuniverse.herolib.installers.infra.coredns as coredns_installer
import freeflowuniverse.herolib.osal.coredns
import freeflowuniverse.herolib.core.playbook

// coredns_installer.delete()!
mut installer := coredns_installer.get()!
// coredns_installer.fix()!
installer.start()!

// TODO: create heroscript and run it to add dns records
mut script := '
!!dns.a_record
    name: "host1"
    ip: "1.1.1.1"

!!dns.aaaa_record
    name: "host2"
    ip: "2001:db8::1"
    ttl: 300

!!dns.mx_record
    host: "mail.heroexample.com"
    preference: 10
    ttl: 300

!!dns.txt_record
    text: "v=spf1 mx ~all"
    ttl: 300

!!dns.srv_record
    target: "sip.heroexample.com"
    port: 5060
    priority: 10
    weight: 100
    ttl: 300

!!dns.ns_record
    host: "ns1.heroexample.com"
    ttl: 300
    '

mut plbook := playbook.new(text: script)!
rec := coredns.play_dns(mut plbook)!
rec.set('heroexample.com')!
