module calbox

@[params]
pub struct TimeRange {
pub mut:
	start i64 // UTC timestamp (epoch)
	end   i64 // UTC timestamp
}

// Checks if a timestamp falls within a time range
fn is_in_range(ts i64, tr TimeRange) bool {
	return ts >= tr.start && ts < tr.end
}
