module jsonschema


// Define numeric schemas
const schema_u8 = Schema{
    typ: "integer"
    format: 'uint8'
    minimum: 0
    maximum: 255
    description: "An unsigned 8-bit integer."
}

const schema_i8 = Schema{
    typ: "integer"
    format: 'int8'
    minimum: -128
    maximum: 127
    description: "A signed 8-bit integer."
}

const schema_u16 = Schema{
    typ: "integer"
    format: 'uint16'
    minimum: 0
    maximum: 65535
    description: "An unsigned 16-bit integer."
}

const schema_i16 = Schema{
    typ: "integer"
    format: 'int16'
    minimum: -32768
    maximum: 32767
    description: "A signed 16-bit integer."
}

const schema_u32 = Schema{
    typ: "integer"
    format: 'uint32'
    minimum: 0
    maximum: 4294967295
    description: "An unsigned 32-bit integer."
}

const schema_i32 = Schema{
    typ: "integer"
    format: 'int32'
    minimum: -2147483648
    maximum: 2147483647
    description: "A signed 32-bit integer."
}

const schema_u64 = Schema{
    typ: "integer"
    format: 'uint64'
    minimum: 0
    maximum: 18446744073709551615
    description: "An unsigned 64-bit integer."
}

const schema_i64 = Schema{
    typ: "integer"
    format: 'int64'
    minimum: -9223372036854775808
    maximum: 9223372036854775807
    description: "A signed 64-bit integer."
}

const schema_f32 = Schema{
    typ: "number"
    description: "A 32-bit floating-point number."
}

const schema_f64 = Schema{
    typ: "number"
    description: "A 64-bit floating-point number."
}