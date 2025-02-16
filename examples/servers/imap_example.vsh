#!/usr/bin/env -S v -n -w -cg -gc none  -cc tcc -d use_openssl -enable-globals run

import os
import time

import freeflowuniverse.herolib.servers.imap

// Start the IMAP server on port 143
imap.start() or { 
	println("error in imap server")
	eprint(err)
	exit(1)
}