module location

pub struct Country {
pub:
	iso2        string @[index; max_len: 2; primary; sql: 'iso2'; unique]
	name        string @[index; required; unique]
	iso3        string @[index; max_len: 3; required; sql: 'iso3'; unique]
	continent   string @[max_len: 2]
	population  i64
	timezone    string @[max_len: 40]
	import_date i64 // Epoch timestamp of last import
}

pub struct City {
pub:
	id              int    @[index; unique]
	name            string @[index; max_len: 200; required]
	ascii_name      string @[index; max_len: 200; required] // Normalized name without special characters
	country_iso2    string @[fkey: 'Country.iso2'; required]
	postal_code     string @[index; max_len: 20] // postal code
	state_name      string @[max_len: 100]       // State/Province name
	state_code      string @[max_len: 20]        // State/Province code
	county_name     string @[max_len: 100]
	county_code     string @[max_len: 20]
	community_name  string @[max_len: 100]
	community_code  string @[max_len: 20]
	latitude        f64    @[index: 'idx_coords']
	longitude       f64    @[index: 'idx_coords']
	population      i64
	timezone        string @[max_len: 40]
	feature_class   string @[max_len: 1]  // For filtering (P for populated places)
	feature_code    string @[max_len: 10] // Detailed type (PPL, PPLA, etc.)
	search_priority int
	accuracy        i16 = 1 // 1=estimated, 4=geonameid, 6=centroid of addresses or shape
}

pub struct AlternateName {
pub:
	id            int    @[primary; sql: serial]
	city_id       int    @[fkey: 'City.id'; required]
	name          string @[index; max_len: 200; required]
	language_code string @[max_len: 2]
	is_preferred  bool
	is_short      bool
}

// SearchResult represents a location search result with combined city and country info
pub struct SearchResult {
pub:
	city       City
	country    Country
	similarity f64 // Search similarity score
}

// Coordinates represents a geographic point
pub struct Coordinates {
pub:
	latitude  f64
	longitude f64
}

// SearchOptions represents parameters for location searches
pub struct SearchOptions {
pub:
	query        string
	country_code string
	limit        int = 10
	fuzzy        bool
}

// CoordinateSearchOptions represents parameters for coordinate-based searches
pub struct CoordinateSearchOptions {
pub:
	coordinates Coordinates
	radius      f64 // in kilometers
	limit       int = 10
}
