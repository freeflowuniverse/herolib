# User Interface

```v
import freeflowuniverse.herolib.ui
import freeflowuniverse.herolib.ui.console

//today channeltype is not used, only console supported
mut myui:=ui.new()!

console.clear()

//ask_question(args QuestionArgs) string
myurl:=myui.ask_question(question:"what is the url to your repo")!


//..ask_dropdown(args DropDownArgs) int
mycolor:=myui.ask_dropdown(question:"what is the color you like",items:["red","green])!

//..ask_dropdown_multiple(args DropDownArgs) []string 
mycolors:=myui.ask_dropdown_multiple(question:"what is the colors you like",items:["red","green"])!

// will return the string as given as response
//..ask_dropdown_string(args DropDownArgs) string 


//..ask_yesno(args YesNoArgs) bool
ok2delete:=myui.ask_yesno(question:"are you sure?")!


// print with colors, reset...
//```
// 	foreground ForegroundColor
// 	background BackgroundColor
// 	text string
// 	style Style
// 	reset_before bool = true
// 	reset_after bool = true
//```
console.cprint(foreground=.yellow,style=.bold,text:"this is my happy text")


```

## parameters

see uimodel

## base capabilities

can be seen in section ```generic```

not all features are possible for all UI implementations, sometimes a redirect to a webserver might be needed e.g. edit a document when using telegram, probably means we need to send a link to a server where the editor is a javascript editor and then the result get saved at the backend.


## console colors

```v

enum ForegroundColor {
	default_color = 39
	white         = 97	
	black         = 30
	red           = 31
	green         = 32
	yellow        = 33
	blue          = 34
	magenta       = 35
	cyan          = 36
	light_gray    = 37
	dark_gray     = 90
	light_red     = 91
	light_green   = 92
	light_yellow  = 93
	light_blue    = 94
	light_magenta = 95
	light_cyan    = 96
}

enum BackgroundColor {
    default_color = 49 
    black         = 40
    red           = 41
    green         = 42
    yellow        = 43
    blue          = 44
    magenta       = 45
    cyan          = 46
    light_gray    = 47
    dark_gray     = 100
    light_red     = 101
    light_green   = 102
    light_yellow  = 103
    light_blue    = 104
    light_magenta = 105
    light_cyan    = 106
    white         = 107
}

enum Style {
	normal    = 99
    bold      = 1
    dim       = 2
    underline = 4
    blink     = 5
    reverse   = 7
    hidden    = 8
}

```