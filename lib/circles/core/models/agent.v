module models

import freeflowuniverse.herolib.data.ourtime
import freeflowuniverse.herolib.data.encoder

// Agent represents self service provider that can execute jobs
pub struct Agent {
pub mut:
	id          u32
	pubkey      string // pubkey using ed25519
	address     string // where we can find the agent
	port        u16    // default 9999
	description string // optional
	status      AgentStatus
	services    []AgentService
	signature   string // signature as done by private key of $address+$port+$description+$status
}

@[params]
pub struct ServiceParams {
pub mut:
	actor       string
	description string
}

// new_service creates self new AgentService for this agent
pub fn (mut self Agent) new_service(args ServiceParams) &AgentService {
	mut service := AgentService{
		actor:       args.actor
		description: args.description
		status:      .ok
		public:      true
	}
	self.services << service
	return &self.services[self.services.len - 1]
}

@[params]
pub struct ActionParams {
pub mut:
	action      string
	description string
}

// new_service_action creates self new AgentServiceAction for the specified service
pub fn (mut service AgentService) new_action(args ActionParams) &AgentServiceAction {
	mut service_action := AgentServiceAction{
		action:      args.action
		description: args.description
		status:      .ok
		public:      true
	}
	service.actions << service_action
	return &service.actions[service.actions.len - 1]
}

// AgentStatus represents the current state of an agent
pub struct AgentStatus {
pub mut:
	guid            string          // unique id for the job
	timestamp_first ourtime.OurTime // when agent came online
	timestamp_last  ourtime.OurTime // last time agent let us know that he is working
	status          AgentState      // current state of the agent
}

// AgentService represents self service provided by an agent
pub struct AgentService {
pub mut:
	actor       string               // name of the actor providing the service
	actions     []AgentServiceAction // available actions for this service
	description string               // optional description
	status      AgentServiceState    // current state of the service
	public      bool                 // if everyone can use then true, if restricted means only certain people can use
}

// AgentServiceAction represents an action that can be performed by self service
pub struct AgentServiceAction {
pub mut:
	action         string            // which action
	description    string            // optional description
	params         map[string]string // e.g. name:'name of the vm' ...
	params_example map[string]string // e.g. name:'myvm'
	status         AgentServiceState // current state of the action
	public         bool              // if everyone can use then true, if restricted means only certain people can use
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

pub fn (self Agent) index_keys() map[string]string {
	return {
		'pubkey': self.pubkey
	}
}

// dumps serializes the Agent struct to binary format using the encoder
pub fn (self Agent) dumps() ![]u8 {
	mut e := encoder.new()

	// Add unique encoding ID to identify this type of data
	e.add_u16(100)

	// Encode Agent fields
	e.add_string(self.pubkey)
	e.add_string(self.address)
	e.add_u16(self.port)
	e.add_string(self.description)

	// Encode AgentStatus
	e.add_string(self.status.guid)
	e.add_ourtime(self.status.timestamp_first)
	e.add_ourtime(self.status.timestamp_last)
	e.add_u8(u8(self.status.status))

	// Encode services array
	e.add_u16(u16(self.services.len))
	for service in self.services {
		// Encode AgentService fields
		e.add_string(service.actor)
		e.add_string(service.description)
		e.add_u8(u8(service.status))
		e.add_u8(u8(service.public))

		// Encode actions array
		e.add_u16(u16(service.actions.len))
		for action in service.actions {
			// Encode AgentServiceAction fields
			e.add_string(action.action)
			e.add_string(action.description)
			e.add_u8(u8(action.status))
			e.add_u8(u8(action.public))

			// Encode params map
			e.add_map_string(action.params)

			// Encode params_example map
			e.add_map_string(action.params_example)
		}
	}

	// Encode signature
	e.add_string(self.signature)

	return e.data
}

// loads deserializes binary data into an Agent struct
pub fn agent_loads(data []u8) !Agent {
	mut d := encoder.decoder_new(data)

	// Check encoding ID to verify this is the correct type of data
	encoding_id := d.get_u16()!
	if encoding_id != 100 {
		return error('Wrong file type: expected encoding ID 100, got ${encoding_id}, for agent')
	}

	mut self := Agent{}

	// Decode Agent fields
	self.pubkey = d.get_string()!
	self.address = d.get_string()!
	self.port = d.get_u16()!
	self.description = d.get_string()!

	// Decode AgentStatus
	self.status.guid = d.get_string()!
	self.status.timestamp_first = d.get_ourtime()!
	self.status.timestamp_last = d.get_ourtime()!
	status_val := d.get_u8()!
	self.status.status = match status_val {
		0 { AgentState.ok }
		1 { AgentState.down }
		2 { AgentState.error }
		3 { AgentState.halted }
		else { return error('Invalid AgentState value: ${status_val}') }
	}

	// Decode services array
	services_len := d.get_u16()!
	self.services = []AgentService{len: int(services_len)}
	for i in 0 .. services_len {
		mut service := AgentService{}

		// Decode AgentService fields
		service.actor = d.get_string()!
		service.description = d.get_string()!
		service_status_val := d.get_u8()!
		service.status = match service_status_val {
			0 { AgentServiceState.ok }
			1 { AgentServiceState.down }
			2 { AgentServiceState.error }
			3 { AgentServiceState.halted }
			else { return error('Invalid AgentServiceState value: ${service_status_val}') }
		}
		service.public = d.get_u8()! == 1

		// Decode actions array
		actions_len := d.get_u16()!
		service.actions = []AgentServiceAction{len: int(actions_len)}
		for j in 0 .. actions_len {
			mut action := AgentServiceAction{}

			// Decode AgentServiceAction fields
			action.action = d.get_string()!
			action.description = d.get_string()!
			action_status_val := d.get_u8()!
			action.status = match action_status_val {
				0 { AgentServiceState.ok }
				1 { AgentServiceState.down }
				2 { AgentServiceState.error }
				3 { AgentServiceState.halted }
				else { return error('Invalid AgentServiceState value: ${action_status_val}') }
			}
			action.public = d.get_u8()! == 1

			// Decode params map
			action.params = d.get_map_string()!

			// Decode params_example map
			action.params_example = d.get_map_string()!

			service.actions[j] = action
		}

		self.services[i] = service
	}

	// Decode signature
	self.signature = d.get_string()!

	return self
}

// loads deserializes binary data into the Agent struct
pub fn (mut self Agent) loads(data []u8) ! {
	loaded := agent_loads(data)!

	// Copy all fields from loaded to self
	self.id = loaded.id
	self.pubkey = loaded.pubkey
	self.address = loaded.address
	self.port = loaded.port
	self.description = loaded.description
	self.status = loaded.status
	self.services = loaded.services
	self.signature = loaded.signature
}
