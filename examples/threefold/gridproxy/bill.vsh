#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.threefold.gridproxy
import freeflowuniverse.herolib.ui.console

contract_id := u64(119450)
mut gp_client := gridproxy.new(net: .dev, cache: false)!
bills := gp_client.get_contract_hourly_bill(contract_id)!

console.print_debug('${bills}')
