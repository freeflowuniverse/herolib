#!/usr/bin/env -S v -n -w -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.installers.infra.gitea as gitea_installer

// First of all, we need to set the gitea configuration
// heroscript := "
// !!gitea.configure
//      name:'default'
//      version:'1.22.6'
//      path: '/var/lib/git'
//      passwd: '12345678'
//      postgresql_name: 'default'
//      mail_from: 'git@meet.tf'
//      smtp_addr: 'smtp-relay.brevo.com'
//      smtp_login: 'admin'
//      smtp_port: 587
//      smtp_passwd: '12345678'
//      domain: 'meet.tf'
//      jwt_secret: ''
//      lfs_jwt_secret: ''
//      internal_token: ''
//      secret_key: ''
// "

// gitea_installer.play(
//      name:       'default'
//      heroscript: heroscript
// )!

// Then we need to get an instace of the installer and call the install
mut gitea := gitea_installer.get()!
// println('gitea configs: ${gitea}')
gitea.install()!
gitea.start()!
