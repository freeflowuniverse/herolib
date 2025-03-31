module aitools

import freeflowuniverse.herolib.clients.openai
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.core.pathlib
import json

pub fn convert_pug(mydir string)! {
	
	mut d:=pathlib.get_dir(path: mydir, create:false)!
	list := d.list(regex:[r'.*\.pug$'],include_links:false,files_only:true)!
	for item in list.paths{
		convert_pug_file(item.path)!
	}

}

// extract_template parses AI response content to extract just the template
fn extract_template(raw_content string) string {
	mut content := raw_content
	
	// First check for </think> tag
	if content.contains('</think>') {
		content = content.split('</think>')[1].trim_space()
	}
	
	// Look for ```jet code block
	if content.contains('```jet') {
		parts := content.split('```jet')
		if parts.len > 1 {
			end_parts := parts[1].split('```')
			if end_parts.len > 0 {
				content = end_parts[0].trim_space()
			}
		}
	} else if content.contains('```') {
		// If no ```jet, look for regular ``` code block
		parts := content.split('```')
		if parts.len >= 2 {
			// Take the content between the first set of ```
			// This handles both ```content``` and cases where there's only an opening ```
			content = parts[1].trim_space()
			
			// If we only see an opening ``` but no closing, cleanup any remaining backticks
			// to avoid incomplete formatting markers
			if !content.contains('```') {
				content = content.replace('`', '')
			}
		}
	}
	
	return content
}

pub fn convert_pug_file(myfile string)! {
	println(myfile)

	mut content_path := pathlib.get_file(path: myfile, create: false)!
	content := content_path.read()!

	mut l := loader()
	mut client := openai.get()!
	
	base_instruction := '
	You are a template language converter. You convert Pug templates to Jet templates.

	The target template language, Jet, is defined as follows:
	'

	base_user_prompt := '
	Convert this following Pug template to Jet:

	only output the resulting template, no explanation, no steps, just the jet template
	'

	// Create new file path by replacing .pug extension with .jet
	jet_file := myfile.replace('.pug', '.jet')
	
	// We'll retry up to 5 times if validation fails
	max_attempts := 5
	mut attempts := 0
	mut is_valid := false
	mut error_message := ''
	mut template := ''
	
	for attempts < max_attempts && !is_valid {
		attempts++
		
		mut system_content := texttools.dedent(base_instruction) + "\n" + l.jet()
		
		// Generate the user prompt based on whether this is initial attempt or retry
		mut user_prompt := ''
		
		if attempts == 1 {
			// First attempt - use original pug content
			user_prompt = texttools.dedent(base_user_prompt) + "\n" + content
			println('First attempt: Converting from Pug to Jet')
		} else {
			// Retry - focus on fixing the template errors
			println('Attempt ${attempts}: Retrying with error feedback')
			user_prompt = '
			The previous Jet template conversion had the following error:
			ERROR: ${error_message}
			
			Here was the template that had errors:
			```
			${template}
			```
			
			Please fix the template and try again. Return only the corrected Jet template.'
		}
module aitools

import freeflowuniverse.herolib.clients.openai
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.core.pathlib
import json

pub fn convert_pug(mydir string)! {
	
	mut d:=pathlib.get_dir(path: mydir, create:false)!
	list := d.list(regex:[r'.*\.pug$'],include_links:false,files_only:true)!
	for item in list.paths{
		convert_pug_file(item.path)!
	}

}

// extract_template parses AI response content to extract just the template
fn extract_template(raw_content string) string {
	mut content := raw_content
	
	// First check for </think> tag
	if content.contains('</think>') {
		content = content.split('</think>')[1].trim_space()
	}
	
	// Look for ```jet code block
	if content.contains('```jet') {
		parts := content.split('```jet')
		if parts.len > 1 {
			end_parts := parts[1].split('```')
			if end_parts.len > 0 {
				content = end_parts[0].trim_space()
			}
		}
	} else if content.contains('```') {
		// If no ```jet, look for regular ``` code block
		parts := content.split('```')
		if parts.len >= 2 {
			// Take the content between the first set of ```
			// This handles both ```content``` and cases where there's only an opening ```
			content = parts[1].trim_space()
			
			// If we only see an opening ``` but no closing, cleanup any remaining backticks
			// to avoid incomplete formatting markers
			if !content.contains('```') {
				content = content.replace('`', '')
			}
		}
	}
	
	return content
}

pub fn convert_pug_file(myfile string)! {
	println(myfile)

	mut content_path := pathlib.get_file(path: myfile, create: false)!
	content := content_path.read()!

	mut l := loader()
	mut client := openai.get()!
	
	base_instruction := '
	You are a template language converter. You convert Pug templates to Jet templates.

	The target template language, Jet, is defined as follows:
	'

	base_user_prompt := '
	Convert this following Pug template to Jet:

	only output the resulting template, no explanation, no steps, just the jet template
	'

	// Create new file path by replacing .pug extension with .jet
	jet_file := myfile.replace('.pug', '.jet')
	
	// We'll retry up to 5 times if validation fails
	max_attempts := 5
	mut attempts := 0
	mut is_valid := false
	mut error_message := ''
	mut template := ''
	
	for attempts < max_attempts && !is_valid {
		attempts++
		
module aitools

import freeflowuniverse.herolib.clients.openai
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.core.pathlib
import json

pub fn convert_pug(mydir string)! {
	
	mut d:=pathlib.get_dir(path: mydir, create:false)!
	list := d.list(regex:[r'.*\.pug$'],include_links:false,files_only:true)!
	for item in list.paths{
		convert_pug_file(item.path)!
	}

}

// extract_template parses AI response content to extract just the template
fn extract_template(raw_content string) string {
	mut content := raw_content
	
	// First check for </think> tag
	if content.contains('</think>') {
		content = content.split('</think>')[1].trim_space()
	}
	
	// Look for ```jet code block
	if content.contains('```jet') {
		parts := content.split('```jet')
		if parts.len > 1 {
			end_parts := parts[1].split('```')
			if end_parts.len > 0 {
				content = end_parts[0].trim_space()
			}
		}
	} else if content.contains('```') {
		// If no ```jet, look for regular ``` code block
		parts := content.split('```')
		if parts.len >= 2 {
			// Take the content between the first set of ```
			// This handles both ```content``` and cases where there's only an opening ```
			content = parts[1].trim_space()
			
			// If we only see an opening ``` but no closing, cleanup any remaining backticks
			// to avoid incomplete formatting markers
			if !content.contains('```') {
				content = content.replace('`', '')
			}
		}
	}
	
	return content
}

pub fn convert_pug_file(myfile string)! {
	println(myfile)

	mut content_path := pathlib.get_file(path: myfile, create: false)!
	content := content_path.read()!

	mut l := loader()
	mut client := openai.get()!
	
	base_instruction := '
	You are a template language converter. You convert Pug templates to Jet templates.

	The target template language, Jet, is defined as follows:
	'

	base_user_prompt := '
	Convert this following Pug template to Jet:

	only output the resulting template, no explanation, no steps, just the jet template
	'

	// Create new file path by replacing .pug extension with .jet
	jet_file := myfile.replace('.pug', '.jet')
	
	// We'll retry up to 5 times if validation fails
	max_attempts := 5
	mut attempts := 0
	mut is_valid := false
	mut error_message := ''
	mut template := ''
	
	for attempts < max_attempts && !is_valid {
		attempts++
		
		mut system_content := texttools.dedent(base_instruction) + "\n" + l.jet()
		mut user_prompt := texttools.dedent(base_user_prompt) + "\n" + content
		
		// If this is a retry, add the error information to the prompt
		if attempts > 1 {
			println('Attempt ${attempts}: Retrying with error feedback')
			user_prompt = '
			The previous template conversion had the following error:
			ERROR: ${error_message}
			
			Here was the template that had errors:
			```
			${template}
			```
			
			Please fix the template and try again. Return only the corrected template.
			' + user_prompt
		}
