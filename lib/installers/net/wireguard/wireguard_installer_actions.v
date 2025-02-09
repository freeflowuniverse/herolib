module wireguard_installer

import freeflowuniverse.herolib.osal
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.core.pathlib

import freeflowuniverse.herolib.installers.ulist


import os


//////////////////// following actions are not specific to instance of the object

// checks if a certain version or above is installed
fn installed() !bool {
    //THIS IS EXAMPLE CODEAND NEEDS TO BE CHANGED
    // res := os.execute('${osal.profile_path_source_and()!} wireguard_installer version')
    // if res.exit_code != 0 {
    //     return false
    // }
    // r := res.output.split_into_lines().filter(it.trim_space().len > 0)
    // if r.len != 1 {
    //     return error("couldn't parse wireguard_installer version.\n${res.output}")
    // }
    // if texttools.version(version) == texttools.version(r[0]) {
    //     return true
    // }
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
    //     cmdname: 'wireguard_installer'
    //     source: '${gitpath}/target/x86_64-unknown-linux-musl/release/wireguard_installer'
    // )!

}

fn install() ! {
    console.print_header('install wireguard_installer')
    //THIS IS EXAMPLE CODEAND NEEDS TO BE CHANGED
    // mut url := ''
    // if core.is_linux_arm() {
    //     url = 'https://github.com/wireguard_installer-dev/wireguard_installer/releases/download/v${version}/wireguard_installer_${version}_linux_arm64.tar.gz'
    // } else if core.is_linux_intel() {
    //     url = 'https://github.com/wireguard_installer-dev/wireguard_installer/releases/download/v${version}/wireguard_installer_${version}_linux_amd64.tar.gz'
    // } else if core.is_osx_arm() {
    //     url = 'https://github.com/wireguard_installer-dev/wireguard_installer/releases/download/v${version}/wireguard_installer_${version}_darwin_arm64.tar.gz'
    // } else if osal.is_osx_intel() {
    //     url = 'https://github.com/wireguard_installer-dev/wireguard_installer/releases/download/v${version}/wireguard_installer_${version}_darwin_amd64.tar.gz'
    // } else {
    //     return error('unsported platform')
    // }

    // mut dest := osal.download(
    //     url: url
    //     minsize_kb: 9000
    //     expand_dir: '/tmp/wireguard_installer'
    // )!

    // //dest.moveup_single_subdir()!

    // mut binpath := dest.file_get('wireguard_installer')!
    // osal.cmd_add(
    //     cmdname: 'wireguard_installer'
    //     source: binpath.path
    // )!
}


fn destroy() ! {

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

