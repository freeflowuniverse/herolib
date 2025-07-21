module tools

fn test_extract_title() {
	// Test case 1: Single H1 title
	page1 := '# My Awesome Document'
	assert extract_title(page1) == 'My Awesome Document'

	// Test case 2: Multiple titles, H1 first
	page2 := '
# Main Title
Some text here.
## Subtitle 1
More text.
### Sub-subtitle 1.1
'
	assert extract_title(page2) == 'Main Title'

	// Test case 3: No titles
	page3 := '
This is a plain document.
No markdown titles here.
'
	assert extract_title(page3) == ''

	// Test case 4: Title with leading/trailing spaces
	page4 := '  #   Another Title   '
	assert extract_title(page4) == 'Another Title'

	// Test case 5: Title with only hashes and spaces
	page5 := '###   '
	assert extract_title(page5) == ''

	// Test case 6: Title with content immediately after hashes
	page6 := '##TitleWithoutSpace'
	assert extract_title(page6) == 'TitleWithoutSpace'
}

fn test_set_titles() {
	// Test case 1: Default maxnr (3)
	page1 := '
# First Section
Some content.
## Subsection A
More content.
### Sub-subsection A.1
Even more content.
## Subsection B
### Sub-subsection B.1
#### Sub-subsection B.1.1 (should not be numbered)
'
	expected1 := '
# 1. First Section
Some content.
## 1.1. Subsection A
More content.
### 1.1.1. Sub-subsection A.1
Even more content.
## 1.2. Subsection B
### 1.2.1. Sub-subsection B.1
#### Sub-subsection B.1.1 (should not be numbered)
'
	assert set_titles(page1, 3) == expected1

	// Test case 2: maxnr = 2
	page2 := '
# Top Level
## Second Level
### Third Level (should not be numbered)
'
	expected2 := '
# 1. Top Level
## 1.1. Second Level
### Third Level (should not be numbered)
'
	assert set_titles(page2, 2) == expected2

	// Test case 3: No titles
	page3 := '
Plain text document.
No titles to renumber.
'
	expected3 := '
Plain text document.
No titles to renumber.
'
	assert set_titles(page3, 3) == expected3

	// Test case 4: Mixed content and reset of numbering
	page4 := '
# Chapter One
Text.
## Section 1.1
Text.
### Sub-section 1.1.1
Text.
# Chapter Two
Text.
## Section 2.1
Text.
'
	expected4 := '
# 1. Chapter One
Text.
## 1.1. Section 1.1
Text.
### 1.1.1. Sub-section 1.1.1
Text.
# 2. Chapter Two
Text.
## 2.1. Section 2.1
Text.
'
	assert set_titles(page4, 3) == expected4

	// Test case 5: Titles with existing numbers (should be overwritten)
	page5 := '
# 5. Old Chapter
## 1.2. Old Section
'
	expected5 := '
# 1. Old Chapter
## 1.1. Old Section
'
	assert set_titles(page5, 3) == expected5

	// Test case 6: First heading is H2, should be treated as H1
	page6 := '
## Core Architectural Principles
Some text.
### Sub-principle 1
### Sub-principle 2
## Core Architectural Principles 2
#### Sub-principle 44
'
	expected6 := '
# 1. Core Architectural Principles
Some text.
## 1.1. Sub-principle 1
## 1.2. Sub-principle 2
# 2. Core Architectural Principles 2
### 2.1.1. Sub-principle 44
'
	assert set_titles(page6, 3) == expected6

	// Test case 7: maxnr = 0, no numbering but still shift headings
	page7 := '
## Core Architectural Principles
Some text.
### Sub-principle 1
### Sub-principle 2
## Core Architectural Principles 2
#### Sub-principle 44
'
	expected7 := '
# Core Architectural Principles
Some text.
## Sub-principle 1
## Sub-principle 2
# Core Architectural Principles 2
### Sub-principle 44
'
	assert set_titles(page7, 0) == expected7
}
