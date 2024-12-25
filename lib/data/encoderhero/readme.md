# hero Encoder

> encoder hero is based on json2 from https://github.com/vlang/v/blob/master/vlib/x/json2/README.md

## Usage

#### encode[T]

```v
#!/usr/bin/env -S  v -n -cg -w -enable-globals run

import freeflowuniverse.herolib.data.encoderhero
import time

struct Person {
mut:
	name     string
	age      ?int = 20
	birthday time.Time
	deathday ?time.Time
}

mut person := Person{
    name: 'Bob'
    birthday: time.now()
}
heroscript := encoderhero.encode[Person](person)!

```

#### decode[T]

```v
import freeflowuniverse.herolib.data.encoderhero
import time

struct Person {
mut:
	name     string
	age      ?int = 20
	birthday time.Time
	deathday ?time.Time
}

data := '

'

person := encoderhero.decode[Person](data)!
/*
struct Person {
    mut:
        name "Bob"
        age  20
        birthday "2022-03-11 13:54:25"
    }
*/

```


## License

for all original code as used from Alexander:

// Copyright (c) 2019-2024 Alexander Medvednikov. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.

