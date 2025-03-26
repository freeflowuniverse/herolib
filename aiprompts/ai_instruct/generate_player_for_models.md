generate specs for /Users/despiegk/code/github/freeflowuniverse/herolib/lib/circles/actions

use mcp

get the output of it un actions/specs.v

then use these specs.v

to generate play command instructions see @3_heroscript_vlang.md 

this play command gets heroscript in and will then call the methods for actions as are ONLY in @lib/circles/actions/db 

so the play only calls the methods in @lib/circles/actions/db 


# put the play commands in

/Users/despiegk/code/github/freeflowuniverse/herolib/lib/circles/actions/play

do one file in the module per action

each method is an action

put them all on one Struct called Player
in this Player we have a method per action

Player has a property called actor: which is the name of the actor as is used in the heroscript
Player has also a output called return format which is enum for heroscript or json

input of the method - action is a params object

on player there is a method play which takes the text as input or playbook

if text then playbook is created

then we walk over all actions

all the ones starting with actions in this case are given to the right method

