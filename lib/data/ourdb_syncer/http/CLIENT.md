# OurDB Client

## Overview
This client is created to interact with an OurDB server.

## Prerequisites
Before running the client script, ensure that the OurDB server is up and running. You can start the server by following the instructions in the [OurDB Server README](./SERVER.md).

## Installation

Ensure you have the V programming language installed. You can download it from [vlang.io](https://vlang.io/).

## Running the Client

Once the OurDB server is running, execute the client script:
```sh
examples/data/ourdb_client.vsh
```

Alternatively, you can run it using V:
```sh
v -enable-globals run ourdb_client.vsh
```

## How It Works
1. Connects to the OurDB server on `localhost:3000`.
2. Sets a record with the value `hello`.
3. Retrieves the record by ID and verifies the stored value.
4. Deletes the record.

## Example Output
```
Set result: { id: 1, value: 'hello' }
Get result: { id: 1, value: 'hello' }
```
