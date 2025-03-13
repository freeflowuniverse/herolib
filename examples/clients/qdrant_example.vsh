#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.clients.qdrant
import os
import flag

mut fp := flag.new_flag_parser(os.args)
fp.application('qdrant_example.vsh')
fp.version('v0.1.0')
fp.description('Example script demonstrating Qdrant client usage')
fp.skip_executable()

help_requested := fp.bool('help', `h`, false, 'Show help message')

if help_requested {
    println(fp.usage())
    exit(0)
}

additional_args := fp.finalize() or {
    eprintln(err)
    println(fp.usage())
    exit(1)
}

// Initialize Qdrant client
mut client := qdrant.get(name: 'default') or {
    // If client doesn't exist, create a new one
    mut new_client := qdrant.QdrantClient{
        name: 'default'
        url: 'http://localhost:6333'
    }
    qdrant.set(new_client) or {
        eprintln('Failed to set Qdrant client: ${err}')
        exit(1)
    }
    new_client
}

println('Connected to Qdrant at ${client.url}')

// Check if Qdrant is healthy
is_healthy := client.health_check() or {
    eprintln('Failed to check Qdrant health: ${err}')
    exit(1)
}

if !is_healthy {
    eprintln('Qdrant is not healthy')
    exit(1)
}

println('Qdrant is healthy')

// Get service info
service_info := client.get_service_info() or {
    eprintln('Failed to get service info: ${err}')
    exit(1)
}

println('Qdrant version: ${service_info.version}')

// Collection name for our example
collection_name := 'example_collection'

// Check if collection exists and delete it if it does
collections := client.list_collections() or {
    eprintln('Failed to list collections: ${err}')
    exit(1)
}

if collection_name in collections.result {
    println('Collection ${collection_name} already exists, deleting it...')
    client.delete_collection(collection_name: collection_name) or {
        eprintln('Failed to delete collection: ${err}')
        exit(1)
    }
    println('Collection deleted')
}

// Create a new collection
println('Creating collection ${collection_name}...')
vectors_config := qdrant.VectorsConfig{
    size: 4  // Small size for example purposes
    distance: .cosine
}

client.create_collection(
    collection_name: collection_name
    vectors: vectors_config
) or {
    eprintln('Failed to create collection: ${err}')
    exit(1)
}

println('Collection created')

// Upsert some points
println('Upserting points...')
points := [
    qdrant.PointStruct{
        id: '1'
        vector: [f32(0.1), 0.2, 0.3, 0.4]
        payload: {
            'color': 'red'
            'category': 'furniture'
            'name': 'chair'
        }
    },
    qdrant.PointStruct{
        id: '2'
        vector: [f32(0.2), 0.3, 0.4, 0.5]
        payload: {
            'color': 'blue'
            'category': 'electronics'
            'name': 'laptop'
        }
    },
    qdrant.PointStruct{
        id: '3'
        vector: [f32(0.3), 0.4, 0.5, 0.6]
        payload: {
            'color': 'green'
            'category': 'food'
            'name': 'apple'
        }
    }
]

client.upsert_points(
    collection_name: collection_name
    points: points
    wait: true
) or {
    eprintln('Failed to upsert points: ${err}')
    exit(1)
}

println('Points upserted')

// Get collection info to verify points were added
collection_info := client.get_collection(collection_name: collection_name) or {
    eprintln('Failed to get collection info: ${err}')
    exit(1)
}

println('Collection has ${collection_info.vectors_count} points')

// Search for points
println('Searching for points similar to [0.1, 0.2, 0.3, 0.4]...')
search_result := client.search(
    collection_name: collection_name
    vector: [f32(0.1), 0.2, 0.3, 0.4]
    limit: 3
) or {
    eprintln('Failed to search points: ${err}')
    exit(1)
}

println('Search results:')
for i, point in search_result.result {
    println('  ${i+1}. ID: ${point.id}, Score: ${point.score}')
    if payload := point.payload {
        println('     Name: ${payload['name']}')
        println('     Category: ${payload['category']}')
        println('     Color: ${payload['color']}')
    }
}

// Search with filter
println('\nSearching for points with category "electronics"...')
filter := qdrant.Filter{
    must: [
        qdrant.FieldCondition{
            key: 'category'
            match: 'electronics'
        }
    ]
}

filtered_search := client.search(
    collection_name: collection_name
    vector: [f32(0.1), 0.2, 0.3, 0.4]
    filter: filter
    limit: 3
) or {
    eprintln('Failed to search with filter: ${err}')
    exit(1)
}

println('Filtered search results:')
for i, point in filtered_search.result {
    println('  ${i+1}. ID: ${point.id}, Score: ${point.score}')
    if payload := point.payload {
        println('     Name: ${payload['name']}')
        println('     Category: ${payload['category']}')
        println('     Color: ${payload['color']}')
    }
}

// Clean up - delete the collection
println('\nCleaning up - deleting collection...')
client.delete_collection(collection_name: collection_name) or {
    eprintln('Failed to delete collection: ${err}')
    exit(1)
}

println('Collection deleted')
println('Example completed successfully')
