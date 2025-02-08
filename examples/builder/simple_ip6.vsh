#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.builder
import freeflowuniverse.herolib.core.pathlib
import os

mut b := builder.new()!
mut n := b.node_new(ipaddr: 'root@302:1d81:cef8:3049:ad01:796d:a5da:9c6')!

r := n.exec(cmd: 'ls /')!
println(r)

// n.upload(source: myexamplepath, dest: '/tmp/myexamplepath2')!
// n.download(source: '/tmp/myexamplepath2', dest: '/tmp/myexamplepath2', delete: true)!
