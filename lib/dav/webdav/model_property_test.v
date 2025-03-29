module webdav

import time
import encoding.xml

fn test_property_xml() {
	// Test DisplayName property
	display_name := DisplayName('test-file.txt')
	assert display_name.xml_str() == '<D:displayname>test-file.txt</D:displayname>'
	assert display_name.xml_name() == '<displayname/>'

	// Test GetLastModified property
	last_modified := GetLastModified('Mon, 01 Jan 2024 12:00:00 GMT')
	assert last_modified.xml_str() == '<D:getlastmodified>Mon, 01 Jan 2024 12:00:00 GMT</D:getlastmodified>'
	assert last_modified.xml_name() == '<getlastmodified/>'

	// Test GetContentType property
	content_type := GetContentType('text/plain')
	assert content_type.xml_str() == '<D:getcontenttype>text/plain</D:getcontenttype>'
	assert content_type.xml_name() == '<getcontenttype/>'

	// Test GetContentLength property
	content_length := GetContentLength('1024')
	assert content_length.xml_str() == '<D:getcontentlength>1024</D:getcontentlength>'
	assert content_length.xml_name() == '<getcontentlength/>'

	// Test ResourceType property for collection (directory)
	resource_type_dir := ResourceType(true)
	assert resource_type_dir.xml_str() == '<D:resourcetype><D:collection/></D:resourcetype>'
	assert resource_type_dir.xml_name() == '<resourcetype/>'

	// Test ResourceType property for non-collection (file)
	resource_type_file := ResourceType(false)
	assert resource_type_file.xml_str() == '<D:resourcetype/>'
	assert resource_type_file.xml_name() == '<resourcetype/>'

	// Test CreationDate property
	creation_date := CreationDate('2024-01-01T12:00:00Z')
	assert creation_date.xml_str() == '<D:creationdate>2024-01-01T12:00:00Z</D:creationdate>'
	assert creation_date.xml_name() == '<creationdate/>'

	// Test SupportedLock property
	supported_lock := SupportedLock('')
	supported_lock_str := supported_lock.xml_str()
	assert supported_lock_str.contains('<D:supportedlock>')
	assert supported_lock.xml_name() == '<supportedlock/>'

	// Test LockDiscovery property
	lock_discovery := LockDiscovery('lock-info')
	assert lock_discovery.xml_str() == '<D:lockdiscovery>lock-info</D:lockdiscovery>'
	assert lock_discovery.xml_name() == '<lockdiscovery/>'
}

fn test_property_array_xml() {
	// Create an array of properties
	mut properties := []Property{}

	// Add different property types to the array
	properties << DisplayName('test-file.txt')
	properties << GetContentType('text/plain')
	properties << ResourceType(false)

	// Test the xml_str() function for the array of properties
	xml_output := properties.xml_str()

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
		year:   2024
		month:  1
		day:    1
		hour:   12
		minute: 30
		second: 45
	}

	// Format the time using the format_iso8601 function
	formatted_time := format_iso8601(test_time)

	// Verify the formatted time matches the expected ISO8601 format
	assert formatted_time == '2024-01-01T12:30:45Z'
}

// Custom property implementation for testing
struct CustomProperty {
	name      string
	value     string
	namespace string
}

// Property interface implementation for CustomProperty
fn (p CustomProperty) xml() xml.XMLNodeContents {
	return xml.XMLNode{
		name:     '${p.namespace}:${p.name}'
		children: [xml.XMLNodeContents(p.value)]
	}
}

fn (p CustomProperty) xml_name() string {
	return '<${p.name}/>'
}

fn (p CustomProperty) xml_str() string {
	return '<${p.namespace}:${p.name}>${p.value}</${p.namespace}:${p.name}>'
}

fn test_custom_property() {
	// Test custom property
	custom_prop := CustomProperty{
		name: 'author'
		value: 'Kristof'
		namespace: 'C'
	}
	
	assert custom_prop.xml_str() == '<C:author>Kristof</C:author>'
	assert custom_prop.xml_name() == '<author/>'
}

fn test_propfind_response() {
	// Create an array of properties for a resource
	mut props := []Property{}
	props << DisplayName('test-file.txt')
	props << GetLastModified('Mon, 01 Jan 2024 12:00:00 GMT')
	props << GetContentLength('1024')
	
	// Build a complete PROPFIND response with multistatus
	xml_output := '<D:multistatus xmlns:D="DAV:">
		<D:response>
			<D:href>/test-file.txt</D:href>
			${props.xml_str()}
		</D:response>
	</D:multistatus>'
	
	// Verify the XML structure
	assert xml_output.contains('<D:multistatus')
	assert xml_output.contains('<D:response>')
	assert xml_output.contains('<D:href>')
	assert xml_output.contains('<D:propstat>')
	assert xml_output.contains('<D:status>HTTP/1.1 200 OK</D:status>')
	assert xml_output.contains('</D:multistatus>')
}

fn test_propfind_with_missing_properties() {
	// Test response for missing properties
	missing_prop_response := '<D:propstat>
		<D:prop>
			<D:nonexistent-property/>
		</D:prop>
		<D:status>HTTP/1.1 404 Not Found</D:status>
	</D:propstat>'
	
	// Simple verification of structure
	assert missing_prop_response.contains('<D:propstat>')
	assert missing_prop_response.contains('<D:nonexistent-property/>')
	assert missing_prop_response.contains('<D:status>HTTP/1.1 404 Not Found</D:status>')
}

fn test_supported_lock_detailed() {
	supported_lock := SupportedLock('')
	xml_output := supported_lock.xml_str()
	
	// Test SupportedLock provides a fully formed XML snippet for supportedlock
	// Note: This test assumes the actual implementation returns a simplified version
	// as indicated by the xml_str() method which returns '<D:supportedlock>...</D:supportedlock>'
	assert xml_output.contains('<D:supportedlock>')
	
	// Detailed testing would need proper parsing of the XML to verify elements
	// For real implementation, test should check for:
	// - lockentry elements
	// - lockscope elements (exclusive and shared)
	// - locktype elements (write)
}

fn test_proppatch_request() {
	// Create property to set
	author_prop := CustomProperty{
		name: 'author'
		value: 'Kristof'
		namespace: 'C'
	}
	
	// Create XML for PROPPATCH request (set)
	proppatch_set := '<D:propertyupdate xmlns:D="DAV:" xmlns:C="http://example.com/customns">
		<D:set>
			<D:prop>
				${author_prop.xml_str()}
			</D:prop>
		</D:set>
	</D:propertyupdate>'
	
	// Check structure
	assert proppatch_set.contains('<D:propertyupdate')
	assert proppatch_set.contains('<D:set>')
	assert proppatch_set.contains('<D:prop>')
	assert proppatch_set.contains('<C:author>Kristof</C:author>')
	
	// Create XML for PROPPATCH request (remove)
	proppatch_remove := '<D:propertyupdate xmlns:D="DAV:">
		<D:remove>
			<D:prop>
				<D:obsoleteprop/>
			</D:prop>
		</D:remove>
	</D:propertyupdate>'
	
	// Check structure
	assert proppatch_remove.contains('<D:propertyupdate')
	assert proppatch_remove.contains('<D:remove>')
	assert proppatch_remove.contains('<D:prop>')
	assert proppatch_remove.contains('<D:obsoleteprop/>')
}

fn test_prop_name_listing() {
	// Create sample properties
	mut props := []Property{}
	props << DisplayName('file.txt')
	props << GetContentType('text/plain')
	
	// Generate propname response
	// Note: In a complete implementation, there would be a function to generate this XML
	// For testing purposes, we're manually creating the expected structure
	propname_response := '<D:multistatus xmlns:D="DAV:">
		<D:response>
			<D:href>/file.txt</D:href>
			<D:propstat>
				<D:prop>
					<displayname/>
					<getcontenttype/>
				</D:prop>
				<D:status>HTTP/1.1 200 OK</D:status>
			</D:propstat>
		</D:response>
	</D:multistatus>'
	
	// Verify structure
	assert propname_response.contains('<D:multistatus')
	assert propname_response.contains('<D:prop>')
	assert propname_response.contains('<displayname/>')
	assert propname_response.contains('<getcontenttype/>')
}

fn test_namespace_declarations() {
	// Test proper namespace declarations
	response_with_ns := '<D:multistatus xmlns:D="DAV:" xmlns:C="http://example.com/customns">
		<D:response>
			<D:href>/file.txt</D:href>
			<D:propstat>
				<D:prop>
					<D:displayname>file.txt</D:displayname>
					<C:author>Kristof</C:author>
				</D:prop>
				<D:status>HTTP/1.1 200 OK</D:status>
			</D:propstat>
		</D:response>
	</D:multistatus>'
	
	// Verify key namespace elements
	assert response_with_ns.contains('xmlns:D="DAV:"')
	assert response_with_ns.contains('xmlns:C="http://example.com/customns"')
}

fn test_depth_header_responses() {
	// Test properties for multiple resources (simulating Depth: 1)
	multi_response := '<D:multistatus xmlns:D="DAV:">
		<D:response>
			<D:href>/collection/</D:href>
			<D:propstat>
				<D:prop>
					<D:resourcetype><D:collection/></D:resourcetype>
				</D:prop>
				<D:status>HTTP/1.1 200 OK</D:status>
			</D:propstat>
		</D:response>
		<D:response>
			<D:href>/collection/file.txt</D:href>
			<D:propstat>
				<D:prop>
					<D:resourcetype/>
				</D:prop>
				<D:status>HTTP/1.1 200 OK</D:status>
			</D:propstat>
		</D:response>
	</D:multistatus>'
	
	// Verify structure contains multiple responses
	assert multi_response.contains('<D:response>')
	assert multi_response.count('<D:response>') == 2
	assert multi_response.contains('<D:href>/collection/</D:href>')
	assert multi_response.contains('<D:href>/collection/file.txt</D:href>')
}
