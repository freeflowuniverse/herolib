#!/usr/bin/env -S v -n -w -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.data.resp
import crypto.ed25519

mut b := resp.builder_new()
b.add(resp.r_list_string(['a', 'b']))
b.add(resp.r_int(10))
b.add(resp.r_ok())
// to get some binary
pubkey, privkey := ed25519.generate_key()!

b.add(resp.r_bytestring(privkey))

// b.data now has the info as binary data
// println(b.data)
println(b.data.bytestr())

lr := resp.decode(b.data)!
println(lr)
