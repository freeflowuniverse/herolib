#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run


import json

enum JobTitle {
    manager
    executive
    worker
}

struct Employee {
mut:
    name   string
    family string @[json: '-'] // this field will be skipped
    age    int
    salary f32
    title  JobTitle @[json: 'ETitle'] // the key for this field will be 'ETitle', not 'title'
    notes  string   @[omitempty]      // the JSON property is not created if the string is equal to '' (an empty string).
    // TODO: document @[raw]
}

x := Employee{'Peter', 'Begins', 28, 95000.5, .worker, ''}
println(x)
s := json.encode(x)
println('JSON encoding of employee x: ${s}')
assert s == '{"name":"Peter","age":28,"salary":95000.5,"ETitle":"worker"}'
mut y := json.decode(Employee, s)!
assert y != x
assert y.family == ''
y.family = 'Begins'
assert y == x
println(y)
ss := json.encode(y)
println('JSON encoding of employee y: ${ss}')
assert ss == s

