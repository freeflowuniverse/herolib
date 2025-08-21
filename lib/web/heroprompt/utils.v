module heroprompt

import strings

// Very small template renderer using {{.var}} replacement
pub fn render_template(tpl string, data map[string]string) string {
	mut out := tpl
	for k, v in data {
		out = out.replace('{{.' + k + '}}', v)
	}
	return out
}

// Minimal HTML escape
pub fn html_escape(s string) string {
	mut b := strings.new_builder(s.len)
	for ch in s {
		match ch {
			`&` { b.write_string('&amp;') }
			`<` { b.write_string('&lt;') }
			`>` { b.write_string('&gt;') }
			`"` { b.write_string('&quot;') }
			`'` { b.write_string('&#39;') }
			else { b.write_string(ch.str()) }
		}
	}
	return b.str()
}
