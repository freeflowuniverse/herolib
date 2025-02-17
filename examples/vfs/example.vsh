#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.vfs.webdav
import freeflowuniverse.herolib.vfs.vfsnested
import freeflowuniverse.herolib.vfs.ourdb_fs

high_level_vfs := vfsnested.new()

// lower level VFS Implementations that use OurDB
mut vfs1 := ourdb_fs.new(
	data_dir: '/tmp/test_webdav_ourdbvfs/vfs1'
	metadata_dir: '/tmp/test_webdav_ourdbvfs/vfs1'
)!
mut vfs2 := ourdb_fs.new(
	data_dir: '/tmp/test_webdav_ourdbvfs/vfs2'
	metadata_dir: '/tmp/test_webdav_ourdbvfs/vfs2'
)!
mut vfs3 := ourdb_fs.new(
	data_dir: '/tmp/test_webdav_ourdbvfs/vfs3'
	metadata_dir: '/tmp/test_webdav_ourdbvfs/vfs3'
)!

// Nest OurDB VFS instances at different paths
high_level_vfs.add_vfs('/data', vfs1) or { panic(err) }
high_level_vfs.add_vfs('/config', vfs2) or { panic(err) }
high_level_vfs.add_vfs('/data/backup', vfs3) or { panic(err) } // Nested under /data

// Create WebDAV Server that uses high level VFS
webdav_server := webdav.new_app(
	vfs: high_level_vfs
)