#!/usr/bin/env -S v -n -w -gc none -no-retry-compilation -d use_openssl -enable-globals run

import freeflowuniverse.herolib.clients.wireguard
import time

println('HIIII')

// Create Wireguard client
mut wg := wireguard.get()!
println('Hello')
config_file_path := '~/wg1.conf'

println('Before start')
wg.start(config_file_path: config_file_path)!
println('${config_file_path} is started')

time.sleep(time.second * 2)

info := wg.show()!
println('info: ${info}')

config := wg.show_config(interface_name: 'wg1')!
println('config: ${config}')

private_key := wg.generate_private_key()!
println('private_key: ${private_key}')

public_key := wg.get_public_key(private_key: private_key)!
println('public_key: ${public_key}')

time.sleep(time.second * 2)

wg.down(config_file_path: config_file_path)!
println('${config_file_path} is down')
