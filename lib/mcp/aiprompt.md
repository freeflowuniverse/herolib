
make an mcp server in @lib/mcp/v_do

use the Standard Input/Output (stdio) transport as described in
https://modelcontextprotocol.io/docs/concepts/transports

The tool has following methods

## test 
- args: $fullpath
- cmd: 'v -gc none -stats -enable-globals -show-c-output -keepc -n -w -cg -o /tmp/tester.c -g -cc tcc test ${fullpath}' 

if the file is a dir then find the .v files (non recursive) and do it for each opf those

collect the output and return

## run
- args: $fullpath
- cmd: 'v -gc none -stats -enable-globals -n -w -cg -g -cc tcc run ${fullpath}' 

if the file is a dir then find the .v files (non recursive) and do it for each opf those

collect the output and return


## compile
- args: $fullpath
- cmd: 'cd /tmp && v -gc none -enable-globals -show-c-output -keepc -n -w -cg -o /tmp/tester.c -g -cc tcc ${fullpath}' 

if the file is a dir then find the .v files (non recursive) and do it for each opf those

collect the output and return


## vet
- args: $fullpath
- cmd: 'v vet -v -w ${fullpath}' 

if the file is a dir then find the .v files (non recursive) and do it for each opf those

collect the output and return



