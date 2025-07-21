module core

import time

// sleep in seconds
pub fn sleep(duration int) {
	time.sleep(time.second * duration)
}
