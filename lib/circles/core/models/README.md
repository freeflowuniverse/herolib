# Circles Core Models

This directory contains the core data structures used in the herolib circles module. These models serve as the foundation for the circles functionality, providing essential data structures for agents, circles, and name management.

## Overview

The core models implement the Serializer interface, which allows them to be stored and retrieved using the generic Manager implementation. Each model provides:

- A struct definition with appropriate fields
- Serialization methods (`dumps()`) for converting to binary format
- Deserialization functions (`*_loads()`) for recreating objects from binary data
- Index key methods for efficient lookups

## Core Models

### Agent (`agent.v`)

The Agent model represents a self-service provider that can execute jobs:

- **Agent**: Main struct with fields for identification, communication, and status
- **AgentService**: Represents services provided by an agent
- **AgentServiceAction**: Defines actions that can be performed by a service
- **AgentStatus**: Tracks the operational status of an agent
- **AgentState**: Enum for possible agent states (ok, down, error, halted)
- **AgentServiceState**: Enum for possible service states

### Circle (`circle.v`)

The Circle model represents a collection of members (users or other circles):

- **Circle**: Main struct with fields for identification and member management
- **Member**: Represents a member of a circle with personal information and role
- **Role**: Enum for possible member roles (admin, stakeholder, member, contributor, guest)

### Name (`name.v`)

The Name model provides DNS record management:

- **Name**: Main struct for domain management with records and administrators
- **Record**: Represents a DNS record with name, text, category, and addresses
- **RecordType**: Enum for DNS record types (A, AAAA, CNAME, MX, etc.)

## Usage

These models are used by the circles module to manage agents, circles, and DNS records. They are typically accessed through the database handlers that implement the generic Manager interface.

## Serialization

All models implement binary serialization using the encoder module:

- Each model type has a unique encoding ID (Agent: 100, Circle: 200, Name: 300)
- The `dumps()` method serializes the struct to binary format
- The `*_loads()` function deserializes binary data back into the struct

## Database Integration

The models are designed to work with the generic Manager implementation through:

- The `index_keys()` method that provides key-based lookups
- Implementation of the Serializer interface for storage and retrieval
