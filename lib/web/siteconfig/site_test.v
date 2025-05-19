module siteconfig
import os

fn test_play_collections() ! {

	mypath :='${os.dir(@FILE)}/example'

	mut sc:=new(path:mypath)!

}