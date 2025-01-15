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
tfgrid3deployer.delete_deployment(deployment_name)!
