#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.installers.infra.livekit as livekit_installer

mut livekit := livekit_installer.get()!
livekit.install()!
livekit.start()!
livekit.destroy()!
