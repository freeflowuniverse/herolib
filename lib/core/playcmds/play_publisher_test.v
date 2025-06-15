module playcmds

import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.core.playcmds
import freeflowuniverse.herolib.core.pathlib
import os

fn test_play_publisher() {
	mut p := pathlib.get_file(path: '/tmp/heroscript/do.hero', create: true)!

	s2 := "

!!publisher.new_collection
	url:'https://git.threefold.info/tfgrid/info_tfgrid/src/branch/main/collections'
	reset: false
	pull: true


!!book.define 
    name:'info_tfgrid' 
    summary_url:'https://git.threefold.info/tfgrid/info_tfgrid/src/branch/development/books/tech/SUMMARY.md' 
	title:'ThreeFold Technology'
	collections: 'about,dashboard,farmers,library,partners_utilization,tech,p2p'


!!book.publish
    name:'tech'
	production: false
"
	p.write(s2)!

	mut plbook := playbook.new(path: '/tmp/heroscript')!
	playcmds.play_publisher(mut plbook)!
}
