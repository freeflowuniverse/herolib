# zinit

Zinit is threefold startup manager, in linux will be launched inside systemd

```v


#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.installers.sysadmintools.zinit as zinit_installer

mut installer:=zinit_installer.get()!
installer.start()!


```

