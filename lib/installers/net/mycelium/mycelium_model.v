module mycelium

import freeflowuniverse.herolib.data.encoderhero
import freeflowuniverse.herolib.osal.tun

pub const version = '0.5.7'
const singleton = true
const default = true

// THIS THE THE SOURCE OF THE INFORMATION OF THIS FILE, HERE WE HAVE THE CONFIG OBJECT CONFIGURED AND MODELLED
@[heap]
pub struct MyceliumInstaller {
pub mut:
	name   string   = 'default'
	peers  []string = [
	'tcp://188.40.132.242:9651',
	'quic://[2a01:4f8:212:fa6::2]:9651',
	'tcp://185.69.166.7:9651',
	'quic://[2a02:1802:5e:0:ec4:7aff:fe51:e36b]:9651',
	'tcp://65.21.231.58:9651',
	'quic://[2a01:4f9:5a:1042::2]:9651',
	'tcp://[2604:a00:50:17b:9e6b:ff:fe1f:e054]:9651',
	'quic://5.78.122.16:9651',
	'tcp://[2a01:4ff:2f0:3621::1]:9651',
	'quic://142.93.217.194:9651',
]
	tun_nr int
}

// your checking & initialization code if needed
fn obj_init(mycfg_ MyceliumInstaller) !MyceliumInstaller {
	mut mycfg := mycfg_
	return mycfg
}

// called before start if done
fn configure() ! {
	mut installer := get()!
	if installer.tun_nr == 0 {
		// Check if TUN is available first
		if available := tun.available() {
			if !available {
				return error('TUN is not available on this system')
			}
			// Get free TUN interface name
			if interface_name := tun.free() {
				// Parse the interface number from the name (e.g. "tun0" -> 0)
				nr := interface_name.trim_string_left('tun').int()
				installer.tun_nr = nr
			} else {
				return error('Failed to get free TUN interface: ${err}')
			}
		} else {
			return error('Failed to check TUN availability: ${err}')
		}
		set(installer)!
	}
}

/////////////NORMALLY NO NEED TO TOUCH

pub fn heroscript_dumps(obj MyceliumInstaller) !string {
	return encoderhero.encode[MyceliumInstaller](obj)!
}

pub fn heroscript_loads(heroscript string) !MyceliumInstaller {
	mut obj := encoderhero.decode[MyceliumInstaller](heroscript)!
	return obj
}
