module mycelium

import json
import freeflowuniverse.herolib.core.httpconnection

pub struct MessageDestination {
pub:
	pk string
}

pub struct PushMessageBody {
pub:
	dst     MessageDestination
	payload string
}

pub struct InboundMessage {
pub:
	id      string
	src_ip  string @[json: 'srcIP']
	src_pk  string @[json: 'srcPk']
	dst_ip  string @[json: 'dstIp']
	dst_pk  string @[json: 'dstPk']
	payload string
}

pub struct MessageStatusResponse {
pub:
	id       string
	dst      string
	state    string
	created  string
	deadline string
	msg_len  string @[json: 'msgLen']
}

pub fn (mut self Mycelium) connection() !&httpconnection.HTTPConnection {
	mut c := self.conn or {
		mut c2 := httpconnection.new(
			name:  'mycelium'
			url:   self.server_url
			retry: 3
		)!
		c2
	}

	return c
}

pub fn (mut self Mycelium) send_msg(pk string, payload string, wait bool) !InboundMessage {
	mut conn := self.connection()!
	mut params := {
		'dst':     json.encode(MessageDestination{ pk: pk })
		'payload': payload
	}
	mut prefix := ''
	if wait {
		prefix = '?reply_timeout=120'
	}
	return conn.post_json_generic[InboundMessage](
		method:     .post
		prefix:     prefix
		params:     params
		dataformat: .json
	)!
}

pub fn (mut self Mycelium) receive_msg(wait bool) !InboundMessage {
	mut conn := self.connection()!
	mut prefix := ''
	if wait {
		prefix = '?timeout=60'
	}
	return conn.get_json_generic[InboundMessage](
		method:     .get
		prefix:     prefix
		dataformat: .json
	)!
}

pub fn (mut self Mycelium) receive_msg_opt(wait bool) ?InboundMessage {
	mut conn := self.connection()!
	mut prefix := ''
	if wait {
		prefix = '?timeout=60'
	}
	res := conn.get_json_generic[InboundMessage](
		method:     .get
		prefix:     prefix
		dataformat: .json
	) or {
		if err.msg().contains('204') {
			return none
		}
		panic(err)
	}
	return res
}

pub fn (mut self Mycelium) get_msg_status(id string) !MessageStatusResponse {
	mut conn := self.connection()!
	return conn.get_json_generic[MessageStatusResponse](
		method:     .get
		prefix:     'status/${id}'
		dataformat: .json
	)!
}

pub fn (mut self Mycelium) reply_msg(id string, pk string, payload string) ! {
	mut conn := self.connection()!
	mut params := {
		'dst':     json.encode(MessageDestination{ pk: pk })
		'payload': payload
	}
	conn.post_json_generic[json.Any](
		method:     .post
		prefix:     'reply/${id}'
		params:     params
		dataformat: .json
	)!
}
