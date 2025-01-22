module runpod

enum OperationType {
	query
	mutation
}

struct QueryBuilder {
pub mut:
	operation OperationType
	fields    []Field
	variables map[string]string
}

struct Field {
	name       string
	arguments  map[string]string
	sub_fields []Field
}

fn new_field(name string, args map[string]string, sub_fields []Field) Field {
	return Field{
		name:       name
		arguments:  args
		sub_fields: sub_fields
	}
}

fn build_arguments(args map[string]string) string {
	if args.len == 0 {
		return ''
	}

	mut sb := ''
	sb += '('

	for key, value in args {
		if value.len == 0 {
			continue
		}

		sb += '${key}: ${value}, '
	}

	return sb.trim_right(', ') + ')'
}

fn build_fields(fields []Field) string {
	mut sb := ' { '
	for field in fields {
		sb += field.name
		if field.arguments.len > 0 {
			sb += build_arguments(field.arguments)
		}

		if field.sub_fields.len > 0 {
			sb += build_fields(field.sub_fields)
		}

		sb += ' '
	}
	sb += ' } '
	return sb
}

fn (mut q QueryBuilder) add_operation(operation OperationType, fields []Field, variables map[string]string) {
	q.operation = operation
	q.fields = fields
	q.variables = variables.clone()
}

fn (q QueryBuilder) build_query() string {
	mut sb := ''
	sb += '${q.operation}' + ' myOperation'

	if q.variables.len > 0 {
		sb += build_arguments(q.variables)
	}

	sb += build_fields(q.fields)
	return sb
}
