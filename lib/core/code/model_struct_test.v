module code

fn test_parse_struct() {
	// Test case 1: struct with comments and pub fields
	struct_str := '// TestResult is a struct for test results
// It contains information about test execution
pub struct TestResult {
pub:
	success bool
	message string
	code int
}
'
	result := parse_struct(struct_str) or {
		assert false, 'Failed to parse struct: ${err}'
		Struct{}
	}

	assert result.name == 'TestResult'
	assert result.description == 'TestResult is a struct for test results
It contains information about test execution'
	assert result.is_pub == true
	assert result.fields.len == 3
	
	assert result.fields[0].name == 'success'
	assert result.fields[0].typ.symbol() == 'bool'
	assert result.fields[0].is_pub == true
	assert result.fields[0].is_mut == false
	
	assert result.fields[1].name == 'message'
	assert result.fields[1].typ.symbol() == 'string'
	assert result.fields[1].is_pub == true
	assert result.fields[1].is_mut == false
	
	assert result.fields[2].name == 'code'
	assert result.fields[2].typ.symbol() == 'int'
	assert result.fields[2].is_pub == true
	assert result.fields[2].is_mut == false

	// Test case 2: struct without comments and with mixed visibility
	struct_str2 := 'struct SimpleStruct {
pub:
	name string
mut:
	count int
	active bool
}
'
	result2 := parse_struct(struct_str2) or {
		assert false, 'Failed to parse struct: ${err}'
		Struct{}
	}

	assert result2.name == 'SimpleStruct'
	assert result2.description == ''
	assert result2.is_pub == false
	assert result2.fields.len == 3
	
	assert result2.fields[0].name == 'name'
	assert result2.fields[0].typ.symbol() == 'string'
	assert result2.fields[0].is_pub == true
	assert result2.fields[0].is_mut == false
	
	assert result2.fields[1].name == 'count'
	assert result2.fields[1].typ.symbol() == 'int'
	assert result2.fields[1].is_pub == false
	assert result2.fields[1].is_mut == true
	
	assert result2.fields[2].name == 'active'
	assert result2.fields[2].typ.symbol() == 'bool'
	assert result2.fields[2].is_pub == false
	assert result2.fields[2].is_mut == true
}
