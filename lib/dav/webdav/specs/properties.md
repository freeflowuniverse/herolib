# WebDAV Properties Specification

WebDAV (Web Distributed Authoring and Versioning) extends HTTP to allow remote web content authoring operations. One of its most important features is **property management**, which allows clients to retrieve, set, and delete metadata (called "properties") on resources.

---

## Relevant RFCs

- RFC 4918 - HTTP Extensions for Web Distributed Authoring and Versioning (WebDAV)
- RFC 2518 - Original WebDAV specification (obsolete)

---

## Property Concepts

### What is a Property?

- A **property** is metadata associated with a WebDAV resource, such as a file or directory.
- Properties are identified by **qualified names** in the form of `{namespace}propertyname`.
- Property values are represented in XML.

---

## Property Value Types

- XML-based values (text or structured XML)
- Unicode text
- Either **live** (managed by the server) or **dead** (set by clients)

---

## Live vs Dead Properties

| Type    | Description                               | Managed By |
|---------|-------------------------------------------|------------|
| Live    | Server-defined and maintained             | Server     |
| Dead    | Arbitrary client-defined metadata         | Client     |

Examples of live properties include `getlastmodified`, `resourcetype`, and `displayname`.

---

## PROPFIND - Retrieving Properties

**Method**: PROPFIND  
**Purpose**: Retrieve properties from a resource.

### Depth Header

| Value      | Meaning                          |
|------------|----------------------------------|
| 0          | The resource itself              |
| 1          | Resource and its immediate children |
| infinity   | Resource and all descendants     |

### Request Body Examples

#### All Properties

```xml
<propfind xmlns="DAV:">
  <allprop/>
</propfind>
```

#### Specific Properties

```xml
<propfind xmlns="DAV:">
  <prop>
    <displayname/>
    <getlastmodified/>
  </prop>
</propfind>
```

#### Property Names Only

```xml
<propfind xmlns="DAV:">
  <propname/>
</propfind>
```

### Example Response

```xml
<multistatus xmlns="DAV:">
  <response>
    <href>/file.txt</href>
    <propstat>
      <prop>
        <displayname>file.txt</displayname>
        <getlastmodified>Fri, 28 Mar 2025 09:00:00 GMT</getlastmodified>
      </prop>
      <status>HTTP/1.1 200 OK</status>
    </propstat>
  </response>
</multistatus>
```

---

## PROPPATCH - Setting or Removing Properties

**Method**: PROPPATCH  
**Purpose**: Set or remove one or more properties.

### Example Request

```xml
<propertyupdate xmlns="DAV:">
  <set>
    <prop>
      <author>Kristof</author>
    </prop>
  </set>
  <remove>
    <prop>
      <obsoleteprop/>
    </prop>
  </remove>
</propertyupdate>
```

### Example Response

```xml
<multistatus xmlns="DAV:">
  <response>
    <href>/file.txt</href>
    <propstat>
      <prop>
        <author/>
      </prop>
      <status>HTTP/1.1 200 OK</status>
    </propstat>
    <propstat>
      <prop>
        <obsoleteprop/>
      </prop>
      <status>HTTP/1.1 200 OK</status>
    </propstat>
  </response>
</multistatus>
```

---

## Common Live Properties

| Property Name       | Namespace | Description                        |
|---------------------|-----------|------------------------------------|
| getcontentlength     | DAV:      | Size in bytes                      |
| getcontenttype       | DAV:      | MIME type                          |
| getetag              | DAV:      | Entity tag (ETag)                  |
| getlastmodified      | DAV:      | Last modification time             |
| creationdate         | DAV:      | Resource creation time             |
| resourcetype         | DAV:      | Type of resource (file, collection)|
| displayname          | DAV:      | Human-friendly name                |

---

## Custom Properties

Clients can define their own custom properties as XML with custom namespaces.

Example:

```xml
<project xmlns="http://example.com/customns">Phoenix</project>
```

---

## Namespaces

WebDAV uses XML namespaces to avoid naming conflicts.

Example:

```xml
<prop xmlns:D="DAV:" xmlns:C="http://example.com/customns">
  <C:author>Kristof</C:author>
</prop>
```

---

## Other Related Methods

- `MKCOL`: Create a new collection (directory)
- `DELETE`: Remove a resource and its properties
- `COPY` and `MOVE`: Properties are copied/moved along with resources

---

## Security Considerations

- Clients need authorization to read or write properties.
- Live properties may not be writable.
- Dead property values must be stored and returned exactly as set.

---

## Complete Example Workflow

1. Retrieve all properties:

```http
PROPFIND /doc.txt HTTP/1.1
Depth: 0
```

2. Set a custom property:

```http
PROPPATCH /doc.txt HTTP/1.1
Content-Type: application/xml
```

```xml
<propertyupdate xmlns="DAV:">
  <set>
    <prop>
      <project xmlns="http://example.org/ns">Phoenix</project>
    </prop>
  </set>
</propertyupdate>
```

