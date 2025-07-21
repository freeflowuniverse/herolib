module starlight

pub struct SiteError {
	Error
pub mut:
	path string
	msg  string
	cat  ErrorCat
}

pub enum ErrorCat {
	unknown
	image_double
	file_double
	file_not_found
	image_not_found
	page_double
	page_not_found
	sidebar
	circular_import
	def
	summary
	include
}
