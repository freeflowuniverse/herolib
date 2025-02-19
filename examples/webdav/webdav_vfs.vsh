#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.vfs.webdav
import freeflowuniverse.herolib.vfs.vfsnested
import freeflowuniverse.herolib.vfs.vfscore
import freeflowuniverse.herolib.vfs.vfsourdb

mut high_level_vfs := vfsnested.new()

// lower level VFS Implementations that use OurDB
mut vfs1 := vfsourdb.new('/tmp/test_webdav_ourdbvfs/vfs1', '/tmp/test_webdav_ourdbvfs/vfs1')!
mut vfs2 := vfsourdb.new('/tmp/test_webdav_ourdbvfs/vfs2', '/tmp/test_webdav_ourdbvfs/vfs2')!
mut vfs3 := vfsourdb.new('/tmp/test_webdav_ourdbvfs/vfs3', '/tmp/test_webdav_ourdbvfs/vfs3')!

// Nest OurDB VFS instances at different paths
high_level_vfs.add_vfs('/data', vfs1) or { panic(err) }
high_level_vfs.add_vfs('/config', vfs2) or { panic(err) }
high_level_vfs.add_vfs('/data/backup', vfs3) or { panic(err) } // Nested under /data

// Create WebDAV Server that uses high level VFS
mut webdav_server := webdav.new_app(
	vfs:     high_level_vfs
	user_db: {
		'omda': '123'
	}
)!
webdav_server.run()
