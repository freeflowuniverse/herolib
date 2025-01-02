module osis

import os
import freeflowuniverse.herolib.core.pathlib
import db.sqlite
import db.pg

const db_dir = '${os.dir(@FILE)}/testdata/db'

fn testsuite_begin() {
	pathlib.get_dir(
		path: db_dir
		empty: true
	)!
}

fn testsuite_end() {
	mut dir := pathlib.get_dir(
		path: db_dir
		delete: true
	)!
}

fn db_path(db_name string) string {
	return '${db_dir}/${db_name}.db'
}

const pgconfig := pg.Config {
	dbname: 'default'
	user: 'admin'
	password: 'test'
}

fn test_new_indexer() ! {
	sqlite_db :=  sqlite.connect(db_path(@FN))!
	sqlite_indexer := new_indexer(sqlite_db: sqlite_db)!
	
	postgres_db := pg.connect(pgconfig)!
	postgres_indexer := new_indexer(postgres_db: postgres_db)!
}

fn test_reset() ! {
	reset(db_path(@FN))!
}

pub struct TestStruct {
	text string @[index]
	number int @[index]
}

fn test_indexer_new() ! {
	// sqlite_db :=  sqlite.connect(db_path(@FN))!
	// mut sqlite_indexer := new_indexer(sqlite_db: sqlite_db)!

	// sqlite_indexer.generic_new(TestStruct{
	// 	text: 'test_text'
	// 	number: 41
	// })!

	// mut list := sqlite_indexer.generic_list[TestStruct]()!
	// assert list.len == 1

	// sqlite_indexer.generic_new(TestStruct{
	// 	text: 'test_text2'
	// 	number: 42
	// })!

	// list = sqlite_indexer.generic_list[TestStruct]()!
	// assert list.len == 2

	// postgres
	postgres_db := pg.connect(pgconfig)!
	mut postgres_indexer := new_indexer(postgres_db: postgres_db)!

	postgres_indexer.generic_new(TestStruct{
		text: 'test_text'
		number: 41
	})!

	mut list := postgres_indexer.generic_list[TestStruct]()!
	assert list.len == 1

	postgres_indexer.generic_new(TestStruct{
		text: 'test_text2'
		number: 42
	})!

	list = postgres_indexer.generic_list[TestStruct]()!
	assert list.len == 2
}

pub struct TestStructFilter {
	text string
	number int
}

fn test_indexer_filter() ! {
	sqlite_db :=  sqlite.connect(db_path(@FN))!
	mut sqlite_indexer := new_indexer(sqlite_db: sqlite_db)!
	
	sqlite_indexer.generic_new(TestStruct{
		text: 'test_text'
		number: 41
	})!

	mut list := sqlite_indexer.generic_filter[TestStruct, TestStructFilter](
		TestStructFilter {
			text: 'test_tex'
		}
	)!
	assert list.len == 0

	list = sqlite_indexer.generic_filter[TestStruct, TestStructFilter](
		TestStructFilter {
			text: 'test_text'
		}
	)!

	list = sqlite_indexer.generic_filter[TestStruct, TestStructFilter](
		TestStructFilter {
			number: 40
		}
	)!
	assert list.len == 0

	list = sqlite_indexer.generic_filter[TestStruct, TestStructFilter](
		TestStructFilter {
			number: 41
		}
	)!
	assert list.len == 1
}