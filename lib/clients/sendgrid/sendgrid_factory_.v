
module sendgrid

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.ui.console


__global (
    sendgrid_global map[string]&SendGrid
    sendgrid_default string
)

/////////FACTORY






