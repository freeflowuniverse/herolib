#!/usr/bin/env -S v -n -w -cg -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.dev.gittools
import os

heroscript := "

!!git.define
    coderoot:'/tmp/code' //when we overrule the location, the default is ~/code
    light:true //depth of git clone is 1
    log:true 
    debug:false //give more error reporting
    offline:false //makes sure will not try to get to internet, but do all locally
    ssh_key_path:'' //if a specific ssh key is needed
    reload:false //if set then will remove cache and load full status, this is slow !
"

gittools.play(heroscript: heroscript)!

