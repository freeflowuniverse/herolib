module calbox

import time

// Converts a timestamp to iCalendar UTC date-time format (YYYYMMDDTHHMMSSZ)
pub fn format_datetime_utc(ts i64) string {
	t := time.unix(ts)
	return t.strftime('%Y%m%dT%H%M%SZ')
}

// Converts a timestamp to iCalendar date format (YYYYMMDD)
pub fn format_date(ts i64) string {
	t := time.unix(ts)
	return t.strftime('%Y%m%d')
}

// Parses an iCalendar date-time string to timestamp
pub fn parse_datetime(dt string) !i64 {
	if dt.len < 8 {
		return error('Invalid date-time format')
	}

	// Parse date part (YYYYMMDD)
	year := dt[0..4].int()
	month := dt[4..6].int()
	day := dt[6..8].int()

	mut hour := 0
	mut min := 0
	mut sec := 0
	mut is_utc := false

	// Parse time part if present (THHMMSS[Z])
	if dt.len > 8 {
		if dt[8] != `T` {
			return error('Invalid date-time format: missing T separator')
		}
		if dt.len < 15 {
			return error('Invalid date-time format: incomplete time')
		}

		hour = dt[9..11].int()
		min = dt[11..13].int()
		sec = dt[13..15].int()

		is_utc = dt.ends_with('Z')
	}

	// Create time.Time
	mut t := time.new(
		year:   year
		month:  month
		day:    day
		hour:   hour
		minute: min
		second: sec
	)

	// Convert to UTC if needed
	if !is_utc {
		// TODO: Handle local time conversion
		// For now assume UTC
	}

	return t.unix()
}

// Parses an iCalendar date string to timestamp
pub fn parse_date(d string) !i64 {
	if d.len != 8 {
		return error('Invalid date format: must be YYYYMMDD')
	}

	year := d[0..4].int()
	month := d[4..6].int()
	day := d[6..8].int()

	t := time.new(
		year:   year
		month:  month
		day:    day
		hour:   0
		minute: 0
		second: 0
	)

	return t.unix()
}

// Parses a date or date-time string
pub fn parse_date_or_datetime(value string) !i64 {
	if value.contains('T') {
		return parse_datetime(value)!
	}
	return parse_date(value)!
}

// Formats a timestamp as either date or date-time based on has_time flag
pub fn format_date_or_datetime(ts i64, has_time bool) string {
	if has_time {
		return format_datetime_utc(ts)
	}
	return format_date(ts)
}
