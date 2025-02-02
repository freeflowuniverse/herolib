module location

pub struct Country {
pub:
	id          int    [primary]
	name        string [required]
	iso2        string [required; sql: 'iso2'; max_len: 2]
	iso3        string [required; sql: 'iso3'; max_len: 3]
	continent   string [max_len: 2]
	population  i64
	timezone    string [max_len: 40]
}

pub struct City {
pub:
	id             int     [primary]
	name           string  [required; max_len: 200]
	ascii_name     string  [required; max_len: 200] // Normalized name without special characters
	country_id     int     [required]
	admin1_code    string  [max_len: 20] // State/Province code
	latitude       f64
	longitude      f64
	population     i64
	timezone       string  [max_len: 40]
	feature_class  string  [max_len: 1] // For filtering (P for populated places)
	feature_code   string  [max_len: 10] // Detailed type (PPL, PPLA, etc.)
	search_priority int
}

pub struct AlternateName {
pub:
	id            int     [primary]
	city_id       int     [required]
	name          string  [required; max_len: 200]
	language_code string  [max_len: 2]
	is_preferred  bool
	is_short      bool
}

// SearchResult represents a location search result with combined city and country info
pub struct SearchResult {
pub:
	city          City
	country       Country
	similarity    f64    // Search similarity score
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
