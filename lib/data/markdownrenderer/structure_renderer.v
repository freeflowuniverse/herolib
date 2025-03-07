module markdownrenderer

import markdown

import strings

// Helper functions to extract information from C structs
fn get_md_attribute_string(attr C.MD_ATTRIBUTE) ?string {
	unsafe {
		if attr.text == nil || attr.size == 0 {
			return none
		}
		return attr.text.vstring_with_len(int(attr.size))
	}
}

fn get_heading_level(detail voidptr) int {
	unsafe {
		h_detail := &C.MD_BLOCK_H_DETAIL(detail)
		return int(h_detail.level)
	}
}

fn get_code_language(detail voidptr) ?string {
	unsafe {
		code_detail := &C.MD_BLOCK_CODE_DETAIL(detail)
		return get_md_attribute_string(code_detail.lang)
	}
}

fn get_ul_details(detail voidptr) (bool, string) {
	unsafe {
		ul_detail := &C.MD_BLOCK_UL_DETAIL(detail)
		is_tight := ul_detail.is_tight != 0
		mark := ul_detail.mark.ascii_str()
		return is_tight, mark
	}
}

fn get_ol_details(detail voidptr) (int, bool) {
	unsafe {
		ol_detail := &C.MD_BLOCK_OL_DETAIL(detail)
		start := int(ol_detail.start)
		is_tight := ol_detail.is_tight != 0
		return start, is_tight
	}
}

fn get_link_details(detail voidptr) (?string, ?string) {
	unsafe {
		a_detail := &C.MD_SPAN_A_DETAIL(detail)
		href := get_md_attribute_string(a_detail.href)
		title := get_md_attribute_string(a_detail.title)
		return href, title
	}
}

fn get_image_details(detail voidptr) (?string, ?string) {
	unsafe {
		img_detail := &C.MD_SPAN_IMG_DETAIL(detail)
		src := get_md_attribute_string(img_detail.src)
		title := get_md_attribute_string(img_detail.title)
		return src, title
	}
}

fn get_wikilink_target(detail voidptr) ?string {
	unsafe {
		wl_detail := &C.MD_SPAN_WIKILINK_DETAIL(detail)
		return get_md_attribute_string(wl_detail.target)
	}
}

// StructureRenderer is a custom renderer that outputs the structure of a markdown document
pub struct StructureRenderer {
mut:
	writer strings.Builder = strings.new_builder(200)
	indent int            // Track indentation level for nested elements
}

pub fn (mut sr StructureRenderer) str() string {
	return sr.writer.str()
}

fn (mut sr StructureRenderer) enter_block(typ markdown.MD_BLOCKTYPE, detail voidptr) ? {
	// Add indentation based on current level
	sr.writer.write_string(strings.repeat(` `, sr.indent * 2))
	
	// Output the block type
	sr.writer.write_string('BLOCK[${typ}]: ')
	
	// Add specific details based on block type
	match typ {
		.md_block_h {
			level := get_heading_level(detail)
			sr.writer.write_string('Level ${level}')
		}
		.md_block_code {
			if lang := get_code_language(detail) {
				sr.writer.write_string('Language: ${lang}')
			} else {
				sr.writer.write_string('No language specified')
			}
		}
		.md_block_ul {
			is_tight, mark := get_ul_details(detail)
			sr.writer.write_string('Tight: ${is_tight}, Mark: ${mark}')
		}
		.md_block_ol {
			start, is_tight := get_ol_details(detail)
			sr.writer.write_string('Start: ${start}, Tight: ${is_tight}')
		}
		else {}
	}
	
	sr.writer.write_u8(`\n`)
	sr.indent++
}

fn (mut sr StructureRenderer) leave_block(typ markdown.MD_BLOCKTYPE, _ voidptr) ? {
	sr.indent--
}

fn (mut sr StructureRenderer) enter_span(typ markdown.MD_SPANTYPE, detail voidptr) ? {
	// Add indentation based on current level
	sr.writer.write_string(strings.repeat(` `, sr.indent * 2))
	
	// Output the span type
	sr.writer.write_string('SPAN[${typ}]: ')
	
	// Add specific details based on span type
	match typ {
		.md_span_a {
			href, title := get_link_details(detail)
			if href != none {
				sr.writer.write_string('Link: ${href}')
			}
			if title != none {
				sr.writer.write_string(', Title: ${title}')
			}
		}
		.md_span_img {
			src, title := get_image_details(detail)
			if src != none {
				sr.writer.write_string('Source: ${src}')
			}
			if title != none {
				sr.writer.write_string(', Title: ${title}')
			}
		}
		.md_span_wikilink {
			if target := get_wikilink_target(detail) {
				sr.writer.write_string('Target: ${target}')
			}
		}
		else {}
	}
	
	sr.writer.write_u8(`\n`)
	sr.indent++
}

fn (mut sr StructureRenderer) leave_span(typ markdown.MD_SPANTYPE, _ voidptr) ? {
	sr.indent--
}

fn (mut sr StructureRenderer) text(typ markdown.MD_TEXTTYPE, text string) ? {
	if text.trim_space() == '' {
		return
	}
	
	// Add indentation based on current level
	sr.writer.write_string(strings.repeat(` `, sr.indent * 2))
	
	// Output the text type
	sr.writer.write_string('TEXT[${typ}]: ')
	
	// Add the text content (truncate if too long)
	content := if text.len > 50 { text[..50] + '...' } else { text }
	sr.writer.write_string(content.replace('\n', '\\n'))
	
	sr.writer.write_u8(`\n`)
}

fn (mut sr StructureRenderer) debug_log(msg string) {
	println(msg)
}

// to_structure renders a markdown string and returns its structure
pub fn to_structure(input string) string {
	mut structure_renderer := StructureRenderer{}
	out := markdown.render(input, mut structure_renderer) or { '' }
	return out
}
