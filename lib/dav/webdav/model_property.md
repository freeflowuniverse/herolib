# WebDAV Property Model

This file implements the WebDAV property model as defined in [RFC 4918](https://tools.ietf.org/html/rfc4918). It provides a set of property types that represent various WebDAV properties used in PROPFIND and PROPPATCH operations.

## Overview

The `model_property.v` file defines:

1. A `Property` interface that all WebDAV properties must implement
2. Various property type implementations for standard WebDAV properties
3. Helper functions for XML serialization and time formatting

## Property Interface

```v
pub interface Property {
	xml() string
	xml_name() string
}
```

All WebDAV properties must implement:
- `xml()`: Returns the full XML representation of the property with its value
- `xml_name()`: Returns just the XML tag name of the property (used in property requests)

## Property Types

The file implements the following WebDAV property types:

| Property Type | Description |
|---------------|-------------|
| `DisplayName` | The display name of a resource |
| `GetLastModified` | Last modification time of a resource |
| `GetContentType` | MIME type of a resource |
| `GetContentLength` | Size of a resource in bytes |
| `ResourceType` | Indicates if a resource is a collection (directory) or not |
| `CreationDate` | Creation date of a resource |
| `SupportedLock` | Lock capabilities supported by the server |
| `LockDiscovery` | Active locks on a resource |

## Helper Functions

- `fn (p []Property) xml() string`: Generates XML for a list of properties
- `fn format_iso8601(t time.Time) string`: Formats a time in ISO8601 format for WebDAV

## Usage

These property types are used when responding to WebDAV PROPFIND requests to describe resources in the WebDAV server.
