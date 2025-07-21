module starlight

import os
import strings

pub fn (mut site DocSite) clean(args ErrorArgs) ! {
	toclean := '
		/node_modules

		babel.config.js

		# Production
		/build

		# Generated files
		.docusaurus
		.cache-loader

		# Misc
		.DS_Store
		.env.local
		.env.development.local
		.env.test.local
		.env.production.local

		npm-debug.log*
		yarn-debug.log*
		yarn-error.log*
		bun.lockb
		bun.lock

		yarn.lock

		build.sh
		build_dev.sh
		build-dev.sh		
		develop.sh
		install.sh

		package.json
		package-lock.json
		pnpm-lock.yaml

		sidebars.ts

		tsconfig.json
		'

	// TODO: need better way how to deal with this
}
