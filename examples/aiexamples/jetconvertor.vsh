#!/usr/bin/env -S v -n -w -cg -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.mcp.aitools

aitools.convert_pug("/root/code/github/freeflowuniverse/herolauncher/pkg/herolauncher/web/templates/admin")!