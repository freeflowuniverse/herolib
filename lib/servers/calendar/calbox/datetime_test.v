module calbox

fn test_format_datetime_utc() {
	// Test specific timestamp: 2024-02-16 10:00:00 UTC
	ts := i64(1708074000)
	formatted := format_datetime_utc(ts)
	assert formatted == '20240216T100000Z'

	// Test midnight
	midnight := i64(1708041600) // 2024-02-16 00:00:00 UTC
	midnight_formatted := format_datetime_utc(midnight)
	assert midnight_formatted == '20240216T000000Z'
}

fn test_format_date() {
	// Test specific date
	ts := i64(1708074000) // 2024-02-16 10:00:00 UTC
	formatted := format_date(ts)
	assert formatted == '20240216'

	// Time part should be ignored
	later := i64(1708117200) // 2024-02-16 22:00:00 UTC
	later_formatted := format_date(later)
	assert later_formatted == '20240216'
}

fn test_parse_datetime() {
	// Test UTC date-time
	ts := parse_datetime('20240216T100000Z')!
	assert ts == 1708074000

	// Test date-time without seconds
	no_seconds := parse_datetime('20240216T1000')!
	assert no_seconds == 1708074000

	// Test invalid formats
	if _ := parse_datetime('invalid') {
		assert false, 'Should reject invalid format'
	}
	if _ := parse_datetime('20240216') {
		assert false, 'Should reject date without time'
	}
	if _ := parse_datetime('20240216T') {
		assert false, 'Should reject incomplete time'
	}
}

fn test_parse_date() {
	// Test basic date
	ts := parse_date('20240216')!
	assert ts == 1708041600 // 2024-02-16 00:00:00 UTC

	// Test invalid formats
	if _ := parse_date('2024021') {
		assert false, 'Should reject too short date'
	}
	if _ := parse_date('202402166') {
		assert false, 'Should reject too long date'
	}
	if _ := parse_date('20240216T100000Z') {
		assert false, 'Should reject date-time format'
	}
}

fn test_parse_date_or_datetime() {
	// Test date format
	date_ts := parse_date_or_datetime('20240216')!
	assert date_ts == 1708041600 // 2024-02-16 00:00:00 UTC

	// Test date-time format
	datetime_ts := parse_date_or_datetime('20240216T100000Z')!
	assert datetime_ts == 1708074000 // 2024-02-16 10:00:00 UTC

	// Test invalid formats
	if _ := parse_date_or_datetime('invalid') {
		assert false, 'Should reject invalid format'
	}
}

fn test_format_date_or_datetime() {
	ts := i64(1708074000) // 2024-02-16 10:00:00 UTC

	// Test as date-time
	datetime := format_date_or_datetime(ts, true)
	assert datetime == '20240216T100000Z'

	// Test as date
	date := format_date_or_datetime(ts, false)
	assert date == '20240216'
}

fn test_roundtrip() {
	// Test date-time roundtrip
	original_ts := i64(1708074000)
	formatted := format_datetime_utc(original_ts)
	parsed_ts := parse_datetime(formatted)!
	assert parsed_ts == original_ts

	// Test date roundtrip
	date_formatted := format_date(original_ts)
	date_ts := parse_date(date_formatted)!
	assert date_ts == i64(1708041600) // Should be start of day
}
