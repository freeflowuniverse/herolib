# Mycelium Streamer

## Overview

This project demonstrates a master-worker setup using `mycelium` for distributed data storage. The master node interacts with worker nodes over the network to store and retrieve data.

## Prerequisites

Before running the master node example, ensure the following:

- `mycelium` binary is installed and running on both local and remote machines.
- Worker nodes are set up and running with the mycelium instance.

## Setup

1. Start `mycelium` on the local machine with the following command:

```bash
mycelium --peers tcp://188.40.132.242:9651 "quic://[2a01:4f8:212:fa6::2]:9651" tcp://185.69.166.7:9651 "quic://[2a02:1802:5e:0:ec4:7aff:fe51:e36b]:9651" tcp://65.21.231.58:9651 "quic://[2a01:4f9:5a:1042::2]:9651" "tcp://[2604:a00:50:17b:9e6b:ff:fe1f:e054]:9651" quic://5.78.122.16:9651 "tcp://[2a01:4ff:2f0:3621::1]:9651" quic://142.93.217.194:9651 --tun-name tun2 --tcp-listen-port 9652 --quic-listen-port 9653 --api-addr 127.0.0.1:9000
```

Replace IP addresses and ports with your specific configuration.

2. On the remote machine where the worker will run, execute the same `mycelium` command as above.

3. Execute the worker example code provided (`herolib/examples/data/deduped_mycelium_worker.vsh`) on the remote worker machine.

## Running the Master Example

After setting up `mycelium` and the worker nodes, run the master example script (`herolib/examples/data/deduped_mycelium_master.vsh`) on the local machine.
