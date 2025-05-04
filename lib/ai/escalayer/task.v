module escalayer

import log

// Task represents a complete AI task composed of multiple sequential unit tasks
pub struct Task {
pub mut:
	name           string
	description    string
	unit_tasks     []UnitTask
	current_result string
}

// UnitTaskParams defines the parameters for creating a new unit task
@[params]
pub struct UnitTaskParams {
pub:
	name              string
	prompt_function   fn (string) string
	callback_function fn (string) !string
	base_model        ?ModelConfig
	retry_model       ?ModelConfig
	retry_count       ?int
}

// Add a new unit task to the task
pub fn (mut t Task) new_unit_task(params UnitTaskParams) &UnitTask {
	mut unit_task := UnitTask{
		name:              params.name
		prompt_function:   params.prompt_function
		callback_function: params.callback_function
		base_model:        if base_model := params.base_model {
			base_model
		} else {
			default_base_model()
		}
		retry_model:       if retry_model := params.retry_model {
			retry_model
		} else {
			default_retry_model()
		}
		retry_count:       if retry_count := params.retry_count { retry_count } else { 3 }
	}

	t.unit_tasks << unit_task
	return &t.unit_tasks[t.unit_tasks.len - 1]
}

// Initiate the task execution
pub fn (mut t Task) initiate(input string) !string {
	mut current_input := input

	for i, mut unit_task in t.unit_tasks {
		log.error('Executing unit task ${i + 1}/${t.unit_tasks.len}: ${unit_task.name}')

		// Execute the unit task with the current input
		result := unit_task.execute(current_input)!

		// Update the current input for the next unit task
		current_input = result
		t.current_result = result
	}

	return t.current_result
}
