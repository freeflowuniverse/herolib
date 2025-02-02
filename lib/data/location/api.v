module location

// Location represents the main API for location operations
pub struct Location {
mut:
	db LocationDB
}

// new creates a new Location instance
pub fn new() !Location {
	db := new_location_db()!
	return Location{
		db: db
	}
}

// init_database downloads and imports the initial dataset
pub fn (mut l Location) init_database() ! {
	l.db.download_and_import_data()!
}

// search searches for locations based on the provided options
pub fn (l Location) search(query string, country_code string, limit int, fuzzy bool) ![]SearchResult {
	opts := SearchOptions{
		query: query
		country_code: country_code
		limit: limit
		fuzzy: fuzzy
	}
	return l.db.search_locations(opts)
}

// search_near searches for locations near the given coordinates
pub fn (l Location) search_near(lat f64, lon f64, radius f64, limit int) ![]SearchResult {
	opts := CoordinateSearchOptions{
		coordinates: Coordinates{
			latitude: lat
			longitude: lon
		}
		radius: radius
		limit: limit
	}
	return l.db.search_by_coordinates(opts)
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
