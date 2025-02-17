module calbox

fn test_parse_duration() {
	// Test simple durations
	assert parse_duration('PT1H')!.seconds == 3600
	assert parse_duration('PT30M')!.seconds == 1800
	assert parse_duration('PT15S')!.seconds == 15

	// Test combined durations
	assert parse_duration('PT1H30M')!.seconds == 5400
	assert parse_duration('PT1H30M15S')!.seconds == 5415

	// Test days
	assert parse_duration('P1D')!.seconds == 86400
	assert parse_duration('P1DT12H')!.seconds == 129600

	// Test weeks
	assert parse_duration('P2W')!.seconds == 1209600

	// Test years (approximate)
	assert parse_duration('P1Y')!.seconds == 31536000

	// Test zero duration
	assert parse_duration('PT0S')!.seconds == 0

	// Test invalid formats
	if _ := parse_duration('invalid') {
		assert false, 'Should reject invalid format'
	}
	if _ := parse_duration('P') {
		assert false, 'Should reject empty duration'
	}
	if _ := parse_duration('PT1H30') {
		assert false, 'Should reject number without unit'
	}
	if _ := parse_duration('PT1HM') {
		assert false, 'Should reject missing number before unit'
	}
	if _ := parse_duration('P1H') {
		assert false, 'Should reject time unit in date part'
	}
	if _ := parse_duration('PT1D') {
		assert false, 'Should reject date unit in time part'
	}
}

fn test_duration_string() {
	// Test simple durations
	assert parse_duration('PT1H')!.str() == 'PT1H'
	assert parse_duration('PT30M')!.str() == 'PT30M'
	assert parse_duration('PT15S')!.str() == 'PT15S'

	// Test combined durations
	assert parse_duration('PT1H30M')!.str() == 'PT1H30M'
	assert parse_duration('PT1H30M15S')!.str() == 'PT1H30M15S'

	// Test days
	assert parse_duration('P1D')!.str() == 'P1D'
	assert parse_duration('P1DT12H')!.str() == 'P1DT12H'

	// Test normalization
	d := parse_duration('PT90M')!
	assert d.str() == 'PT1H30M' // 90 minutes normalized to 1 hour 30 minutes

	// Test zero duration
	assert parse_duration('PT0S')!.str() == 'P'
}

fn test_duration_arithmetic() {
	// Base timestamp: 2024-02-16 10:00:00 UTC
	base_ts := i64(1708074000)

	// Test addition
	one_hour := parse_duration('PT1H')!
	assert one_hour.add_to(base_ts) == base_ts + 3600

	// Test subtraction
	assert one_hour.subtract_from(base_ts) == base_ts - 3600

	// Test complex duration
	complex := parse_duration('P1DT2H30M')!
	expected := base_ts + (24 * 3600) + (2 * 3600) + (30 * 60)
	assert complex.add_to(base_ts) == expected
}

fn test_duration_edge_cases() {
	// Test very large durations
	large := parse_duration('P100Y')!
	assert large.seconds == i64(100 * 365 * 24 * 60 * 60)

	// Test combined date and time
	mixed := parse_duration('P1Y2DT3H4M5S')!
	assert mixed.str() == 'P1Y2DT3H4M5S'

	// Test months (approximate)
	with_months := parse_duration('P2M')!
	assert with_months.seconds == i64(2 * 30 * 24 * 60 * 60)
}
