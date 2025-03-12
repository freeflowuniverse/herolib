module webdav

import encoding.xml
import log
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.vfs
import os
import time
import veb

// Property represents a WebDAV property
pub interface Property {
	xml() string
	xml_name() string
}

type DisplayName = string
type GetLastModified = string
type GetContentType = string
type GetContentLength = string
type ResourceType = bool
type CreationDate = string
type SupportedLock = string
type LockDiscovery = string

fn (p []Property) xml() string {
	return '<D:propstat>
        <D:prop>${p.map(it.xml()).join_lines()}</D:prop>
        <D:status>HTTP/1.1 200 OK</D:status>
    </D:propstat>'
}

fn (p DisplayName) xml() string {
	return '<D:displayname>${p}</D:displayname>'
}

fn (p DisplayName) xml_name() string {
	return '<displayname/>'
}

fn (p GetLastModified) xml() string {
	return '<D:getlastmodified>${p}</D:getlastmodified>'
}

fn (p GetLastModified) xml_name() string {
	return '<getlastmodified/>'
}

fn (p GetContentType) xml() string {
	return '<D:getcontenttype>${p}</D:getcontenttype>'
}

fn (p GetContentType) xml_name() string {
	return '<getcontenttype/>'
}

fn (p GetContentLength) xml() string {
	return '<D:getcontentlength>${p}</D:getcontentlength>'
}

fn (p GetContentLength) xml_name() string {
	return '<getcontentlength/>'
}

fn (p ResourceType) xml() string {
	return if p {
		'<D:resourcetype><D:collection/></D:resourcetype>'
	} else {
		'<D:resourcetype/>'
	}
}

fn (p ResourceType) xml_name() string {
	return '<resourcetype/>'
}

fn (p CreationDate) xml() string {
	return '<D:creationdate>${p}</D:creationdate>'
}

fn (p CreationDate) xml_name() string {
	return '<creationdate/>'
}

fn (p SupportedLock) xml() string {
	return '<D:supportedlock>
		<D:lockentry>
			<D:lockscope><D:exclusive/></D:lockscope>
			<D:locktype><D:write/></D:locktype>
		</D:lockentry>
		<D:lockentry>
			<D:lockscope><D:shared/></D:lockscope>
			<D:locktype><D:write/></D:locktype>
		</D:lockentry>
	</D:supportedlock>'
}

fn (p SupportedLock) xml_name() string {
	return '<supportedlock/>'
}

fn (p LockDiscovery) xml() string {
	return '<D:lockdiscovery>${p}</D:lockdiscovery>'
}

fn (p LockDiscovery) xml_name() string {
	return '<lockdiscovery/>'
}

fn format_iso8601(t time.Time) string {
	return '${t.year:04d}-${t.month:02d}-${t.day:02d}T${t.hour:02d}:${t.minute:02d}:${t.second:02d}Z'
}