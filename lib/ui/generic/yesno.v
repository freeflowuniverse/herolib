module generic

import freeflowuniverse.herolib.ui.console { UIConsole }
// import freeflowuniverse.herolib.ui.telegram { UITelegram }
import freeflowuniverse.herolib.ui.uimodel

// yes is true, no is false
// args:
// - description string
// - question string
// - warning string
// - clear bool = true
//
pub fn (mut c UserInterface) ask_yesno(args uimodel.YesNoArgs) !bool {
	match mut c.channel {
		UIConsole { return c.channel.ask_yesno(args)! }
		else { panic("can't find channel") }
	}
}
