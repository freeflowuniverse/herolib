module webdav

import time

fn test_property_xml() {
	// Test DisplayName property
	display_name := DisplayName('test-file.txt')
	assert display_name.xml() == '<D:displayname>test-file.txt</D:displayname>'
	assert display_name.xml_name() == '<displayname/>'

	// Test GetLastModified property
	last_modified := GetLastModified('Mon, 01 Jan 2024 12:00:00 GMT')
	assert last_modified.xml() == '<D:getlastmodified>Mon, 01 Jan 2024 12:00:00 GMT</D:getlastmodified>'
	assert last_modified.xml_name() == '<getlastmodified/>'

	// Test GetContentType property
	content_type := GetContentType('text/plain')
	assert content_type.xml() == '<D:getcontenttype>text/plain</D:getcontenttype>'
	assert content_type.xml_name() == '<getcontenttype/>'

	// Test GetContentLength property
	content_length := GetContentLength('1024')
	assert content_length.xml() == '<D:getcontentlength>1024</D:getcontentlength>'
	assert content_length.xml_name() == '<getcontentlength/>'

	// Test ResourceType property for collection (directory)
	resource_type_dir := ResourceType(true)
	assert resource_type_dir.xml() == '<D:resourcetype><D:collection/></D:resourcetype>'
	assert resource_type_dir.xml_name() == '<resourcetype/>'

	// Test ResourceType property for non-collection (file)
	resource_type_file := ResourceType(false)
	assert resource_type_file.xml() == '<D:resourcetype/>'
	assert resource_type_file.xml_name() == '<resourcetype/>'

	// Test CreationDate property
	creation_date := CreationDate('2024-01-01T12:00:00Z')
	assert creation_date.xml() == '<D:creationdate>2024-01-01T12:00:00Z</D:creationdate>'
	assert creation_date.xml_name() == '<creationdate/>'

	// Test SupportedLock property
	supported_lock := SupportedLock('')
	assert supported_lock.xml().contains('<D:supportedlock>')
	assert supported_lock.xml().contains('<D:lockentry>')
	assert supported_lock.xml().contains('<D:lockscope><D:exclusive/></D:lockscope>')
	assert supported_lock.xml().contains('<D:lockscope><D:shared/></D:lockscope>')
	assert supported_lock.xml().contains('<D:locktype><D:write/></D:locktype>')
	assert supported_lock.xml_name() == '<supportedlock/>'

	// Test LockDiscovery property
	lock_discovery := LockDiscovery('lock-info')
	assert lock_discovery.xml() == '<D:lockdiscovery>lock-info</D:lockdiscovery>'
	assert lock_discovery.xml_name() == '<lockdiscovery/>'
}

fn test_property_array_xml() {
	// Create an array of properties
	mut properties := []Property{}
	
	// Add different property types to the array
	properties << DisplayName('test-file.txt')
	properties << GetContentType('text/plain')
	properties << ResourceType(false)
	
	// Test the xml() function for the array of properties
	xml_output := properties.xml()
	
	// Verify the XML output contains the expected structure
	assert xml_output.contains('<D:propstat>')
	assert xml_output.contains('<D:prop>')
	assert xml_output.contains('<D:displayname>test-file.txt</D:displayname>')
	assert xml_output.contains('<D:getcontenttype>text/plain</D:getcontenttype>')
	assert xml_output.contains('<D:resourcetype/>')
	assert xml_output.contains('<D:status>HTTP/1.1 200 OK</D:status>')
}

fn test_format_iso8601() {
	// Create a test time
	test_time := time.Time{
		year: 2024
		month: 1
		day: 1
		hour: 12
		minute: 30
		second: 45
	}
	
	// Format the time using the format_iso8601 function
	formatted_time := format_iso8601(test_time)
	
	// Verify the formatted time matches the expected ISO8601 format
	assert formatted_time == '2024-01-01T12:30:45Z'
}
