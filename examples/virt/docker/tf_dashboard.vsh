#!/usr/bin/env -S v -n -w -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.virt.docker

mut engine := docker.new(prefix: '', localonly: true)!

mut recipe := engine.recipe_new(name: 'tf_dashboard', platform: .alpine)

println(' - build dashboard')

recipe.add_from(image: 'nginx', tag: 'alpine')!

recipe.add_nodejsbuilder()!

recipe.add_run(cmd: 'apk add git')!
recipe.add_run(cmd: 'npm i -g yarn')!
recipe.add_run(
	cmd: '
	git clone https://github.com/threefoldtech/tfgrid-sdk-ts.git /app 
	cd /app/packages/playground
	yarn install
	yarn lerna run build --no-private 
	yarn workspace @threefold/playground build
'
)!

recipe.add_run(
	cmd: '
	rm /etc/nginx/conf.d/default.conf
	cp /app/packages/playground/nginx.conf /etc/nginx/conf.d
	apk add --no-cache bash
	chmod +x /app/packages/playground/scripts/build-env.sh
	cp -r /app/packages/playground/dist /usr/share/nginx/html
'
)!

recipe.add_run(cmd: 'echo "daemon off;" >> /etc/nginx/nginx.conf')!
recipe.add_cmd(cmd: '/bin/bash -c /app/packages/playground/scripts/build-env.sh')!
recipe.add_entrypoint(cmd: 'nginx')!

recipe.build(false)!
