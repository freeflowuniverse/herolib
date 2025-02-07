module livekit

import time
import rand
import crypto.hmac
import crypto.sha256
import encoding.base64
import json

// Define AccessTokenOptions struct
@[params]
pub struct AccessTokenOptions {
pub mut:
	ttl      int = 21600 // TTL in seconds
	name     string // Display name for the participant
	identity string // Identity of the user
	metadata string // Custom metadata to be passed to participants
}

// Constructor for AccessToken
pub fn (client Client) new_access_token(options AccessTokenOptions) !AccessToken {
	return AccessToken{
		api_key:    client.api_key
		api_secret: client.api_secret
		identity:   options.identity
		ttl:        options.ttl
		grants:     ClaimGrants{
			exp:  time.now().unix() + options.ttl
			iss:  client.api_key
			sub:  options.name
			name: options.name
		}
	}
}
