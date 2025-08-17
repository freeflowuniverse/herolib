module codewalker

import os
import freeflowuniverse.herolib.core.pathlib

fn test_parse_basic() {
	mut cw := new(CodeWalkerArgs{})!
	test_content := '===file1.txt===\nline1\nline2\n===END==='
	fm := cw.parse(test_content)!
	assert fm.content.len == 1
	assert fm.content['file1.txt'] == 'line1\nline2'
}

fn test_parse_multiple_files() {
	mut cw := new(CodeWalkerArgs{})!
	test_content := '===file1.txt===\nline1\n===file2.txt===\nlineA\nlineB\n===END==='
	fm := cw.parse(test_content)!
	assert fm.content.len == 2
	assert fm.content['file1.txt'] == 'line1'
	assert fm.content['file2.txt'] == 'lineA\nlineB'
}

fn test_parse_empty_file_block() {
	mut cw := new(CodeWalkerArgs{})!
	test_content := '===empty.txt===\n===END==='
	fm := cw.parse(test_content)!
	assert fm.content.len == 1
	assert fm.content['empty.txt'] == ''
}

fn test_parse_consecutive_end_and_file() {
	mut cw := new(CodeWalkerArgs{})!
	test_content := '===file1.txt===\ncontent1\n===END===\n===file2.txt===\ncontent2\n===END==='
	fm := cw.parse(test_content)!
	assert fm.content.len == 2
	assert fm.content['file1.txt'] == 'content1'
	assert fm.content['file2.txt'] == 'content2'
}

fn test_parse_content_before_first_file_block() {
	mut cw := new(CodeWalkerArgs{})!
	test_content := 'unexpected content\n===file1.txt===\ncontent\n===END==='
	// This should ideally log an error but still parse the file
	fm := cw.parse(test_content)!
	assert fm.content.len == 1
	assert fm.content['file1.txt'] == 'content'
	assert cw.errors.len > 0
	assert cw.errors[0].message.contains('Unexpected content before first file block')
}

fn test_parse_content_after_end() {
	mut cw := new(CodeWalkerArgs{})!
	test_content := '===file1.txt===\ncontent\n===END===\nmore unexpected content'
	// This should ideally log an error but still parse the file up to END
	fm := cw.parse(test_content)!
	assert fm.content.len == 1
	assert fm.content['file1.txt'] == 'content'
	assert cw.errors.len > 0
	assert cw.errors[0].message.contains('Unexpected content after ===END===')
}

fn test_parse_invalid_filename_line() {
	mut cw := new(CodeWalkerArgs{})!
	test_content := '=== ===\ncontent\n===END==='
	res := cw.parse(test_content)
	if res is error {
		assert res.msg.contains('Invalid filename, < 2 chars')
	} else {
		assert false // Should have errored
	}
}

fn test_parse_file_ending_without_end() {
	mut cw := new(CodeWalkerArgs{})!
	test_content := '===file1.txt===\nline1\nline2'
	fm := cw.parse(test_content)!
	assert fm.content.len == 1
	assert fm.content['file1.txt'] == 'line1\nline2'
}

fn test_parse_empty_content() {
	mut cw := new(CodeWalkerArgs{})!
	test_content := ''
	fm := cw.parse(test_content)!
	assert fm.content.len == 0
}

fn test_parse_only_end_at_start() {
	mut cw := new(CodeWalkerArgs{})!
	test_content := '===END==='
	res := cw.parse(test_content)
	if res is error {
		assert res.msg.contains('END found at start, not good.')
	} else {
		assert false // Should have errored
	}
}

fn test_parse_empty_block_between_files() {
	mut cw := new(CodeWalkerArgs{})!
	test_content := '===file1.txt===\ncontent1\n===file2.txt===\n===END===\n===file3.txt===\ncontent3\n===END==='
	fm := cw.parse(test_content)!
	assert fm.content.len == 3
	assert fm.content['file1.txt'] == 'content1'
	assert fm.content['file2.txt'] == ''
	assert fm.content['file3.txt'] == 'content3'
}

fn test_parse_multiple_empty_blocks() {
	mut cw := new(CodeWalkerArgs{})!
	test_content := '===file1.txt===\n===END===\n===file2.txt===\n===END===\n===file3.txt===\ncontent3\n===END==='
	fm := cw.parse(test_content)!
	assert fm.content.len == 3
	assert fm.content['file1.txt'] == ''
	assert fm.content['file2.txt'] == ''
	assert fm.content['file3.txt'] == 'content3'
}

fn test_parse_filename_end_reserved() {
	mut cw := new(CodeWalkerArgs{})!
	test_content := '===file1.txt===\ncontent1\n===END===\n===END===\ncontent2\n===END==='
	res := cw.parse(test_content)
	if res is error {
		assert res.msg.contains('Filename \'END\' is reserved.')
	} else {
		assert false // Should have errored
	}
}