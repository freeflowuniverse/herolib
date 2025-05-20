# Redisclient

Getting started:

```v
// Connect to Redis (recommended way)
import freeflowuniverse.herolib.core.base
mut context := base.context()!
mut redis := context.redis()!

// String commands
redis.set('mykey', 'hello')!
println(redis.get('mykey')!) // Output: hello
redis.del('mykey')!

// Hash commands
redis.hset('myhash', 'field1', 'value1')!
println(redis.hget('myhash', 'field1')!) // Output: value1
println(redis.hgetall('myhash')!) // Output: {'field1': 'value1', 'field2': 'value2'}
redis.hdel('myhash', 'field1')!

// List commands
redis.lpush('mylist', 'item1')!
redis.rpush('mylist', 'item2')!
println(redis.lrange('mylist', 0, -1)!) // Output: ['item1', 'item2']
println(redis.lpop('mylist')!) // Output: item1
println(redis.rpop('mylist')!) // Output: item2

// Set commands
redis.sadd('myset', ['member1', 'member2', 'member3'])!
println(redis.smismember('myset', ['member1', 'member4'])!) // Output: [1, 0]

// Key commands
redis.set('key1', 'value1')!
redis.set('key2', 'value2')!
println(redis.keys('*')!) // Output: ['key1', 'key2'] (order may vary)
redis.expire('key1', 10)! // Set expiry to 10 seconds

// Increment/Decrement commands
redis.set('counter', '10')!
println(redis.incr('counter')!) // Output: 11
println(redis.decrby('counter', 5)!) // Output: 6

// Append command
redis.set('mytext', 'hello')!
println(redis.append('mytext', ' world')!) // Output: 11 (length of new string)
println(redis.get('mytext')!) // Output: hello world

// Type command
println(redis.type_of('mykey')!) // Output: string (or none if key doesn't exist)

// Flush commands (use with caution!)
// redis.flushdb()! // Flushes the current database
// redis.flushall()! // Flushes all databases

```

## archive

### non recommended example to connect to local redis on 127.0.0.1:6379

```v

import freeflowuniverse.herolib.core.redisclient

mut redis := redisclient.core_get()!
redis.set('test', 'some data') or { panic('set' + err.str() + '\n' + c.str()) }
r := redis.get('test')?
if r != 'some data' {
    panic('get error different result.' + '\n' + c.str())
}

```

> redis commands can be found on https://redis.io/commands/
