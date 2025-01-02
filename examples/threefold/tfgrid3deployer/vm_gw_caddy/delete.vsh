#!/usr/bin/env -S v -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals -cg run

import freeflowuniverse.herolib.threefold.gridproxy
import freeflowuniverse.herolib.threefold.tfgrid3deployer
import freeflowuniverse.herolib.installers.threefold.griddriver
import os
import time

griddriver.install()!

v := tfgrid3deployer.get()!
println('cred: ${v}')

deployment_name := 'vm_caddy1'
mut deployment := tfgrid3deployer.get_deployment(deployment_name)!
deployment.remove_machine('vm_caddy1')!
deployment.deploy()!
os.rm('${os.home_dir()}/hero/db/0/session_deployer/${deployment_name}')!

deployment_name2 := 'vm_caddy_gw'
mut deployment2 := tfgrid3deployer.get_deployment(deployment_name2)!
deployment2.remove_webname('gwnamecaddy')!
deployment2.deploy()!
os.rm('${os.home_dir()}/hero/db/0/session_deployer/${deployment_name2}')!
