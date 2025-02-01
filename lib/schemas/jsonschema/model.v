module jsonschema

import x.json2 as json {Any}

pub type Items = SchemaRef | []SchemaRef

pub type SchemaRef = Reference | Schema

pub struct Reference {
pub:
	ref string @[json: '\$ref'; omitempty]
}

pub type Number = int

// https://json-schema.org/draft-07/json-schema-release-notes.html
pub struct Schema {
pub mut:
    schema                string               @[json: 'schema'; omitempty]
    id                    string               @[json: 'id'; omitempty]
    title                 string               @[omitempty]
    description           string               @[omitempty]
    typ                   string               @[json: 'type'; omitempty]
    properties            map[string]SchemaRef @[omitempty]
    additional_properties ?SchemaRef            @[json: 'additionalProperties'; omitempty]
    required              []string             @[omitempty]
    items                 ?Items                @[omitempty]
    defs                  map[string]SchemaRef @[omitempty]
    one_of                []SchemaRef          @[json: 'oneOf'; omitempty]
    format                string               @[omitempty]
    // Validation for numbers
    multiple_of           int                  @[json: 'multipleOf'; omitempty]
    maximum               int                  @[omitempty]
    exclusive_maximum     int                  @[json: 'exclusiveMaximum'; omitempty]
    minimum               int                  @[omitempty]
    exclusive_minimum     int                  @[json: 'exclusiveMinimum'; omitempty]
    enum_                 []string             @[json: 'enum'; omitempty]
    example Any @[json: '-']
}