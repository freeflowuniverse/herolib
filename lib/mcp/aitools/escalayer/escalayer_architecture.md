# Escalayer Architecture

This document outlines the architecture for the Escalayer module, which provides a framework for executing AI tasks with automatic escalation to more powerful models when needed.

## 1. Module Structure

```
lib/mcp/aitools/escalayer/
├── escalayer.v         # Main module file with public API
├── task.v              # Task implementation
├── unit_task.v         # Unit task implementation
├── models.v            # Model definitions and configurations
├── openrouter.v        # OpenRouter API client
└── README.md           # Documentation
```

## 2. Core Components

### 2.1 Data Structures

```mermaid
classDiagram
    class Task {
        +string name
        +string description
        +[]UnitTask unit_tasks
        +string current_result
        +new_unit_task(params UnitTaskParams) UnitTask
        +initiate(input string)! string
    }
    
    class UnitTask {
        +string name
        +Function prompt_function
        +Function callback_function
        +ModelConfig base_model
        +ModelConfig retry_model
        +int retry_count
        +execute(input string)! string
    }
    
    class ModelConfig {
        +string name
        +string provider
        +float temperature
        +int max_tokens
    }
    
    Task "1" *-- "many" UnitTask : contains
    UnitTask "1" *-- "1" ModelConfig : base_model
    UnitTask "1" *-- "1" ModelConfig : retry_model
```

### 2.2 Component Descriptions

#### Task
- Represents a complete AI task composed of multiple sequential unit tasks
- Manages the flow of data between unit tasks
- Tracks overall task progress and results

#### UnitTask
- Represents a single step in the task
- Contains a prompt function that generates the AI prompt
- Contains a callback function that processes the AI response
- Manages retries and model escalation

#### ModelConfig
- Defines the configuration for an AI model
- Includes model name, provider, and parameters like temperature and max tokens

#### OpenRouter Client
- Handles communication with the OpenRouter API
- Sends prompts to AI models and receives responses

## 3. Implementation Details

### 3.1 escalayer.v (Main Module)

```v
module escalayer

import freeflowuniverse.herolib.clients.openai

// TaskParams defines the parameters for creating a new task
@[params]
pub struct TaskParams {
pub:
    name        string
    description string
}

// Create a new task
pub fn new_task(params TaskParams) &Task {
    return &Task{
        name: params.name
        description: params.description
        unit_tasks: []
        current_result: ''
    }
}

// Default model configurations
pub fn default_base_model() ModelConfig {
    return ModelConfig{
        name: 'gpt-3.5-turbo'
        provider: 'openai'
        temperature: 0.7
        max_tokens: 2000
    }
}

pub fn default_retry_model() ModelConfig {
    return ModelConfig{
        name: 'gpt-4'
        provider: 'openai'
        temperature: 0.7
        max_tokens: 4000
    }
}
```

### 3.2 task.v

```v
module escalayer

// Task represents a complete AI task composed of multiple sequential unit tasks
pub struct Task {
pub mut:
    name string
    description string
    unit_tasks []UnitTask
    current_result string
}

// UnitTaskParams defines the parameters for creating a new unit task
@[params]
pub struct UnitTaskParams {
pub:
    name string
    prompt_function fn(string) string
    callback_function fn(string)! string
    base_model ?ModelConfig
    retry_model ?ModelConfig
    retry_count ?int
}

// Add a new unit task to the task
pub fn (mut t Task) new_unit_task(params UnitTaskParams) &UnitTask {
    mut unit_task := UnitTask{
        name: params.name
        prompt_function: params.prompt_function
        callback_function: params.callback_function
        base_model: if params.base_model != none { params.base_model? } else { default_base_model() }
        retry_model: if params.retry_model != none { params.retry_model? } else { default_retry_model() }
        retry_count: if params.retry_count != none { params.retry_count? } else { 3 }
    }
    
    t.unit_tasks << unit_task
    return &t.unit_tasks[t.unit_tasks.len - 1]
}

// Initiate the task execution
pub fn (mut t Task) initiate(input string)! string {
    mut current_input := input
    
    for i, mut unit_task in t.unit_tasks {
        println('Executing unit task ${i+1}/${t.unit_tasks.len}: ${unit_task.name}')
        
        // Execute the unit task with the current input
        result := unit_task.execute(current_input)!
        
        // Update the current input for the next unit task
        current_input = result
        t.current_result = result
    }
    
    return t.current_result
}
```

### 3.3 unit_task.v

```v
module escalayer

import freeflowuniverse.herolib.clients.openai

// UnitTask represents a single step in the task
pub struct UnitTask {
pub mut:
    name string
    prompt_function fn(string) string
    callback_function fn(string)! string
    base_model ModelConfig
    retry_model ModelConfig
    retry_count int
}

// Execute the unit task
pub fn (mut ut UnitTask) execute(input string)! string {
    // Generate the prompt using the prompt function
    prompt := ut.prompt_function(input)
    
    // Try with the base model first
    mut current_model := ut.base_model
    mut attempts := 0
    mut max_attempts := ut.retry_count + 1 // +1 for the initial attempt
    mut last_error := ''
    
    for attempts < max_attempts {
        attempts++
        
        // If we've exhausted retries with the base model, switch to the retry model
        if attempts > ut.retry_count {
            println('Escalating to more powerful model: ${ut.retry_model.name}')
            current_model = ut.retry_model
            max_attempts = attempts + ut.retry_count // Reset max attempts for the retry model
        }
        
        println('Attempt ${attempts} with model ${current_model.name}')
        
        // Prepare the prompt with error feedback if this is a retry
        mut current_prompt := prompt
        if last_error != '' {
            current_prompt = 'Previous attempt failed with error: ${last_error}\n\n${prompt}'
        }
        
        // Call the AI model
        response := call_ai_model(current_prompt, current_model) or {
            println('AI call failed: ${err}')
            last_error = err.str()
            continue // Try again
        }
        
        // Process the response with the callback function
        result := ut.callback_function(response) or {
            // If callback returns an error, retry with the error message
            println('Callback returned error: ${err}')
            last_error = err.str()
            continue // Try again
        }
        
        // If we get here, the callback was successful
        return result
    }
    
    return error('Failed to execute unit task after ${attempts} attempts. Last error: ${last_error}')
}
```

### 3.4 models.v

```v
module escalayer

// ModelConfig defines the configuration for an AI model
pub struct ModelConfig {
pub mut:
    name string
    provider string
    temperature f32
    max_tokens int
}

// Call an AI model using OpenRouter
fn call_ai_model(prompt string, model ModelConfig)! string {
    // Get OpenAI client (configured for OpenRouter)
    mut client := get_openrouter_client()!
    
    // Create the message for the AI
    mut m := openai.Messages{
        messages: [
            openai.Message{
                role: .system
                content: 'You are a helpful assistant.'
            },
            openai.Message{
                role: .user
                content: prompt
            }
        ]
    }
    
    // Call the AI model
    res := client.chat_completion(
        msgs: m,
        model: model.name,
        temperature: model.temperature,
        max_completion_tokens: model.max_tokens
    )!
    
    // Extract the response content
    if res.choices.len > 0 {
        return res.choices[0].message.content
    }
    
    return error('No response from AI model')
}
```

### 3.5 openrouter.v

```v
module escalayer

import freeflowuniverse.herolib.clients.openai
import os

// Get an OpenAI client configured for OpenRouter
fn get_openrouter_client()! &openai.OpenAI {
    // Get API key from environment variable
    api_key := os.getenv('OPENROUTER_API_KEY')
    if api_key == '' {
        return error('OPENROUTER_API_KEY environment variable not set')
    }
    
    // Create OpenAI client with OpenRouter base URL
    mut client := openai.new(
        api_key: api_key,
        base_url: 'https://openrouter.ai/api/v1'
    )!
    
    return client
}
```

## 4. Usage Example

```v
import freeflowuniverse.herolib.mcp.aitools.escalayer

fn main() {
    // Create a new task
    mut task := escalayer.new_task(
        name: 'rhai_wrapper_creator'
        description: 'Create Rhai wrappers for Rust functions'
    )
    
    // Define the unit tasks
    task.new_unit_task(
        name: 'separate_functions'
        prompt_function: separate_functions
        callback_function: process_functions
    )
    
    task.new_unit_task(
        name: 'create_wrappers'
        prompt_function: create_wrappers
        callback_function: process_wrappers
        retry_count: 2
    )
    
    task.new_unit_task(
        name: 'create_tests'
        prompt_function: create_tests
        callback_function: process_tests
        base_model: escalayer.ModelConfig{
            name: 'claude-3-haiku-20240307'
            provider: 'anthropic'
            temperature: 0.5
            max_tokens: 4000
        }
    )
    
    // Initiate the task
    result := task.initiate('path/to/rust/file.rs') or {
        println('Task failed: ${err}')
        return
    }
    
    println('Task completed successfully')
    println(result)
}

// Define the prompt functions
fn separate_functions(input string) string {
    return 'Read rust file and separate it into functions ${input}'
}

fn create_wrappers(input string) string {
    return 'Create rhai wrappers for rust functions ${input}'
}

fn create_tests(input string) string {
    return 'Create tests for rhai wrappers ${input}'
}

// Define the callback functions
fn process_functions(response string)! string {
    // Process the AI response
    // Return error if processing fails
    if response.contains('error') {
        return error('Failed to process functions: Invalid response format')
    }
    return response
}

fn process_wrappers(response string)! string {
    // Process the AI response
    // Return error if processing fails
    if !response.contains('fn') {
        return error('Failed to process wrappers: No functions found')
    }
    return response
}

fn process_tests(response string)! string {
    // Process the AI response
    // Return error if processing fails
    if !response.contains('test') {
        return error('Failed to process tests: No tests found')
    }
    return response
}
```

## 5. Key Features and Benefits

1. **V-Idiomatic Design**: Uses V's `@[params]` structures for configuration and the V result type (`fn ()!`) for error handling.

2. **Sequential Task Execution**: Tasks are executed in sequence, with each unit task building on the results of the previous one.

3. **Automatic Model Escalation**: If a unit task fails with a cheaper model, the system automatically retries with a more powerful model.

4. **Flexible Configuration**: Each unit task can be configured with different models, retry counts, and other parameters.

5. **Error Handling**: Comprehensive error handling with detailed error messages and retry mechanisms using V's built-in error handling.

6. **Callback Processing**: Custom callback functions allow for validation and processing of AI responses.

7. **OpenRouter Integration**: Uses OpenRouter to access a wide range of AI models from different providers.

## 6. Future Enhancements

1. **Parallel Execution**: Add support for executing unit tasks in parallel when they don't depend on each other.

2. **Caching**: Implement caching of AI responses to avoid redundant API calls.

3. **Cost Tracking**: Add functionality to track and report on API usage costs.

4. **Timeout Handling**: Add support for timeouts and graceful handling of long-running tasks.

5. **Streaming Responses**: Support for streaming AI responses for long-form content generation.

6. **Prompt Templates**: Add support for reusable prompt templates.

7. **Logging and Monitoring**: Enhanced logging and monitoring capabilities.