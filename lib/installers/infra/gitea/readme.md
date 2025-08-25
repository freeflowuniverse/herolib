# gitea



To get started

```v

import freeflowuniverse.herolib.installers.infra.gitea as gitea_installer


//if you want to configure using heroscript
gitea_installer.play(heroscript:'
    !!gitea.configure name:test
        passwd:'something'
        domain: 'docs.info.com'
    ')!

mut installer:= gitea_installer.get(name:'test')!
installer.start()!


```


this will look for a configured mail & postgresql client both on instance name: "default", change in heroscript if needed

- postgresql_client_name = "default"
- mail_client_name = "default"