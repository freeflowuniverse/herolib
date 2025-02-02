module bun

import freeflowuniverse.herolib.osal
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.installers.ulist



import os


//////////////////// following actions are not specific to instance of the object

// checks if a certain version or above is installed
fn installed() !bool {
    res := os.execute('${osal.profile_path_source_and()!} bun -version')
    if res.exit_code != 0 {
        return false
    }
    r := res.output.split_into_lines().filter(it.trim_space().len > 0)
    if r.len != 1 {
        return error("couldn't parse bun version.\n${res.output}")
    }
    // println(" ${texttools.version(version)} <= ${texttools.version(r[0])}")
    if texttools.version(version) <= texttools.version(r[0]) {
        return true
    }
    return false
}

//get the Upload List of the files
fn ulist_get() !ulist.UList {
    //optionally build a UList which is all paths which are result of building, is then used e.g. in upload
    return ulist.UList{}
}

//uploads to S3 server if configured
fn upload() ! {
    // installers.upload(
    //     cmdname: 'bun'
    //     source: '${gitpath}/target/x86_64-unknown-linux-musl/release/bun'
    // )!

}

fn install() ! {
    console.print_header('install bun')
    osal.exec(cmd: 'curl -fsSL https://bun.sh/install | bash')!
}


fn destroy() ! {

    // osal.process_kill_recursive(name:'bun')!
    
    osal.cmd_delete('bun')!

    osal.package_remove('
       bun
    ')!

    //will remove all paths where bun is found
    osal.profile_path_add_remove(paths2delete:"bun")!

    osal.rm("
        ~/.bun
    ")!

}

