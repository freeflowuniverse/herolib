module texttools

fn test_main() {
	assert name_fix_keepext('\$sds__ 4F') == 'sds_4f'
	assert name_fix_keepext('\$sds_?__ 4F') == 'sds_4f'
	assert name_fix_keepext('\$sds_?_!"`{_ 4F') == 'sds_4f'
	assert name_fix_keepext('\$sds_?_!"`{_ 4F.jpg') == 'sds_4f.jpg'
}

fn test_path_fix() {
	// Test empty path
	assert path_fix('') == ''
	
	// Test absolute paths
	assert path_fix('/home/user') == '/home/user'
	assert path_fix('/home/USER') == '/home/user'
	assert path_fix('/home/user/Documents') == '/home/user/documents'
	
	// Test relative paths
	assert path_fix('home/user') == 'home/user'
	assert path_fix('./home/user') == './home/user'
	assert path_fix('../home/user') == '../home/user'
	
	// Test paths with special characters
	assert path_fix('/home/user/My Documents') == '/home/user/my_documents'
	assert path_fix('/home/user/file-name.txt') == '/home/user/file_name.txt'
	assert path_fix('/home/user/file name with spaces.txt') == '/home/user/file_name_with_spaces.txt'
	
	// Test paths with multiple special characters
	assert path_fix('/home/user/!@#$%^&*()_+.txt') == '/home/user/'
	
	// Test paths with multiple components and extensions
	assert path_fix('/home/user/Documents/report.pdf') == '/home/user/documents/report.pdf'
	assert path_fix('/home/user/Documents/report.PDF') == '/home/user/documents/report.pdf'
	
	// Test paths with multiple slashes
	assert path_fix('/home//user///documents') == '/home/user/documents'
}
