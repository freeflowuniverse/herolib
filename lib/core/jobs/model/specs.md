create a job manager in 
lib/core/jobs


## some definitions

- agent: is a self contained set of processes which can execute on actions or actions to be executed by others
- action: what needs to be executed
- circle: each action happens in a circle
- context: a context inside a circle is optional
- job, what gets executed by an agent, is one action, can depend on other actions
- herorunner: is the process which uses redis to manage all open jobs, checks for timeouts, does the forwards if needed (if remote agent need to schedule, ...)

## jobs 

are executed by processes can be in different languages and they are identified by agent pub key (the one who executes)
as part of heroscript we know what to executed on which actor inside the agent, defined with method and its arguments

```v

//the description of what needs to be executed
pub struct Job {
pub mut:
    guid               string //unique id for the job
    agents             []string //the pub key of the agent(s) which will execute the command, only 1 will execute, the herorunner will try the different agents if needed till it has success
    source string //pubkey from the agent who asked for the job
    circle             string = "default" //our digital life is organized in circles
    context            string = "default" //is the high level context in which actors will execute the work inside a circle
    actor   string   //e.g. vm_manager
    action  string   //e.g. start 
    params  map[string]string //e.g. id:10
    timeout_schedule u16 = 60 //timeout before its picked up
	timeout            u16  = 3600 // timeout in sec
	log                bool = true
	ignore_error       bool              // means if error will just exit and not raise, there will be no error reporting
	ignore_error_codes []int             // of we want to ignore certain error codes
	debug              bool   // if debug will get more context
	retry              int  // default there is no debug
    status             JobStatus
    dependencies []JobDependency //will not execute untill other jobs are done

}

pub struct JobStatus {
pub mut:
    guid               string //unique id for the job
    created            u32 //epoch when we created the job
    start              u32 //epoch when the job needs to start 
    end                u32 //epoch when the job ended, can be in error
    status   //ENUM: create   scheduled, planned (means arrived where actor will execute the job), running, error, ok
}

pub struct JobDependency {
pub mut:
    guid               string //unique id for the job
    agents             []string //the pub key of the agent(s) which can execute the command
}



```

the Job object is stored in redis in hset herorunner:jobs where key is the job guid and the val is the json of Job

## Agent Registration Services

Each agent (the one who hosts the different actors which execute the methods with params) register themselves to all participants.

the structs below are available to everyone and are public

```v

pub struct Agent {
pub mut:
    pubkey             string //pubkey using ed25519
    address string //where we can gind the agent
    port int //default 9999
    description string //optional
    status             AgentStatus
    services []AgentService //these are the public services
    signature   string //signature as done by private key of $address+$port+$description+$status   (this allows everyone to verify that the data is ok)
    

}

pub struct AgentStatus {
pub mut:
    guid               string //unique id for the job
    timestamp_first            u32 //when agent came online
    timestamp_last             u32 //last time agent let us know that he is working
    status   //ENUM: ok, down, error, halted
}

pub struct AgentService {
pub mut:
    actor string
    actions []AgentServiceAction
    description string
    status   //ENUM: ok, down, error, halted
}

pub struct AgentServiceAction {
pub mut:
    action string //which action
    description string //optional descroption
    params map[string]string  //e.g. name:'name of the vm' ...
    params_example map[string]string  // e.g. name:'myvm'
    status   //ENUM: ok, down, error, halted
    public bool //if everyone can use then true, if restricted means only certain people can use
}





```

the Agent object is stored in redis in hset herorunner:agents where key is the agent pubkey and the val is the json of Agent


### Services Info

The agent and its actors register their capability to the herorunner

We have a mechanism to be specific on who can execute which, this is sort of ACL system, for now its quite rough



```v

pub struct Group {
pub mut:
    guid string //unique id
    name string
    description string
    members []string //can be other group or member which is defined by pubkey
}


```

this info is stored in in redis on herorunner:groups



```v

pub struct Service {
pub mut:
    actor string
    actions []AgentServiceAction
    description string
    status   //ENUM: ok, down, error, halted
    acl ?ACL
}

pub struct ServiceAction {
pub mut:
    action string //which action
    description string //optional descroption
    params map[string]string  //e.g. name:'name of the vm' ...
    params_example map[string]string  // e.g. name:'myvm'
    acl ?ACL //if not used then everyone can use
}

pub struct ACL {
pub mut:
    name string
    ace []ACE
}


pub struct ACE {
pub mut:
    groups []string //guid's of the groups who have access
    users []string //in case groups are not used then is users
    right string e.g. read, write, admin, block
}




```

The info for the herorunner to function is in redis on herorunner:services

