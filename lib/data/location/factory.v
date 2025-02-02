module location

// Location represents the main API for location operations
pub struct Location {
mut:
	db LocationDB
}

// new creates a new Location instance
pub fn new(reset bool) !Location {
	db := new_location_db(reset)!
	return Location{
		db: db
	}
}

// init_database downloads and imports the initial dataset
pub fn (mut l Location) download_and_import() ! {
	l.db.download_and_import_data()!
}

// Example usage:
/*
fn main() ! {
	// Create a new location instance
	mut loc := location.new()!

	// Initialize the database (downloads and imports data)
	// Only needs to be done once or when updating data
	loc.init_database()!

	// Search for a city
	results := loc.search('London', 'GB', 5, true)!
	for result in results {
		println('${result.city.name}, ${result.country.name} (${result.country.iso2})')
		println('Coordinates: ${result.city.latitude}, ${result.city.longitude}')
	}

	// Search near coordinates (e.g., 10km radius from London)
	nearby := loc.search_near(51.5074, -0.1278, 10.0, 5)!
	for result in nearby {
		println('${result.city.name} is nearby')
	}
}
*/
