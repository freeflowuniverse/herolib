module specification

import freeflowuniverse.herolib.core.code { Struct, Function }
import freeflowuniverse.herolib.schemas.openrpc {ContentDescriptor, ErrorSpec}

pub struct ActorSpecification {
pub mut:
	name        string      @[omitempty]
	description string      @[omitempty]
	structure   Struct      @[omitempty]
	interfaces []ActorInterface @[omitempty]
	methods     []ActorMethod @[omitempty]
	objects     []BaseObject @[omitempty]
}

pub enum ActorInterface {
	openrpc
	openapi
	webui
	command
}

pub struct ActorMethod {
pub:
	name        string   @[omitempty]
	description string   @[omitempty]
	summary 	string
	parameters 	[]ContentDescriptor
	result 		ContentDescriptor
	errors 		[]ErrorSpec
}

pub struct BaseObject {
pub:
	structure Struct      @[omitempty]
	methods   []Function  @[omitempty]
	children  []Struct    @[omitempty]
}