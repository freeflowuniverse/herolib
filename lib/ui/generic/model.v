module generic

import freeflowuniverse.herolib.ui.console { UIConsole }
import freeflowuniverse.herolib.ui.template { UIExample }
// import freeflowuniverse.herolib.ui.telegram { UITelegram }

// need to do this for each type of UI channel e.g. console, telegram, ...
type UIChannel = UIConsole | UIExample // TODO TelegramBot

pub struct UserInterface {
pub mut:
	channel UIChannel
	user_id string
}

pub enum ChannelType {
	console
	telegram
}
