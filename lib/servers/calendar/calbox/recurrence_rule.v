module calbox

// Represents a recurrence rule
@[heap]
pub struct RecurrenceRule {
pub mut:
	frequency   RecurrenceFrequency
	interval    int  // How often the recurrence rule repeats
	count       ?int // Number of occurrences
	until       ?i64 // End date timestamp
	by_second   []int
	by_minute   []int
	by_hour     []int
	by_day      []string // MO, TU, WE, TH, FR, SA, SU with optional +/-prefix
	by_monthday []int
	by_yearday  []int
	by_weekno   []int
	by_month    []int
	by_setpos   []int
	week_start  string // MO, TU, WE, TH, FR, SA, SU
}

// Recurrence frequency types
pub enum RecurrenceFrequency {
	secondly
	minutely
	hourly
	daily
	weekly
	monthly
	yearly
}

// String representation of recurrence frequency
pub fn (f RecurrenceFrequency) str() string {
	return match f {
		.secondly { 'SECONDLY' }
		.minutely { 'MINUTELY' }
		.hourly { 'HOURLY' }
		.daily { 'DAILY' }
		.weekly { 'WEEKLY' }
		.monthly { 'MONTHLY' }
		.yearly { 'YEARLY' }
	}
}

// Parse recurrence frequency from string
pub fn parse_recurrence_frequency(s string) !RecurrenceFrequency {
	return match s {
		'SECONDLY' { RecurrenceFrequency.secondly }
		'MINUTELY' { RecurrenceFrequency.minutely }
		'HOURLY' { RecurrenceFrequency.hourly }
		'DAILY' { RecurrenceFrequency.daily }
		'WEEKLY' { RecurrenceFrequency.weekly }
		'MONTHLY' { RecurrenceFrequency.monthly }
		'YEARLY' { RecurrenceFrequency.yearly }
		else { error('Invalid recurrence frequency: ${s}') }
	}
}
