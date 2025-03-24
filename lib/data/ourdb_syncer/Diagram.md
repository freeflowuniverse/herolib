```
+-----------------+
|     User        |
| (HTTP Client)   |
+-----------------+
          |
          | HTTP Requests (GET, SET, DELETE)
          v
+-----------------+
|   HTTP Server   |
| (Exposed API)   |
+-----------------+
          |
          | Internal Communication via Mycelium Network
          |
          +-------------------+-------------------+
          |                   |                   |
          v                   v                   v
+-----------------+   +-----------------+   +-----------------+
|    Master       |   |    Worker 1     |   |    Worker 2     |
| (Handles Writes)|   | (Handles Reads) |   | (Handles Reads) |  
|    OurDB        |   |    OurDB        |   |    OurDB        |
+-----------------+   +-----------------+   +-----------------+
          |                   |                   |
          |                   |                   |
          |                   v                   |
          |     Data Sync via Mycelium Network    |
          |                                       |
          +------------------->+------------------+
```