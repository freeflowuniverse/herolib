

# **ORM**

V has a powerful, concise ORM baked in! Create tables, insert records, manage relationships, all regardless of the DB driver you decide to use.


## **Nullable**

For a nullable column, use an option field. If the field is non-option, the column will be defined with `NOT NULL` at table creation.


```
struct Foo {
    notnull  string
    nullable ?string
}
```

## **Attributes**


### **Structs**



* `[table: 'name']` explicitly sets the name of the table for the struct


### **Fields**



* `[primary]` sets the field as the primary key
* `[unique]` gives the field a `UNIQUE` constraint
* `[unique: 'foo']` adds the field to a `UNIQUE` group
* `[skip]` or `[sql: '-']` field will be skipped
* `[sql: type]` where `type` is a V type such as `int` or `f64`
* `[serial]` or `[sql: serial]` lets the DB backend choose a column type for an auto-increment field
* `[sql: 'name']` sets a custom column name for the field
* `[sql_type: 'SQL TYPE']` explicitly sets the type in SQL
* `[default: 'raw_sql']` inserts `raw_sql` verbatim in a "DEFAULT" clause whencreating a new table, allowing for SQL functions like `CURRENT_TIME`. For raw strings, surround `raw_sql` with backticks (`).
* `[fkey: 'parent_id']` sets foreign key for an field which holds an array


## **Usage**


    [!NOTE] > For using the Function Call API for `orm`, please check <code>[Function Call API](https://modules.vlang.io/orm.html#function-call-api)</code>.

Here are a couple example structs showing most of the features outlined above.


```
import time

@[table: 'foos']
struct Foo {
    id          int         @[primary; sql: serial]
    name        string
    created_at  time.Time   @[default: 'CURRENT_TIME']
    updated_at  ?string     @[sql_type: 'TIMESTAMP']
    deleted_at  ?time.Time
    children    []Child     @[fkey: 'parent_id']
}

struct Child {
    id        int    @[primary; sql: serial]
    parent_id int
    name      string
}
```


To use the ORM, there is a special interface that lets you use the structs and V itself in queries. This interface takes the database instance as an argument.


```
import db.sqlite

db := sqlite.connect(':memory:')!

sql db {
    // query; see below
}!
```


When you need to reference the table, simply pass the struct itself.


```
import models.Foo

struct Bar {
    id int @[primary; sql: serial]
}

sql db {
    create table models.Foo
    create table Bar
}!
```



### **Create & Drop Tables**

You can create and drop tables by passing the struct to `create table` and `drop table`.


```
import models.Foo

struct Bar {
    id int @[primary; sql: serial]
}

sql db {
    create table models.Foo
    drop table Bar
}!
```



### **Insert Records**

To insert a record, create a struct and pass the variable to the query. Again, reference the struct as the table.


```
foo := Foo{
    name:       'abc'
    created_at: time.now()
    // updated_at defaults to none
    // deleted_at defaults to none
    children: [
        Child{
            name: 'abc'
        },
        Child{
            name: 'def'
        },
    ]
}

foo_id := sql db {
    insert foo into Foo
}!
```


If the `id` field is marked as `sql: serial` and `primary`, the insert expression returns the database ID of the newly added object. Getting an ID of a newly added DB row is often useful.

When inserting, `[sql: serial]` fields, and fields with a `[default: 'raw_sql']` attribute, are not sent to the database when the value being sent is the default for the V struct field (e.g., 0 int, or an empty string). This allows the database to insert default values for auto-increment fields and where you have specified a default.


### **Select**

You can select rows from the database by passing the struct as the table, and use V syntax and functions for expressions. Selecting returns an array of the results.


```
result := sql db {
    select from Foo where id == 1
}!

foo := result.first()
result := sql db {
    select from Foo where id > 1 && name != 'lasanha' limit 5
}!
result := sql db {
    select from Foo where id > 1 order by id
}!
```



### **Update**

You can update fields in a row using V syntax and functions. Again, pass the struct as the table.


```
sql db {
    update Foo set updated_at = time.now() where name == 'abc' && updated_at is none
}!
```


Note that `is none` and `!is none` can be used to select for NULL fields.


### **Delete**

You can delete rows using V syntax and functions. Again, pass the struct as the table.


```
sql db {
    delete from Foo where id > 10
}!
```



### **time.Time Fields**

It's definitely useful to cast a field as `time.Time` so you can use V's built-in time functions; however, this is handled a bit differently than expected in the ORM. `time.Time` fields are created as integer columns in the database. Because of this, the usual time functions (`current_timestamp`, `NOW()`, etc) in SQL do not work as defaults.


## **Example**


```
import db.pg

struct Member {
    id         string @[default: 'gen_random_uuid()'; primary; sql_type: 'uuid']
    name       string
    created_at string @[default: 'CURRENT_TIMESTAMP'; sql_type: 'TIMESTAMP']
}

fn main() {
    db := pg.connect(pg.Config{
        host: 'localhost'
        port: 5432
        user: 'user'
        password: 'password'
        dbname: 'dbname'
    })!

    defer {
        db.close()
    }

    sql db {
        create table Member
    }!

    new_member := Member{
        name: 'John Doe'
    }

    sql db {
        insert new_member into Member
    }!

    selected_members := sql db {
        select from Member where name == 'John Doe' limit 1
    }!
    john_doe := selected_members.first()

    sql db {
        update Member set name = 'Hitalo' where id == john_doe.id
    }!
}
```



## **Function Call API**

You can utilize the `Function Call API` to work with `ORM`. It provides the capability to dynamically construct SQL statements. The Function Call API supports common operations such as `Create Table`/`Drop Table`/`Insert`/`Delete`/`Update`/`Select`, and offers convenient yet powerful features for constructing `WHERE` clauses, `SET` clauses, `SELECT` clauses, and more.

A complete example is available [here](https://github.com/vlang/v/blob/master/vlib/orm/orm_func_test.v).

Below, we illustrate its usage through several examples.

​​1. Define your struct​​ with the same method definitions as before:


```
@[table: 'sys_users']
struct User {
    id      int      @[primary;serial]
    name    string
    age     int
    role    string
    status  int
    salary  int
    title   string
    score   int
    created_at ?time.Time @[sql_type: 'TIMESTAMP']
}
```


​​2. Create a database connection​​:


```
   mut db := sqlite.connect(':memory:')!
    defer { db.close() or {} }

```



1. Create a `QueryBuilder`​​ (which also completes struct mapping):


```
   mut qb := orm.new_query[User](db)

```



1. Create a database table​​:


```
   qb.create()!

```



1. Insert multiple records​​ into the table:


```
   qb.insert_many(users)!

```



1. Delete records​​ (note: `delete()` must follow `where()`):


```
   qb.where('name = ?','John')!.delete()!

```



1. Query records​​ (you can specify fields of interest via `select`):


```
// Returns []User with only 'name' populated; other fields are zero values.
    only_names := qb.select('name')!.query()!

```



1. Update records​​ (note: `update()` must be placed last):


```
   qb.set('age = ?, title = ?', 71, 'boss')!.where('name = ?','John')!.update()!

```



1. Drop the table​​:


```
   qb.drop()!

```



1. Chainable method calls​​: Most Function Call API support chainable calls, allowing easy method chaining:


```
   final_users :=
    qb
        .drop()!
        .create()!
        .insert_many(users)!
        .set('name = ?', 'haha')!.where('name = ?', 'Tom')!.update()!
        .where('age >= ?', 30)!.delete()!
        .query()!

```



1. Writing complex nested `WHERE` clauses​​: The API includes a built-in parser to handle intricate `WHERE` clause conditions. For example:


```
   where('created_at IS NULL && ((salary > ? && age < ?) || (role LIKE ?))', 2000, 30, '%employee%')!
```


Note the use of placeholders `?`. The conditional expressions support logical operators including `AND`, `OR`, `||`, and `&&`.


## Constants [#](https://modules.vlang.io/orm.html#Constants)


## fn new_query [#](https://modules.vlang.io/orm.html#new_query)

new_query create a new query object for struct `T`


## fn orm_select_gen [#](https://modules.vlang.io/orm.html#orm_select_gen)

Generates an sql select stmt, from universal parameter orm - See SelectConfig q, num, qm, start_pos - see orm_stmt_gen where - See QueryData


## fn orm_stmt_gen [#](https://modules.vlang.io/orm.html#orm_stmt_gen)

Generates an sql stmt, from universal parameter q - The quotes character, which can be different in every type, so it's variable num - Stmt uses nums at prepared statements (? or ?1) qm - Character for prepared statement (qm for question mark, as in sqlite) start_pos - When num is true, it's the start position of the counter


## fn orm_table_gen [#](https://modules.vlang.io/orm.html#orm_table_gen)

Generates an sql table stmt, from universal parameter table - Table struct q - see orm_stmt_gen defaults - enables default values in stmt def_unique_len - sets default unique length for texts fields - See TableField sql_from_v - Function which maps type indices to sql type names alternative - Needed for msdb


## interface Connection [#](https://modules.vlang.io/orm.html#Connection)

Interfaces gets called from the backend and can be implemented Since the orm supports arrays aswell, they have to be returned too. A row is represented as []Primitive, where the data is connected to the fields of the struct by their index. The indices are mapped with the SelectConfig.field array. This is the mapping for a struct. To have an array, there has to be an array of structs, basically [][]Primitive

Every function without last_id() returns an optional, which returns an error if present last_id returns the last inserted id of the db


## type Primitive [#](https://modules.vlang.io/orm.html#Primitive)


## fn (QueryBuilder[T]) reset [#](https://modules.vlang.io/orm.html#QueryBuilder[T].reset)

reset reset a query object, but keep the connection and table name


## fn (QueryBuilder[T]) where [#](https://modules.vlang.io/orm.html#QueryBuilder[T].where)

where create a `where` clause, it will `AND` with previous `where` clause. valid token in the `condition` include: `field's names`, `operator`, `(`, `)`, `?`, `AND`, `OR`, `||`, `&&`, valid `operator` incldue: `=`, `!=`, `&lt;>`, `>=`, `&lt;=`, `>`, `&lt;`, `LIKE`, `ILIKE`, `IS NULL`, `IS NOT NULL`, `IN`, `NOT IN` example: `where('(a > ? AND b &lt;= ?) OR (c &lt;> ? AND (x = ? OR y = ?))', a, b, c, x, y)`


## fn (QueryBuilder[T]) or_where [#](https://modules.vlang.io/orm.html#QueryBuilder[T].or_where)

or_where create a `where` clause, it will `OR` with previous `where` clause.


## fn (QueryBuilder[T]) order [#](https://modules.vlang.io/orm.html#QueryBuilder[T].order)

order create a `order` clause


## fn (QueryBuilder[T]) limit [#](https://modules.vlang.io/orm.html#QueryBuilder[T].limit)

limit create a `limit` clause


## fn (QueryBuilder[T]) offset [#](https://modules.vlang.io/orm.html#QueryBuilder[T].offset)

offset create a `offset` clause


## fn (QueryBuilder[T]) select [#](https://modules.vlang.io/orm.html#QueryBuilder[T].select)

select create a `select` clause


## fn (QueryBuilder[T]) set [#](https://modules.vlang.io/orm.html#QueryBuilder[T].set)

set create a `set` clause for `update`


## fn (QueryBuilder[T]) query [#](https://modules.vlang.io/orm.html#QueryBuilder[T].query)

query start a query and return result in struct `T`


## fn (QueryBuilder[T]) count [#](https://modules.vlang.io/orm.html#QueryBuilder[T].count)

count start a count query and return result


## fn (QueryBuilder[T]) insert [#](https://modules.vlang.io/orm.html#QueryBuilder[T].insert)

insert insert a record into the database


## fn (QueryBuilder[T]) insert_many [#](https://modules.vlang.io/orm.html#QueryBuilder[T].insert_many)

insert_many insert records into the database


## fn (QueryBuilder[T]) update [#](https://modules.vlang.io/orm.html#QueryBuilder[T].update)

update update record(s) in the database


## fn (QueryBuilder[T]) delete [#](https://modules.vlang.io/orm.html#QueryBuilder[T].delete)

delete delete record(s) in the database


## fn (QueryBuilder[T]) create [#](https://modules.vlang.io/orm.html#QueryBuilder[T].create)

create create a table


## fn (QueryBuilder[T]) drop [#](https://modules.vlang.io/orm.html#QueryBuilder[T].drop)

drop drop a table


## fn (QueryBuilder[T]) last_id [#](https://modules.vlang.io/orm.html#QueryBuilder[T].last_id)

last_id returns the last inserted id of the db


## enum MathOperationKind [#](https://modules.vlang.io/orm.html#MathOperationKind)


## enum OperationKind [#](https://modules.vlang.io/orm.html#OperationKind)


## enum OrderType [#](https://modules.vlang.io/orm.html#OrderType)


## enum SQLDialect [#](https://modules.vlang.io/orm.html#SQLDialect)


## enum StmtKind [#](https://modules.vlang.io/orm.html#StmtKind)


## struct InfixType [#](https://modules.vlang.io/orm.html#InfixType)


## struct Null [#](https://modules.vlang.io/orm.html#Null)


## struct QueryBuilder [#](https://modules.vlang.io/orm.html#QueryBuilder)


```
@[heap]
```



## struct QueryData [#](https://modules.vlang.io/orm.html#QueryData)

Examples for QueryData in SQL: abc == 3 && b == 'test' => fields[abc, b]; data[3, 'test']; types[index of int, index of string]; kinds[.eq, .eq]; is_and[true]; Every field, data, type & kind of operation in the expr share the same index in the arrays is_and defines how they're addicted to each other either and or or parentheses defines which fields will be inside () auto_fields are indexes of fields where db should generate a value when absent in an insert


## struct SelectConfig [#](https://modules.vlang.io/orm.html#SelectConfig)

table - Table struct is_count - Either the data will be returned or an integer with the count has_where - Select all or use a where expr has_order - Order the results order - Name of the column which will be ordered order_type - Type of order (asc, desc) has_limit - Limits the output data primary - Name of the primary field has_offset - Add an offset to the result fields - Fields to select types - Types to select


## struct Table [#](https://modules.vlang.io/orm.html#Table)


## struct TableField [#](https://modules.vlang.io/orm.html#TableField)
