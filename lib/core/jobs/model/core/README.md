# HeroLib Job Manager

This document explains the job management system in HeroLib, which is designed to coordinate distributed task execution across multiple agents.

## Core Components

### 1. Job System

The job system is the central component that manages tasks to be executed by agents. It consists of:

- **Job**: Represents a task to be executed by an agent. Each job has:
  - A unique GUID
  - Target agents (public keys of agents that can execute the job)
  - Source (public key of the agent requesting the job)
  - Circle and context (organizational structure)
  - Actor and action (what needs to be executed)
  - Parameters (data needed for execution)
  - Timeout settings
  - Status information
  - Dependencies on other jobs

- **JobStatus**: Tracks the state of a job through its lifecycle:
  - created → scheduled → planned → running → ok/error

- **JobManager**: Handles CRUD operations for jobs, storing them in Redis under the `herorunner:jobs` key.

### 2. Agent System

The agent system represents the entities that can execute jobs:

- **Agent**: Represents a service provider that can execute jobs. Each agent has:
  - A public key (identifier)
  - Network address and port
  - Status information
  - List of services it provides
  - Cryptographic signature for verification

- **AgentService**: Represents a service provided by an agent, with:
  - Actor name
  - Available actions
  - Status information

- **AgentManager**: Handles CRUD operations for agents, storing them in Redis under the `herorunner:agents` key.

### 3. Service System

The service system defines the capabilities available in the system:

- **Service**: Represents a capability that can be provided by agents. Each service has:
  - Actor name
  - Available actions
  - Status information
  - Optional access control list

- **ServiceAction**: Represents an action that can be performed by a service, with:
  - Action name
  - Parameters
  - Optional access control list

- **ServiceManager**: Handles CRUD operations for services, storing them in Redis under the `herorunner:services` key.

### 4. Access Control System

The access control system manages permissions:

- **Circle**: Represents a collection of members (users or other circles)
- **ACL**: Access Control List containing multiple ACEs
- **ACE**: Access Control Entry defining permissions for users or circles
- **CircleManager**: Handles CRUD operations for circles, storing them in Redis under the `herorunner:circles` key.

### 5. HeroRunner

The `HeroRunner` is the main factory that brings all components together, providing a unified interface to the job management system.

## How It Works

1. **Job Creation and Scheduling**:
   - A client creates a job with specific actor, action, and parameters
   - The job is stored in Redis with status "created"
   - The job can specify dependencies on other jobs

2. **Agent Registration**:
   - Agents register themselves with their public key, address, and services
   - Each agent provides a list of services (actors) and actions it can perform
   - Agents periodically update their status

3. **Service Discovery**:
   - Services define the capabilities available in the system
   - Each service has a list of actions it can perform
   - Services can have access control to restrict who can use them

4. **Job Execution**:
   - The herorunner process monitors jobs in Redis
   - When a job is ready (dependencies satisfied), it changes status to "scheduled"
   - The herorunner forwards the job to an appropriate agent
   - The agent changes job status to "planned", then "running", and finally "ok" or "error"
   - If an agent fails, the herorunner can retry with another agent

5. **Access Control**:
   - Users and circles are organized in a hierarchical structure
   - ACLs define who can access which services and actions
   - The service manager checks access permissions before allowing job execution

## Data Storage

All data is stored in Redis using the following keys:
- `herorunner:jobs` - Hash map of job GUIDs to job JSON
- `herorunner:agents` - Hash map of agent public keys to agent JSON
- `herorunner:services` - Hash map of service actor names to service JSON
- `herorunner:circles` - Hash map of circle GUIDs to circle JSON

## Potential Issues

1. **Concurrency Management**:
   - The current implementation doesn't have explicit locking mechanisms for concurrent access to Redis
   - Race conditions could occur if multiple processes update the same job simultaneously

2. **Error Handling**:
   - While there are error states, the error handling is minimal
   - There's no robust mechanism for retrying failed jobs or handling partial failures

3. **Dependency Resolution**:
   - The code for resolving job dependencies is not fully implemented
   - It's unclear how circular dependencies would be handled

4. **Security Concerns**:
   - While there's a signature field in the Agent struct, the verification process is not evident
   - The ACL system is basic and might not handle complex permission scenarios

5. **Scalability**:
   - All data is stored in Redis, which could become a bottleneck with a large number of jobs
   - There's no apparent sharding or partitioning strategy

6. **Monitoring and Observability**:
   - Limited mechanisms for monitoring the system's health
   - No built-in logging or metrics collection

## Recommendations

1. Implement proper concurrency control using Redis transactions or locks
2. Enhance error handling with more detailed error states and recovery mechanisms
3. Develop a robust dependency resolution system with cycle detection
4. Strengthen security by implementing proper signature verification and enhancing the ACL system
5. Consider a more scalable storage solution for large deployments
6. Add comprehensive logging and monitoring capabilities

## Usage Example

```v
// Initialize the HeroRunner
mut hr := model.new()!

// Create a new job
mut job := hr.jobs.new()
job.guid = 'job-123'
job.actor = 'vm_manager'
job.action = 'start'
job.params['id'] = '10'
hr.jobs.set(job)!

// Register an agent
mut agent := hr.agents.new()
agent.pubkey = 'agent-456'
agent.address = '192.168.1.100'
agent.services << model.AgentService{
    actor: 'vm_manager'
    actions: [
        model.AgentServiceAction{
            action: 'start'
            params: {'id': 'string'}
        }
    ]
}
hr.agents.set(agent)!

// Define a service
mut service := hr.services.new()
service.actor = 'vm_manager'
service.actions << model.ServiceAction{
    action: 'start'
    params: {'id': 'string'}
}
hr.services.set(service)!
```

## Circle Management with HeroScript

You can use HeroScript to create and manage circles. Here's an example of how to create a circle and add members to it:

```heroscript
!!circle.create
    name: 'development'
    description: 'Development team circle'

!!circle.add_member
    circle: 'development'
    name: 'John Doe'
    pubkey: 'user-123'
    email: 'john@example.com'
    role: 'admin'
    description: 'Lead developer'

!!circle.add_member
    circle: 'development'
    name: 'Jane Smith'
    pubkeys: 'user-456,user-789'
    emails: 'jane@example.com,jsmith@company.com'
    role: 'member'
    description: 'Frontend developer'
```

To process this HeroScript in your V code:

```v
#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.data.ourdb
import freeflowuniverse.herolib.data.radixtree
import freeflowuniverse.herolib.core.jobs.model

// Example HeroScript text
const heroscript_text = """
!!circle.create
    name: 'development'
    description: 'Development team circle'

!!circle.add_member
    circle: 'development'
    name: 'John Doe'
    pubkey: 'user-123'
    email: 'john@example.com'
    role: 'admin'
    description: 'Lead developer'

!!circle.add_member
    circle: 'development'
    name: 'Jane Smith'
    pubkeys: 'user-456,user-789'
    emails: 'jane@example.com,jsmith@company.com'
    role: 'member'
    description: 'Frontend developer'
"""

fn main() ! {
    // Initialize database
    mut db_data := ourdb.new(path: '/tmp/herorunner_data')!
    mut db_meta := radixtree.new(path: '/tmp/herorunner_meta')!
    
    // Create circle manager
    mut circle_manager := model.new_circlemanager(db_data, db_meta)
    
    // Parse the HeroScript
    mut pb := playbook.new(text: heroscript_text)!
    
    // Process the circle commands
    model.play_circle(mut circle_manager, mut pb)!
    
    // Check the results
    circles := circle_manager.getall()!
    println('Created ${circles.len} circles:')
    for circle in circles {
        println('Circle: ${circle.name} (ID: ${circle.id})')
        println('Members: ${circle.members.len}')
        for member in circle.members {
            println('  - ${member.name} (${member.role})')
        }
    }
}
```

## Domain Name Management with HeroScript

You can use HeroScript to create and manage domain names and DNS records. Here's an example of how to create a domain and add various DNS records to it:

```heroscript
!!name.create
    domain: 'example.org'
    description: 'Example organization domain'
    admins: 'admin1-pubkey,admin2-pubkey'

!!name.add_record
    domain: 'example.org'
    name: 'www'
    type: 'a'
    addrs: '192.168.1.1,192.168.1.2'
    text: 'Web server'

!!name.add_record
    domain: 'example.org'
    name: 'mail'
    type: 'mx'
    addr: '192.168.1.10'
    text: 'Mail server'

!!name.add_admin
    domain: 'example.org'
    pubkey: 'admin3-pubkey'
```

To process this HeroScript in your V code:

```v
#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.data.ourdb
import freeflowuniverse.herolib.data.radixtree
import freeflowuniverse.herolib.core.jobs.model

// Example HeroScript text
const heroscript_text = """
!!name.create
    domain: 'example.org'
    description: 'Example organization domain'
    admins: 'admin1-pubkey,admin2-pubkey'

!!name.add_record
    domain: 'example.org'
    name: 'www'
    type: 'a'
    addrs: '192.168.1.1,192.168.1.2'
    text: 'Web server'

!!name.add_record
    domain: 'example.org'
    name: 'mail'
    type: 'mx'
    addr: '192.168.1.10'
    text: 'Mail server'

!!name.add_admin
    domain: 'example.org'
    pubkey: 'admin3-pubkey'
"""

fn main() ! {
    // Initialize database
    mut db_data := ourdb.new(path: '/tmp/dns_data')!
    mut db_meta := radixtree.new(path: '/tmp/dns_meta')!
    
    // Create name manager
    mut name_manager := model.new_namemanager(db_data, db_meta)
    
    // Parse the HeroScript
    mut pb := playbook.new(text: heroscript_text)!
    
    // Process the name commands
    model.play_name(mut name_manager, mut pb)!
    
    // Check the results
    names := name_manager.getall()!
    println('Created ${names.len} domains:')
    for name in names {
        println('Domain: ${name.domain} (ID: ${name.id})')
        println('Records: ${name.records.len}')
        for record in name.records {
            println('  - ${record.name}.${name.domain} (${record.category})')
            println('    Addresses: ${record.addr}')
        }
        println('Admins: ${name.admins.len}')
        for admin in name.admins {
            println('  - ${admin}')
        }
    }
}
```
