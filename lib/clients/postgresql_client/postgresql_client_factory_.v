
module postgresql_client

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.ui.console


__global (
    postgresql_client_global map[string]&PostgresClient
    postgresql_client_default string
)

/////////FACTORY






