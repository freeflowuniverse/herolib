# tus Resumable Upload Protocol (Condensed for Coding Agents)

## Core Protocol

All Clients and Servers MUST implement the core protocol for resumable uploads.

### Resuming an Upload

1.  **Determine Offset (HEAD Request):**
    *   **Request:**
        ```
        HEAD /files/{upload_id} HTTP/1.1
        Host: tus.example.org
        Tus-Resumable: 1.0.0
        ```
    *   **Response:**
        ```
        HTTP/1.1 200 OK
        Upload-Offset: {current_offset}
        Tus-Resumable: 1.0.0
        ```
        *   Server MUST include `Upload-Offset`.
        *   Server MUST include `Upload-Length` if known.
        *   Server SHOULD return `200 OK` or `204 No Content`.
        *   Server MUST prevent caching: `Cache-Control: no-store`.

2.  **Resume Upload (PATCH Request):**
    *   **Request:**
        ```
        PATCH /files/{upload_id} HTTP/1.1
        Host: tus.example.org
        Content-Type: application/offset+octet-stream
        Content-Length: {chunk_size}
        Upload-Offset: {current_offset}
        Tus-Resumable: 1.0.0

        [binary data chunk]
        ```
    *   **Response:**
        ```
        HTTP/1.1 204 No Content
        Tus-Resumable: 1.0.0
        Upload-Offset: {new_offset}
        ```
        *   `Content-Type` MUST be `application/offset+octet-stream`.
        *   `Upload-Offset` in request MUST match server's current offset (else `409 Conflict`).
        *   Server MUST acknowledge with `204 No Content` and `Upload-Offset` (new offset).
        *   Server SHOULD return `404 Not Found` for non-existent resources.

### Common Headers

*   **`Upload-Offset`**: Non-negative integer. Byte offset within resource.
*   **`Upload-Length`**: Non-negative integer. Total size of upload in bytes.
*   **`Tus-Version`**: Comma-separated list of supported protocol versions (Server response).
*   **`Tus-Resumable`**: Protocol version used (e.g., `1.0.0`). MUST be in every request/response (except `OPTIONS`). If client version unsupported, server responds `412 Precondition Failed` with `Tus-Version`.
*   **`Tus-Extension`**: Comma-separated list of supported extensions (Server response). Omitted if none.
*   **`Tus-Max-Size`**: Non-negative integer. Max allowed upload size in bytes (Server response).
*   **`X-HTTP-Method-Override`**: String. Client MAY use to override HTTP method (e.g., for `PATCH`/`DELETE` limitations).

### Server Configuration (OPTIONS Request)

*   **Request:**
    ```
    OPTIONS /files HTTP/1.1
    Host: tus.example.org
    ```
*   **Response:**
    ```
    HTTP/1.1 204 No Content
    Tus-Resumable: 1.0.0
    Tus-Version: 1.0.0,0.2.2,0.2.1
    Tus-Max-Size: 1073741824
    Tus-Extension: creation,expiration
    ```
    *   Response MUST contain `Tus-Version`. MAY include `Tus-Extension` and `Tus-Max-Size`.
    *   Client SHOULD NOT include `Tus-Resumable` in request.

## Protocol Extensions

Clients SHOULD use `OPTIONS` request and `Tus-Extension` header for feature detection.

### Creation (`creation` extension)

Create a new upload resource. Server MUST add `creation` to `Tus-Extension`.

*   **Request (POST):**
    ```
    POST /files HTTP/1.1
    Host: tus.example.org
    Content-Length: 0
    Upload-Length: {total_size} OR Upload-Defer-Length: 1
    Tus-Resumable: 1.0.0
    Upload-Metadata: filename {base64_filename},is_confidential
    ```
    *   MUST include `Upload-Length` or `Upload-Defer-Length: 1`.
    *   If `Upload-Defer-Length: 1`, client MUST set `Upload-Length` in subsequent `PATCH`.
    *   `Upload-Length: 0` creates an immediately complete empty file.
    *   Client MAY supply `Upload-Metadata` (key-value pairs, value Base64 encoded).
    *   If `Upload-Length` exceeds `Tus-Max-Size`, server responds `413 Request Entity Too Large`.
*   **Response:**
    ```
    HTTP/1.1 201 Created
    Location: {upload_url}
    Tus-Resumable: 1.0.0
    ```
    *   Server MUST respond `201 Created` and set `Location` header to new resource URL.
    *   New resource has implicit offset `0`.

#### Headers

*   **`Upload-Defer-Length`**: `1`. Indicates upload size is unknown. Server adds `creation-defer-length` to `Tus-Extension` if supported.
*   **`Upload-Metadata`**: Comma-separated `key value` pairs. Key: no spaces/commas, ASCII. Value: Base64 encoded.

### Creation With Upload (`creation-with-upload` extension)

Include initial upload data in the `POST` request. Server MUST add `creation-with-upload` to `Tus-Extension`. Depends on `creation` extension.

*   **Request (POST):**
    ```
    POST /files HTTP/1.1
    Host: tus.example.org
    Content-Length: {initial_chunk_size}
    Upload-Length: {total_size}
    Tus-Resumable: 1.0.0
    Content-Type: application/offset+octet-stream
    Expect: 100-continue

    [initial binary data chunk]
    ```
    *   Similar rules as `PATCH` apply for content.
    *   Client SHOULD include `Expect: 100-continue`.
*   **Response:**
    ```
    HTTP/1.1 201 Created
    Location: {upload_url}
    Tus-Resumable: 1.0.0
    Upload-Offset: {accepted_offset}
    ```
    *   Server MUST include `Upload-Offset` with accepted bytes.

### Expiration (`expiration` extension)

Server MAY remove unfinished uploads. Server MUST add `expiration` to `Tus-Extension`.

*   **Response (PATCH/POST):**
    ```
    HTTP/1.1 204 No Content
    Upload-Expires: Wed, 25 Jun 2014 16:00:00 GMT
    Tus-Resumable: 1.0.0
    Upload-Offset: {new_offset}
    ```
*   **`Upload-Expires`**: Datetime in RFC 9110 format. Indicates when upload expires. Client SHOULD use to check validity. Server SHOULD respond `404 Not Found` or `410 Gone` for expired uploads.

### Checksum (`checksum` extension)

Verify data integrity of `PATCH` requests. Server MUST add `checksum` to `Tus-Extension`. Server MUST support `sha1`.

*   **Request (PATCH):**
    ```
    PATCH /files/{upload_id} HTTP/1.1
    Content-Length: {chunk_size}
    Upload-Offset: {current_offset}
    Tus-Resumable: 1.0.0
    Upload-Checksum: {algorithm} {base64_checksum}

    [binary data chunk]
    ```
*   **Response:**
    *   `204 No Content`: Checksums match.
    *   `400 Bad Request`: Algorithm not supported.
    *   `460 Checksum Mismatch`: Checksums mismatch.
    *   In `400`/`460` cases, chunk MUST be discarded, upload/offset NOT updated.
*   **`Tus-Checksum-Algorithm`**: Comma-separated list of supported algorithms (Server response to `OPTIONS`).
*   **`Upload-Checksum`**: `{algorithm} {Base64_encoded_checksum}`.

### Termination (`termination` extension)

Client can terminate uploads. Server MUST add `termination` to `Tus-Extension`.

*   **Request (DELETE):**
    ```
    DELETE /files/{upload_id} HTTP/1.1
    Host: tus.example.org
    Content-Length: 0
    Tus-Resumable: 1.0.0
    ```
*   **Response:**
    ```
    HTTP/1.1 204 No Content
    Tus-Resumable: 1.0.0
    ```
    *   Server SHOULD free resources, MUST respond `204 No Content`.
    *   Future requests to URL SHOULD return `404 Not Found` or `410 Gone`.

### Concatenation (`concatenation` extension)

Concatenate multiple partial uploads into a single final upload. Server MUST add `concatenation` to `Tus-Extension`.

*   **Partial Upload Creation (POST):**
    ```
    POST /files HTTP/1.1
    Upload-Concat: partial
    Upload-Length: {partial_size}
    Tus-Resumable: 1.0.0
    ```
    *   `Upload-Concat: partial` header.
    *   Server SHOULD NOT process partial uploads until concatenated.
*   **Final Upload Creation (POST):**
    ```
    POST /files HTTP/1.1
    Upload-Concat: final;{url_partial1} {url_partial2} ...
    Tus-Resumable: 1.0.0
    ```
    *   `Upload-Concat: final;{space-separated_partial_urls}`.
    *   Client MUST NOT include `Upload-Length`.
    *   Final upload length is sum of partials.
    *   Server MAY delete partials after concatenation.
    *   Server MUST respond `403 Forbidden` to `PATCH` requests against final upload.
*   **`concatenation-unfinished`**: Server adds to `Tus-Extension` if it supports concatenation while partial uploads are in progress.
*   **HEAD Request for Final Upload:**
    *   Response SHOULD NOT contain `Upload-Offset` unless concatenation finished.
    *   After success, `Upload-Offset` and `Upload-Length` MUST be equal.
    *   Response MUST include `Upload-Concat` header.
*   **HEAD Request for Partial Upload:**
    *   Response MUST contain `Upload-Offset`.