module cloudslices

import time

pub struct NodeTemplate {
	Node
pub mut:
	name        string
	description string // Description of the node
	image_url   string // Image url associated with the node
}
