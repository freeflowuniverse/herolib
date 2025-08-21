module datamodelsimulator

import freeflowuniverse.herolib.core.playbook { PlayBook }

// this play script should never be called from hero directly its called by gridsimulator
pub fn play(mut plbook PlayBook) !map[string]&Node {
	mut actions2 := plbook.find(filter: 'tfgrid_simulator.*')!

	mut nodesdict := map[string]&Node{}
	for action in actions2 {
		echo("TODO: Implement action handling for ${action.name}")
	}
	return nodesdict
}
