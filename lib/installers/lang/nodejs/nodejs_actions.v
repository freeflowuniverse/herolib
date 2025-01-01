module nodejs

import freeflowuniverse.herolib.osal
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.installers.ulist
import freeflowuniverse.herolib.installers.base



import os


//////////////////// following actions are not specific to instance of the object

fn installed_() !bool {
    
    res := os.execute('pnpm -v')
    if res.exit_code != 0 {
        return false
    }
    r := res.output.split_into_lines().filter(it.trim_space().len > 0)
    if r.len != 1 {
        return error("couldn't parse pnpm version.\n${res.output}")
    }
    if texttools.version(r[0]) >= texttools.version(version) {
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
fn upload_() ! {

}

fn install_() ! {
    console.print_header('install nodejs')
    osal.package_install('pnpm')!
}


fn destroy_() ! {

    // mut systemdfactory := systemd.new()!
    // systemdfactory.destroy("zinit")!

    // osal.process_kill_recursive(name:'zinit')!
    // osal.cmd_delete('zinit')!

    osal.package_remove('
       pnpm
    ')!

    // //will remove all paths where go/bin is found
    // osal.profile_path_add_remove(paths2delete:"go/bin")!

    // osal.rm("
    //    podman
    //    conmon
    //    buildah
    //    skopeo
    //    runc
    //    /var/lib/containers
    //    /var/lib/podman
    //    /var/lib/buildah
    //    /tmp/podman
    //    /tmp/conmon
    // ")!

}

