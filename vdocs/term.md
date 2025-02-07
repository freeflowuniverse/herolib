# module term


## Contents
- [bg_black](#bg_black)
- [bg_blue](#bg_blue)
- [bg_cyan](#bg_cyan)
- [bg_green](#bg_green)
- [bg_hex](#bg_hex)
- [bg_magenta](#bg_magenta)
- [bg_red](#bg_red)
- [bg_rgb](#bg_rgb)
- [bg_white](#bg_white)
- [bg_yellow](#bg_yellow)
- [black](#black)
- [blue](#blue)
- [bold](#bold)
- [bright_bg_black](#bright_bg_black)
- [bright_bg_blue](#bright_bg_blue)
- [bright_bg_cyan](#bright_bg_cyan)
- [bright_bg_green](#bright_bg_green)
- [bright_bg_magenta](#bright_bg_magenta)
- [bright_bg_red](#bright_bg_red)
- [bright_bg_white](#bright_bg_white)
- [bright_bg_yellow](#bright_bg_yellow)
- [bright_black](#bright_black)
- [bright_blue](#bright_blue)
- [bright_cyan](#bright_cyan)
- [bright_green](#bright_green)
- [bright_magenta](#bright_magenta)
- [bright_red](#bright_red)
- [bright_white](#bright_white)
- [bright_yellow](#bright_yellow)
- [can_show_color_on_stderr](#can_show_color_on_stderr)
- [can_show_color_on_stdout](#can_show_color_on_stdout)
- [clear](#clear)
- [clear_previous_line](#clear_previous_line)
- [colorize](#colorize)
- [cursor_back](#cursor_back)
- [cursor_down](#cursor_down)
- [cursor_forward](#cursor_forward)
- [cursor_up](#cursor_up)
- [cyan](#cyan)
- [dim](#dim)
- [ecolorize](#ecolorize)
- [enable_echo](#enable_echo)
- [erase_clear](#erase_clear)
- [erase_del_clear](#erase_del_clear)
- [erase_display](#erase_display)
- [erase_line](#erase_line)
- [erase_line_clear](#erase_line_clear)
- [erase_line_tobeg](#erase_line_tobeg)
- [erase_line_toend](#erase_line_toend)
- [erase_tobeg](#erase_tobeg)
- [erase_toend](#erase_toend)
- [fail_message](#fail_message)
- [failed](#failed)
- [format](#format)
- [format_esc](#format_esc)
- [format_rgb](#format_rgb)
- [get_cursor_position](#get_cursor_position)
- [get_terminal_size](#get_terminal_size)
- [graphics_num_colors](#graphics_num_colors)
- [gray](#gray)
- [green](#green)
- [h_divider](#h_divider)
- [header](#header)
- [header_left](#header_left)
- [hex](#hex)
- [hidden](#hidden)
- [hide_cursor](#hide_cursor)
- [highlight_command](#highlight_command)
- [inverse](#inverse)
- [italic](#italic)
- [key_pressed](#key_pressed)
- [magenta](#magenta)
- [move](#move)
- [ok_message](#ok_message)
- [rapid_blink](#rapid_blink)
- [red](#red)
- [reset](#reset)
- [rgb](#rgb)
- [set_cursor_position](#set_cursor_position)
- [set_tab_title](#set_tab_title)
- [set_terminal_title](#set_terminal_title)
- [show_cursor](#show_cursor)
- [slow_blink](#slow_blink)
- [strikethrough](#strikethrough)
- [strip_ansi](#strip_ansi)
- [supports_sixel](#supports_sixel)
- [underline](#underline)
- [utf8_getchar](#utf8_getchar)
- [utf8_len](#utf8_len)
- [warn_message](#warn_message)
- [white](#white)
- [yellow](#yellow)
- [C.termios](#C.termios)
- [C.winsize](#C.winsize)
- [Coord](#Coord)
- [KeyPressedParams](#KeyPressedParams)

## bg_black
[[Return to contents]](#Contents)

## bg_blue
[[Return to contents]](#Contents)

## bg_cyan
[[Return to contents]](#Contents)

## bg_green
[[Return to contents]](#Contents)

## bg_hex
[[Return to contents]](#Contents)

## bg_magenta
[[Return to contents]](#Contents)

## bg_red
[[Return to contents]](#Contents)

## bg_rgb
[[Return to contents]](#Contents)

## bg_white
[[Return to contents]](#Contents)

## bg_yellow
[[Return to contents]](#Contents)

## black
[[Return to contents]](#Contents)

## blue
[[Return to contents]](#Contents)

## bold
[[Return to contents]](#Contents)

## bright_bg_black
[[Return to contents]](#Contents)

## bright_bg_blue
[[Return to contents]](#Contents)

## bright_bg_cyan
[[Return to contents]](#Contents)

## bright_bg_green
[[Return to contents]](#Contents)

## bright_bg_magenta
[[Return to contents]](#Contents)

## bright_bg_red
[[Return to contents]](#Contents)

## bright_bg_white
[[Return to contents]](#Contents)

## bright_bg_yellow
[[Return to contents]](#Contents)

## bright_black
[[Return to contents]](#Contents)

## bright_blue
[[Return to contents]](#Contents)

## bright_cyan
[[Return to contents]](#Contents)

## bright_green
[[Return to contents]](#Contents)

## bright_magenta
[[Return to contents]](#Contents)

## bright_red
[[Return to contents]](#Contents)

## bright_white
[[Return to contents]](#Contents)

## bright_yellow
[[Return to contents]](#Contents)

## can_show_color_on_stderr
[[Return to contents]](#Contents)

## can_show_color_on_stdout
[[Return to contents]](#Contents)

## clear
[[Return to contents]](#Contents)

## clear_previous_line
[[Return to contents]](#Contents)

## colorize
Example
```v

term.colorize(term.yellow, 'the message')

```

[[Return to contents]](#Contents)

## cursor_back
[[Return to contents]](#Contents)

## cursor_down
[[Return to contents]](#Contents)

## cursor_forward
[[Return to contents]](#Contents)

## cursor_up
[[Return to contents]](#Contents)

## cyan
[[Return to contents]](#Contents)

## dim
[[Return to contents]](#Contents)

## ecolorize
Example
```v

term.ecolorize(term.bright_red, 'the message')

```

[[Return to contents]](#Contents)

## enable_echo
[[Return to contents]](#Contents)

## erase_clear
[[Return to contents]](#Contents)

## erase_del_clear
[[Return to contents]](#Contents)

## erase_display
[[Return to contents]](#Contents)

## erase_line
[[Return to contents]](#Contents)

## erase_line_clear
[[Return to contents]](#Contents)

## erase_line_tobeg
[[Return to contents]](#Contents)

## erase_line_toend
[[Return to contents]](#Contents)

## erase_tobeg
[[Return to contents]](#Contents)

## erase_toend
[[Return to contents]](#Contents)

## fail_message
[[Return to contents]](#Contents)

## failed
[[Return to contents]](#Contents)

## format
[[Return to contents]](#Contents)

## format_esc
[[Return to contents]](#Contents)

## format_rgb
[[Return to contents]](#Contents)

## get_cursor_position
[[Return to contents]](#Contents)

## get_terminal_size
[[Return to contents]](#Contents)

## graphics_num_colors
[[Return to contents]](#Contents)

## gray
[[Return to contents]](#Contents)

## green
[[Return to contents]](#Contents)

## h_divider
[[Return to contents]](#Contents)

## header
[[Return to contents]](#Contents)

## header_left
[[Return to contents]](#Contents)

## hex
[[Return to contents]](#Contents)

## hidden
[[Return to contents]](#Contents)

## hide_cursor
[[Return to contents]](#Contents)

## highlight_command
[[Return to contents]](#Contents)

## inverse
[[Return to contents]](#Contents)

## italic
[[Return to contents]](#Contents)

## key_pressed
[[Return to contents]](#Contents)

## magenta
[[Return to contents]](#Contents)

## move
[[Return to contents]](#Contents)

## ok_message
[[Return to contents]](#Contents)

## rapid_blink
[[Return to contents]](#Contents)

## red
[[Return to contents]](#Contents)

## reset
[[Return to contents]](#Contents)

## rgb
[[Return to contents]](#Contents)

## set_cursor_position
[[Return to contents]](#Contents)

## set_tab_title
[[Return to contents]](#Contents)

## set_terminal_title
[[Return to contents]](#Contents)

## show_cursor
[[Return to contents]](#Contents)

## slow_blink
[[Return to contents]](#Contents)

## strikethrough
[[Return to contents]](#Contents)

## strip_ansi
[[Return to contents]](#Contents)

## supports_sixel
[[Return to contents]](#Contents)

## underline
[[Return to contents]](#Contents)

## utf8_getchar
[[Return to contents]](#Contents)

## utf8_len
[[Return to contents]](#Contents)

## warn_message
[[Return to contents]](#Contents)

## white
[[Return to contents]](#Contents)

## yellow
[[Return to contents]](#Contents)

## C.termios
[[Return to contents]](#Contents)

## C.winsize
[[Return to contents]](#Contents)

## Coord
[[Return to contents]](#Contents)

## KeyPressedParams
[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:55
