import db.sqlite

fn main() {
	db := sqlite.connect(':memory:')!
	println('SQLite connection successful')
	db.close()!
}
