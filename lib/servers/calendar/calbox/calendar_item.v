module calbox

// Represents a calendar object resource (event, todo, journal)
@[heap]
pub struct CalendarItem {
pub mut:
	comp_type ComponentType // Type of calendar component : vevent, vtodo, vjournal
	event     ?Event        // Set if comp_type is .vevent
	todo      ?Todo         // Set if comp_type is .vtodo
	journal   ?Journal      // Set if comp_type is .vjournal
}

// Component type enum
pub enum ComponentType {
	vevent
	vtodo
	vjournal
}
