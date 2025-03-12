module webdav

import encoding.xml
import log
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.vfs
import freeflowuniverse.herolib.vfs.vfs_db
import os
import time
import net.http
import veb

@['/:path...'; propfind]
fn (mut server Server) propfind(mut ctx Context, path string) veb.Result {	
	// Parse PROPFIND request
	propfind_req := parse_propfind_xml(ctx.req) or {
		return ctx.error(WebDAVError{
			status: .bad_request
			message: 'Failed to parse PROPFIND XML: ${err}'
			tag: 'propfind-parse-error'
		})
	}

	log.debug('[WebDAV] Propfind Request: ${propfind_req.typ} ${propfind_req.depth}')
	
	// Check if resource is locked
	if server.lock_manager.is_locked(ctx.req.url) {
		// If the resource is locked, we should still return properties
		// but we might need to indicate the lock status in the response
		// This is handled in the property generation
		log.info('[WebDAV] Resource is locked: ${ctx.req.url}')
	}
	
	entry := server.vfs.get(path) or { 
		return ctx.error(
			status: .not_found
			message: 'Path ${path} does not exist'
			tag: 'resource-must-be-null'
		)
	}
	
	responses := server.get_responses(entry, propfind_req, path) or {
		return ctx.server_error('Failed to get entry properties ${err}')
	}

	// log.debug('[WebDAV] Propfind responses ${responses}')

	// Create multistatus response using the responses
	ctx.res.set_status(.multi_status)
	return ctx.send_response_to_client('application/xml', responses.xml())
}

// get_responses returns all properties for the given path and depth
fn (mut server Server) get_responses(entry vfs.FSEntry, req PropfindRequest, path string) ![]Response {
	mut responses := []Response{}
	
	// path := server.vfs.get_path(entry)!

	// main entry response
	responses << Response {
		href: path
		// not_found: entry.get_unfound_properties(req)
		found_props: server.get_properties(entry)
	}
	
	if !entry.is_dir() || req.depth == .zero { 
		return responses
	}

	entries := server.vfs.dir_list(path) or { 
		log.error('Failed to list directory for ${path} ${err}')
		return responses }
	for e in entries {
		responses << server.get_responses(e, PropfindRequest {
			...req,
			depth: if req.depth == .one { .zero } else { .infinity }
		}, '${path.trim_string_right("/")}/${e.get_metadata().name}')!
	}
	return responses
}

// returns the properties of a filesystem entry
fn (mut server Server) get_properties(entry &vfs.FSEntry) []Property {
	mut props := []Property{}

	metadata := entry.get_metadata()

	// Display name
	props << DisplayName(metadata.name)
	props << GetLastModified(format_iso8601(metadata.modified_time()))
	props << GetContentType(if entry.is_dir() {'httpd/unix-directory'} else {get_file_content_type(entry.get_metadata().name)})
	props << ResourceType(entry.is_dir())
	
	// Content length (only for files)
	if !entry.is_dir() {
		props << GetContentLength(metadata.size.str())
	}

	// Creation date
	props << CreationDate(format_iso8601(metadata.created_time()))
	return props
}