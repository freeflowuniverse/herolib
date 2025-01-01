module python

import freeflowuniverse.herolib.osal
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.installers.ulist
import freeflowuniverse.herolib.installers.base



import os


//////////////////// following actions are not specific to instance of the object

// checks if a certain version or above is installed
fn installed_() !bool {
    return false
}

//get the Upload List of the files
fn ulist_get() !ulist.UList {
    //optionally build a UList which is all paths which are result of building, is then used e.g. in upload
    return ulist.UList{}
}

fn upload_() ! {
}

fn install_() ! {
    console.print_header('install python')
    base.install()!

    osal.package_install('python3')!
    pl := osal.platform()
    if pl == .arch {
        osal.package_install('python-pipx,sqlite')!
    } else if pl == .ubuntu {
        osal.package_install('python-pipx,sqlite')!
    } else if pl == .osx {
        osal.package_install('pipx,sqlite')!

    } else {
        return error('only support osx, arch & ubuntu.')
    }
    osal.execute_silent("pipx install uv")!
}


fn destroy_() ! {

    panic("implement")

    // mut systemdfactory := systemd.new()!
    // systemdfactory.destroy("zinit")!

    // osal.process_kill_recursive(name:'zinit')!
    // osal.cmd_delete('zinit')!

    // osal.package_remove('
    //    podman
    //    conmon
    //    buildah
    //    skopeo
    //    runc
    // ')!

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

