# HeroScript: Vlang Integration

## HeroScript Structure

HeroScript is a concise scripting language with the following structure:

```heroscript
!!actor.action_name
	param1: 'value1'
	param2: 'value with spaces'
	multiline_description: '
		This is a multiline description.
		It can span multiple lines.
		'
	arg1 arg2 // Arguments without keys
```

Key characteristics:
-   **Actions**: Start with `!!`, followed by `actor.action_name` (e.g., `!!mailclient.configure`).
-   **Parameters**: Defined as `key:value`. Values can be quoted for spaces.
-   **Multiline Support**: Parameters like `description` can span multiple lines.
-   **Arguments**: Values without keys (e.g., `arg1`).

## Processing HeroScript in Vlang

HeroScript can be parsed into a `playbook.PlayBook` object, allowing structured access to actions and their parameters, 
a good way how to do this as part of a module in a play.v file is shown below.

```v
import freeflowuniverse.herolib.core.playbook { PlayBook }
import freeflowuniverse.herolib.ui.console

@[params]
pub struct PlayArgs {
pub mut:
	heroscript      string
	heroscript_path string
	plbook          ?PlayBook
	reset           bool
}

pub fn play(args_ PlayArgs) ! {
	mut args := args_
	mut plbook := args.plbook or {
		playbook.new(text: args.heroscript, path: args.heroscript_path)!
	}

	// Initialize Docusaurus site manager based on 'docusaurus.define' action
	mut ds := new()!
	if plbook.exists_once(filter: 'docusaurus.define') {
		mut action := plbook.action_get(actor: 'docusaurus', name: 'define')!
		mut p := action.params
		ds = new(
			path_publish: p.get_default('path_publish', '')!
			path_build:   p.get_default('path_build', '')!
			production:   p.get_default_false('production')
			update:       p.get_default_false('update')
		)!
	}

	// Process 'docusaurus.add' actions to configure individual Docusaurus sites
	actions := plbook.find(filter: 'docusaurus.add')!
	for action in actions {
		mut p := action.params
		mut site := ds.get(
			name:          p.get_default('name', 'main')!
			nameshort:     p.get_default('nameshort', p.get_default('name', 'main')!)!
			git_reset:     p.get_default_false('git_reset')
			//... more
		)!
		if plbook.exists_once(filter: 'docusaurus.dev') {
			site.dev()!
		}
	}
}
```

For detailed information on parameter retrieval methods (e.g., `p.get()`, `p.get_int()`, `p.get_default_true()`), refer to `aiprompts/ai_core/core_params.md`.

