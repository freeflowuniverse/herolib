#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.installers.infra.gitea as gitea_installer


mut installer:= gitea_installer.get(name:'test')!

//if you want to configure using heroscript
gitea_installer.play(heroscript:"
    !!gitea.configure name:test
        passwd:'something'
        domain: 'docs.info.com'
    ")!

installer.start()!
