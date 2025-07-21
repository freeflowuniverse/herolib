module prometheus

import freeflowuniverse.herolib.osal.core as osal
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.core.httpconnection
import freeflowuniverse.herolib.osal.core as osal.startupmanager
import os
import time

// @[params]
// pub struct InstallArgs {
// pub mut:
// 	// homedir    string
// 	// configpath string
// 	// username   string = "admin"
// 	// password   string @[secret]
// 	// secret     string @[secret]
// 	// title      string = 'My Hero DAG'
// 	reset     bool
// 	start     bool = true
// 	stop      bool
// 	restart   bool
// 	uninstall bool
// 	// host        string = 'localhost' // server host (default is localhost)
// 	// port       int = 8888
// }

// pub fn install_(args_ InstallArgs) ! {
// 	install_prometheus(args_)!
// 	install_alertmanager(args_)!
// 	install_node_exporter(args_)!
// 	install_blackbox_exporter(args_)!
// 	install_prom2json(args_)!
// }
