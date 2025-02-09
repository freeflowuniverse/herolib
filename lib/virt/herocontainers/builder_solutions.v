module herocontainers

import freeflowuniverse.herolib.osal
// import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.installers.lang.herolib
import freeflowuniverse.herolib.core.pathlib
import os
import json

// copies the hero from host into guest
pub fn (mut self Builder) install_zinit() ! {
	self.run(
		cmd: '
    	wget https://github.com/threefoldtech/zinit/releases/download/v0.2.5/zinit -O /sbin/zinit
    	chmod +x /sbin/zinit
		touch /etc/environment
		mkdir -p /etc/zinit/
		'

	// 	# Define the command to check if zinit is running
	// 	CHECK_CMD="pgrep -x zinit"
	// 	START_CMD="/sbin/zinit init --container"

	// 	# Check if zinit is already running
	// 	if ! \$CHECK_CMD > /dev/null; then
	// 		echo "Zinit is not running. Starting it in a screen session..."
			
	// 		# Check if the screen session already exists
	// 		if screen -list | grep -q zinitscreen; then
	// 			#echo "Screen session zinitscreen already exists. Attaching..."
	// 			#screen -r zinitscreen
	// 		else
	// 			echo "Creating new screen session and starting zinit..."
	// 			screen -dmS zinitscreen bash -c "/sbin/zinit init --container"
	// 		fi
	// 	else
	// 		echo "Zinit is already running."
	// 	fi

	// 	zinit list

	// '
	)!

	self.set_entrypoint('/sbin/zinit init --container')!

}
