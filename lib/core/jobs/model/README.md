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
