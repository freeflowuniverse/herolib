module jobs

import freeflowuniverse.herolib.data.ourtime

// Agent represents a service provider that can execute jobs
pub struct Agent {
pub mut:
	pubkey      string         // pubkey using ed25519
	address     string         // where we can find the agent
	port        int           // default 9999
	description string         // optional
	status      AgentStatus
	services    []AgentService // these are the public services
	signature   string         // signature as done by private key of $address+$port+$description+$status
}

// AgentStatus represents the current state of an agent
pub struct AgentStatus {
pub mut:
	guid             string          // unique id for the job
	timestamp_first  ourtime.Time    // when agent came online
	timestamp_last   ourtime.Time    // last time agent let us know that he is working
	status           AgentState      // current state of the agent
}

// AgentService represents a service provided by an agent
pub struct AgentService {
pub mut:
	actor       string                // name of the actor providing the service
	actions     []AgentServiceAction  // available actions for this service
	description string                // optional description
	status      AgentServiceState    // current state of the service
}

// AgentServiceAction represents an action that can be performed by a service
pub struct AgentServiceAction {
pub mut:
	action          string            // which action
	description     string            // optional description
	params          map[string]string // e.g. name:'name of the vm' ...
	params_example  map[string]string // e.g. name:'myvm'
	status          AgentServiceState // current state of the action
	public          bool             // if everyone can use then true, if restricted means only certain people can use
}

// AgentState represents the possible states of an agent
pub enum AgentState {
	ok     // agent is functioning normally
	down   // agent is not responding
	error  // agent encountered an error
	halted // agent has been manually stopped
}

// AgentServiceState represents the possible states of an agent service or action
pub enum AgentServiceState {
	ok     // service/action is functioning normally
	down   // service/action is not available
	error  // service/action encountered an error
	halted // service/action has been manually stopped
}
