module podman

pub const version = '4.9.3'
const singleton = true
const default = true

pub struct PodmanInstaller {
pub mut:
	name string = 'default'
}
