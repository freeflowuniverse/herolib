module traefik

import crypto.bcrypt

// generate_htpasswd creates an Apache-style htpasswd entry for the given user and password
// using bcrypt hashing with configurable cost (default 12)
fn generate_htpasswd(user string, password string) !string {


	// Generate bcrypt hash
	hashed_password := bcrypt.generate_from_password(password.bytes(), 12) or {
		return error('Failed to hash password: ${err}')
	}

	println(hashed_password)

	// Return final formatted string
	return '${user}:${hashed_password}'
}