module stellar

import freeflowuniverse.herolib.threefold.web3gw.stellar as stellar_client { StellarClient }
import freeflowuniverse.herolib.core.playbook { Action }
import freeflowuniverse.herolib.data.rpcwebsocket { RpcWsClient }
import log { Logger }

pub struct StellarHandler {
pub mut:
	client StellarClient
	logger Logger
}

pub fn new(mut rpc_client RpcWsClient, logger Logger, mut client StellarClient) StellarHandler {
	return StellarHandler{
		client: client
		logger: logger
	}
}

pub fn (mut h StellarHandler) handle_action(action Action) ! {
	match action.actor {
		'account' {
			h.account(action)!
		}
		else {
			return error('action actor ${action.actor} is invalid')
		}
	}
}
