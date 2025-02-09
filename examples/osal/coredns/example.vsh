#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.installers.infra.coredns as coredns_installer
import freeflowuniverse.herolib.osal.coredns
import freeflowuniverse.herolib.core.playbook

// coredns_installer.delete()!
mut installer := coredns_installer.get()!
// coredns_installer.fix()!
installer.start()!

// TODO: create heroscript and run it to add dns records
mut script := '
dns.a_record
	name: "a_rec1"
	ip: "1.1.1.1"
'

mut plbook := playbook.new(text: script)!
coredns.play_dns(mut plbook)!
