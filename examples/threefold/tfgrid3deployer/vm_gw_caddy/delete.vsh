#!/usr/bin/env -S v -gc none  -cc tcc -d use_openssl -enable-globals -cg run

import freeflowuniverse.herolib.threefold.grid3.gridproxy
import freeflowuniverse.herolib.threefold.grid3.deployer
import freeflowuniverse.herolib.installers.threefold.griddriver
import os
import time

griddriver.install()!

v := tfgrid3deployer.get()!
println('cred: ${v}')

deployment_name := 'vm_caddy1'
tfgrid3deployer.delete_deployment(deployment_name)!
