module calbox

// Represents a duration in seconds
pub struct Duration {
pub:
	seconds i64
}

// Parses an ISO 8601 duration string (e.g. PT1H30M)
pub fn parse_duration(iso_duration string) !Duration {
	if iso_duration.len < 2 || !iso_duration.starts_with('P') {
		return error('Invalid duration format: must start with P')
	}

	mut seconds := i64(0)
	mut number_str := ''
	mut time_part := false

	for i := 1; i < iso_duration.len; i++ {
		c := iso_duration[i]
		match c {
			`T` {
				if time_part {
					return error('Invalid duration format: duplicate T')
				}
				time_part = true
			}
			`0`...`9` {
				number_str += c.ascii_str()
			}
			`Y` {
				if time_part {
					return error('Invalid duration format: Y in time part')
				}
				if number_str == '' {
					return error('Invalid duration format: missing number before Y')
				}
				years := number_str.i64()
				seconds += years * 365 * 24 * 60 * 60 // Approximate
				number_str = ''
			}
			`M` {
				if number_str == '' {
					return error('Invalid duration format: missing number before M')
				}
				if time_part {
					// Minutes
					minutes := number_str.i64()
					seconds += minutes * 60
				} else {
					// Months
					months := number_str.i64()
					seconds += months * 30 * 24 * 60 * 60 // Approximate
				}
				number_str = ''
			}
			`W` {
				if time_part {
					return error('Invalid duration format: W in time part')
				}
				if number_str == '' {
					return error('Invalid duration format: missing number before W')
				}
				weeks := number_str.i64()
				seconds += weeks * 7 * 24 * 60 * 60
				number_str = ''
			}
			`D` {
				if time_part {
					return error('Invalid duration format: D in time part')
				}
				if number_str == '' {
					return error('Invalid duration format: missing number before D')
				}
				days := number_str.i64()
				seconds += days * 24 * 60 * 60
				number_str = ''
			}
			`H` {
				if !time_part {
					return error('Invalid duration format: H in date part')
				}
				if number_str == '' {
					return error('Invalid duration format: missing number before H')
				}
				hours := number_str.i64()
				seconds += hours * 60 * 60
				number_str = ''
			}
			`S` {
				if !time_part {
					return error('Invalid duration format: S in date part')
				}
				if number_str == '' {
					return error('Invalid duration format: missing number before S')
				}
				seconds += number_str.i64()
				number_str = ''
			}
			else {
				return error('Invalid duration format: unknown character ${c}')
			}
		}
	}

	if number_str != '' {
		return error('Invalid duration format: number without unit')
	}

	return Duration{seconds}
}

// Formats the duration as an ISO 8601 duration string
pub fn (d Duration) str() string {
	mut s := 'P'
	mut remaining := d.seconds

	// Years (approximate)
	years := remaining / (365 * 24 * 60 * 60)
	if years > 0 {
		s += '${years}Y'
		remaining = remaining % (365 * 24 * 60 * 60)
	}

	// Days
	days := remaining / (24 * 60 * 60)
	if days > 0 {
		s += '${days}D'
		remaining = remaining % (24 * 60 * 60)
	}

	// Time part (hours, minutes, seconds)
	if remaining > 0 {
		s += 'T'

		// Hours
		hours := remaining / (60 * 60)
		if hours > 0 {
			s += '${hours}H'
			remaining = remaining % (60 * 60)
		}

		// Minutes
		minutes := remaining / 60
		if minutes > 0 {
			s += '${minutes}M'
			remaining = remaining % 60
		}

		// Seconds
		if remaining > 0 {
			s += '${remaining}S'
		}
	}

	return s
}

// Adds the duration to a timestamp
pub fn (d Duration) add_to(timestamp i64) i64 {
	return timestamp + d.seconds
}

// Subtracts the duration from a timestamp
pub fn (d Duration) subtract_from(timestamp i64) i64 {
	return timestamp - d.seconds
}
