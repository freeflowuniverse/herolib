# DedupeStore

DedupeStore is a content-addressable key-value store with built-in deduplication. It uses blake2b-160 content hashing to identify and deduplicate data, making it ideal for storing files or data blocks where the same content might appear multiple times.

## Features

- Content-based deduplication using blake2b-160 hashing
- Efficient storage using RadixTree for hash lookups
- Persistent storage using OurDB
- Maximum value size limit of 1MB
- Fast retrieval of data using content hash
- Automatic deduplication of identical content

## Usage

```v
import freeflowuniverse.herolib.data.dedupestor

fn main() ! {
    // Create a new dedupestore
    mut ds := dedupestor.new(
        path: 'path/to/store'
        reset: false // Set to true to reset existing data
    )!

    // Store some data
    data := 'Hello, World!'.bytes()
    hash := ds.store(data)!
    println('Stored data with hash: ${hash}')

    // Retrieve data using hash
    retrieved := ds.get(hash)!
    println('Retrieved data: ${retrieved.bytestr()}')

    // Check if data exists
    exists := ds.exists(hash)
    println('Data exists: ${exists}')

    // Attempting to store the same data again returns the same hash
    same_hash := ds.store(data)!
    assert hash == same_hash // True, data was deduplicated
}
```

## Implementation Details

DedupeStore uses two main components for storage:

1. **RadixTree**: Stores mappings from content hashes to data location IDs
2. **OurDB**: Stores the actual data blocks

When storing data:
1. The data is hashed using blake2b-160
2. If the hash exists in the RadixTree, the existing data location is returned
3. If the hash is new:
   - Data is stored in OurDB, getting a new location ID
   - Hash -> ID mapping is stored in RadixTree
   - The hash is returned

When retrieving data:
1. The RadixTree is queried with the hash to get the data location ID
2. The data is retrieved from OurDB using the ID

## Size Limits

- Maximum value size: 1MB
- Attempting to store larger values will result in an error

## Error Handling

The store methods return results that should be handled with V's error handling:

```v
// Handle potential errors
if hash := ds.store(large_data) {
    // Success
    println('Stored with hash: ${hash}')
} else {
    // Error occurred
    println('Error: ${err}')
}
```

## Testing

The module includes comprehensive tests covering:
- Basic store/retrieve operations
- Deduplication functionality
- Size limit enforcement
- Edge cases

Run tests with:
```bash
v test lib/data/dedupestor/
