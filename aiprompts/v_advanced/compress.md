The `compress` module in V provides low-level functionalities for compressing and decompressing byte arrays.

**Functions Overview (Low-Level):**

*   **`compress(data []u8, flags int) ![]u8`**: Compresses an array of bytes.
*   **`decompress(data []u8, flags int) ![]u8`**: Decompresses an array of bytes.
*   **`decompress_with_callback(data []u8, cb ChunkCallback, userdata voidptr, flags int) !u64`**: Decompresses byte arrays using a callback function for chunks.

**Type Definition (Low-Level):**

*   **`ChunkCallback`**: A function type `fn (chunk []u8, userdata voidptr) int` used to receive decompressed chunks.

---

**`compress.gzip` Module (High-Level Gzip Operations):**

For high-level gzip compression and decompression, use the `compress.gzip` module. This module provides a more convenient and recommended way to handle gzip operations compared to the low-level `compress` module.

**Key Features of `compress.gzip`:**

*   **`compress(data []u8, params CompressParams) ![]u8`**: Compresses data using gzip, allowing specification of `CompressParams` like `compression_level` (0-4095).
*   **`decompress(data []u8, params DecompressParams) ![]u8`**: Decompresses gzip-compressed data, allowing specification of `DecompressParams` for verification.
*   **`decompress_with_callback(data []u8, cb compr.ChunkCallback, userdata voidptr, params DecompressParams) !int`**: Decompresses gzip data with a callback for chunks, similar to the low-level version but for gzip streams.
*   **`validate(data []u8, params DecompressParams) !GzipHeader`**: Validates a gzip header and returns its details.

**Parameter Structures:**

*   **`CompressParams`**: Configures compression, primarily `compression_level` (0-4095).
*   **`DecompressParams`**: Configures decompression, including `verify_header_checksum`, `verify_length`, and `verify_checksum`.
*   **`GzipHeader`**: Represents the structure of a gzip header.

**Inline Code Example (Gzip Compression/Decompression):**

```v
import compress.gzip

data := 'Hello, Gzip!'
compressed := gzip.compress(data.bytes(), compression_level: 4095)!
decompressed := gzip.decompress(compressed)!

// Check if decompressed data matches original
// if data.bytes() == decompressed { ... }
```

**Important Note:** Always prefer `compress.gzip` for general gzip compression/decompression tasks over the low-level `compress` module.