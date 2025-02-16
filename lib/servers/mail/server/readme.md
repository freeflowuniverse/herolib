## hero mail server 

see examples/servers/imap_example.vsh for example

```v
#!/usr/bin/env -S v -n -w -cg -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.servers.mail.server

// Start the IMAP server on port 143
server.start_demo() !
```