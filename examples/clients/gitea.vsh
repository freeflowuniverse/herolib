#!/usr/bin/env -S v -n -w -gc none -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.core
import freeflowuniverse.herolib.clients.gitea_client

// Configure PostgreSQL client
heroscript := "
!!gitea_client.configure
	url: 'https://gitea.example.com'
	user: 'despiegk'
	token: '0597b7c143953bc66b47268bfcdc324340b3f47d'
"

// Process the heroscript configuration
gitea_client.play(heroscript: heroscript)!

// Get the configured client
mut db_client := gitea_client.get()!

