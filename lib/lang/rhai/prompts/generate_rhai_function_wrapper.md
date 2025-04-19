# Generate Single Rhai Wrapper Function

You are an expert Rust and Rhai developer tasked with creating a Rhai wrapper function for a given Rust function signature.

## Task

Generate a single `pub fn` Rhai wrapper function based on the provided Rust function signature and associated struct definitions.

**CRITICAL INSTRUCTION:** The generated Rhai wrapper function **MUST** call the original Rust function provided in the input. **DO NOT** reimplement the logic of the original function within the wrapper. The wrapper's sole purpose is to handle type conversions and error mapping between Rhai and Rust.

## Input Rust Function

```rust
@{gen.function}
```

## Input Rust Types

Below are the struct declarations for types used in the function

@for structure in gen.structs
    ```rust
    @{structure}
    ```
@end

## Instructions

1.  **Analyze the Signature:**
    *   Identify the function/method name.
    *   Identify the input parameters and their types.
    *   Identify the return type.
    *   Determine if it's a method on a struct (e.g., `&self`, `&mut self`).

2.  **Define the Wrapper Signature:**
    *   The wrapper function name should generally match the original Rust function name (use snake_case).
    *   Input parameters should correspond to the Rust function's parameters. You might need to adjust types for Rhai compatibility (e.g., `&str` becomes `&str`, `String` becomes `String`, `Vec<T>` might become `rhai::Array`, `HashMap<K, V>` might become `rhai::Map`).
    *   If the original function is a method on a struct (e.g., `fn method(&self, ...) ` or `fn method_mut(&mut self, ...)`), the first parameter of the wrapper must be the receiver type (e.g., `mut? receiver: StructType`). Ensure the mutability matches.
    *   The return type **must** be `Result<T, Box<EvalAltResult>>`, where `T` is the Rhai-compatible equivalent of the original Rust function's return type. If the original function returns `Result<U, E>`, `T` should be the Rhai-compatible version of `U`, and the error `E` should be mapped into `Box<EvalAltResult>`. If the original returns `()`, use `Result<(), Box<EvalAltResult>>`. If it returns a simple type `U`, use `Result<U, Box<EvalAltResult>>`.

3.  **Implement the Wrapper Body:**
    *   **Call the original function.** This is the most important step.
    *   Handle parameter type conversions if necessary (e.g., `i64` from Rhai to `i32` for Rust).
    *   If the original function returns `Result<T, E>`, map the `Ok(T)` value and handle the `Err(E)` by converting it to `Box<EvalAltResult::ErrorRuntime(...)`.
    *   If the original function returns `T`, wrap the result in `Ok(T)`.
    *   If the original function returns `PathBuf`, convert it to `String` using `.to_string_lossy().to_string()` before wrapping in `Ok()`.
    *   If the original function returns `()`, return `Ok(())`.

4.  **Best Practices:**
    *   Use `rhai::{Engine, EvalAltResult, Dynamic, Map, Array}` imports as needed.
    *   **Prefer strongly typed return values** (`Result<String, ...>`, `Result<bool, ...>`, `Result<Vec<String>, ...>`) over `Result<Dynamic, ...>`. Only use `Dynamic` if the return type is truly variable or complex and cannot be easily represented otherwise.
    *   **Do NOT use the `#[rhai_fn]` attribute.** The function will be registered manually.
    *   Handle string type consistency (e.g., `String::from()` for literals if mixed with `format!`).

### Error Handling

Assume that the following function is available to use in the rhai wrapper body:

```rust 
// Helper functions for error conversion with improved context
fn [modulename]_error_to_rhai_error<T>(result: Result<T, [modulename]Error>) -> Result<T, Box<EvalAltResult>> {}
```

And feel free to use it like:
```rust
/// Create a new Container
pub fn container_new(name: &str) -> Result<Container, Box<EvalAltResult>> {
    nerdctl_error_to_rhai_error(Container::new(name))
}
```

## Output Format

Provide **only** the generated Rust code for the wrapper function, enclosed in triple backticks.

```rust
// Your generated wrapper function here
pub fn wrapper_function_name(...) -> Result<..., Box<EvalAltResult>> {
    // Implementation
}
```

### Example

Below is a bunch of input and outputted wrapped functions.

Example Input Types:
```rust
pub struct Container {
    /// Name of the container
    pub name: String,
    /// Container ID
    pub container_id: Option<String>,
    /// Base image (if created from an image)
    pub image: Option<String>,
    /// Configuration options
    pub config: HashMap<String, String>,
    /// Port mappings
    pub ports: Vec<String>,
    /// Volume mounts
    pub volumes: Vec<String>,
    /// Environment variables
    pub env_vars: HashMap<String, String>,
    /// Network to connect to
    pub network: Option<String>,
    /// Network aliases
    pub network_aliases: Vec<String>,
    /// CPU limit
    pub cpu_limit: Option<String>,
    /// Memory limit
    pub memory_limit: Option<String>,
    /// Memory swap limit
    pub memory_swap_limit: Option<String>,
    /// CPU shares
    pub cpu_shares: Option<String>,
    /// Restart policy
    pub restart_policy: Option<String>,
    /// Health check
    pub health_check: Option<HealthCheck>,
    /// Whether to run in detached mode
    pub detach: bool,
    /// Snapshotter to use
    pub snapshotter: Option<String>,
}

/// Health check configuration for a container
#[derive(Debug, Clone)]
pub struct HealthCheck {
    /// Command to run for health check
    pub cmd: String,
    /// Time between running the check (default: 30s)
    pub interval: Option<String>,
    /// Maximum time to wait for a check to complete (default: 30s)
    pub timeout: Option<String>,
    /// Number of consecutive failures needed to consider unhealthy (default: 3)
    pub retries: Option<u32>,
    /// Start period for the container to initialize before counting retries (default: 0s)
    pub start_period: Option<String>,
}
```

Example Input Functions:
```rust
 /// Set memory swap limit for the container
    ///
    /// # Arguments
    ///
    /// * `memory_swap` - Memory swap limit (e.g., "1g" for 1GB)
    ///
    /// # Returns
    ///
    /// * `Self` - The container instance for method chaining
    pub fn with_memory_swap_limit(mut self, memory_swap: &str) -> Self {
        self.memory_swap_limit = Some(memory_swap.to_string());
        self
    }
    
    /// Set CPU shares for the container (relative weight)
    ///
    /// # Arguments
    ///
    /// * `shares` - CPU shares (e.g., "1024" for default, "512" for half)
    ///
    /// # Returns
    ///
    /// * `Self` - The container instance for method chaining
    pub fn with_cpu_shares(mut self, shares: &str) -> Self {
        self.cpu_shares = Some(shares.to_string());
        self
    }
    
    /// Set restart policy for the container
    ///
    /// # Arguments
    ///
    /// * `policy` - Restart policy (e.g., "no", "always", "on-failure", "unless-stopped")
    ///
    /// # Returns
    ///
    /// * `Self` - The container instance for method chaining
    pub fn with_restart_policy(mut self, policy: &str) -> Self {
        self.restart_policy = Some(policy.to_string());
        self
    }
    
    /// Set a simple health check for the container
    ///
    /// # Arguments
    ///
    /// * `cmd` - Command to run for health check (e.g., "curl -f http://localhost/ || exit 1")
    ///
    /// # Returns
    ///
    /// * `Self` - The container instance for method chaining
    pub fn with_health_check(mut self, cmd: &str) -> Self {
        // Use the health check script module to prepare the command
        let prepared_cmd = prepare_health_check_command(cmd, &self.name);
        
        self.health_check = Some(HealthCheck {
            cmd: prepared_cmd,
            interval: None,
            timeout: None,
            retries: None,
            start_period: None,
        });
        self
    }
    
    /// Set a health check with custom options for the container
    ///
    /// # Arguments
    ///
    /// * `cmd` - Command to run for health check
    /// * `interval` - Optional time between running the check (e.g., "30s", "1m")
    /// * `timeout` - Optional maximum time to wait for a check to complete (e.g., "30s", "1m")
    /// * `retries` - Optional number of consecutive failures needed to consider unhealthy
    /// * `start_period` - Optional start period for the container to initialize before counting retries (e.g., "30s", "1m")
    ///
    /// # Returns
    ///
    /// * `Self` - The container instance for method chaining
    pub fn with_health_check_options(
        mut self,
        cmd: &str,
        interval: Option<&str>,
        timeout: Option<&str>,
        retries: Option<u32>,
        start_period: Option<&str>,
    ) -> Self {
        // Use the health check script module to prepare the command
        let prepared_cmd = prepare_health_check_command(cmd, &self.name);
        
        let mut health_check = HealthCheck {
            cmd: prepared_cmd,
            interval: None,
            timeout: None,
            retries: None,
            start_period: None,
        };
        
        if let Some(interval_value) = interval {
            health_check.interval = Some(interval_value.to_string());
        }
        
        if let Some(timeout_value) = timeout {
            health_check.timeout = Some(timeout_value.to_string());
        }
        
        if let Some(retries_value) = retries {
            health_check.retries = Some(retries_value);
        }
        
        if let Some(start_period_value) = start_period {
            health_check.start_period = Some(start_period_value.to_string());
        }
        
        self.health_check = Some(health_check);
        self
    }
    
    /// Set the snapshotter
    ///
    /// # Arguments
    ///
    /// * `snapshotter` - Snapshotter to use
    ///
    /// # Returns
    ///
    /// * `Self` - The container instance for method chaining
    pub fn with_snapshotter(mut self, snapshotter: &str) -> Self {
        self.snapshotter = Some(snapshotter.to_string());
        self
    }
    
    /// Set whether to run in detached mode
    ///
    /// # Arguments
    ///
    /// * `detach` - Whether to run in detached mode
    ///
    /// # Returns
    ///
    /// * `Self` - The container instance for method chaining
    pub fn with_detach(mut self, detach: bool) -> Self {
        self.detach = detach;
        self
    }
    
    /// Build the container
    ///
    /// # Returns
    ///
    /// * `Result<Self, NerdctlError>` - Container instance or error
    pub fn build(self) -> Result<Self, NerdctlError> {
        // If container already exists, return it
        if self.container_id.is_some() {
            return Ok(self);
        }
        
        // If no image is specified, return an error
        let image = match &self.image {
            Some(img) => img,
            None => return Err(NerdctlError::Other("No image specified for container creation".to_string())),
        };
        
        // Build the command arguments as strings
        let mut args_strings = Vec::new();
        args_strings.push("run".to_string());
        
        if self.detach {
            args_strings.push("-d".to_string());
        }
        
        args_strings.push("--name".to_string());
        args_strings.push(self.name.clone());
        
        // Add port mappings
        for port in &self.ports {
            args_strings.push("-p".to_string());
            args_strings.push(port.clone());
        }
        
        // Add volume mounts
        for volume in &self.volumes {
            args_strings.push("-v".to_string());
            args_strings.push(volume.clone());
        }
        
        // Add environment variables
        for (key, value) in &self.env_vars {
            args_strings.push("-e".to_string());
            args_strings.push(format!("{}={}", key, value));
        }
        
        // Add network configuration
        if let Some(network) = &self.network {
            args_strings.push("--network".to_string());
            args_strings.push(network.clone());
        }
        
        // Add network aliases
        for alias in &self.network_aliases {
            args_strings.push("--network-alias".to_string());
            args_strings.push(alias.clone());
        }
        
        // Add resource limits
        if let Some(cpu_limit) = &self.cpu_limit {
            args_strings.push("--cpus".to_string());
            args_strings.push(cpu_limit.clone());
        }
        
        if let Some(memory_limit) = &self.memory_limit {
            args_strings.push("--memory".to_string());
            args_strings.push(memory_limit.clone());
        }
        
        if let Some(memory_swap_limit) = &self.memory_swap_limit {
            args_strings.push("--memory-swap".to_string());
            args_strings.push(memory_swap_limit.clone());
        }
        
        if let Some(cpu_shares) = &self.cpu_shares {
            args_strings.push("--cpu-shares".to_string());
            args_strings.push(cpu_shares.clone());
        }
        
        // Add restart policy
        if let Some(restart_policy) = &self.restart_policy {
            args_strings.push("--restart".to_string());
            args_strings.push(restart_policy.clone());
        }
        
        // Add health check
        if let Some(health_check) = &self.health_check {
            args_strings.push("--health-cmd".to_string());
            args_strings.push(health_check.cmd.clone());
            
            if let Some(interval) = &health_check.interval {
                args_strings.push("--health-interval".to_string());
                args_strings.push(interval.clone());
            }
            
            if let Some(timeout) = &health_check.timeout {
                args_strings.push("--health-timeout".to_string());
                args_strings.push(timeout.clone());
            }
            
            if let Some(retries) = &health_check.retries {
                args_strings.push("--health-retries".to_string());
                args_strings.push(retries.to_string());
            }
            
            if let Some(start_period) = &health_check.start_period {
                args_strings.push("--health-start-period".to_string());
                args_strings.push(start_period.clone());
            }
        }
        
        if let Some(snapshotter_value) = &self.snapshotter {
            args_strings.push("--snapshotter".to_string());
            args_strings.push(snapshotter_value.clone());
        }
        
        // Add flags to avoid BPF issues
        args_strings.push("--cgroup-manager=cgroupfs".to_string());
        
        args_strings.push(image.clone());
        
        // Convert to string slices for the command
        let args: Vec<&str> = args_strings.iter().map(|s| s.as_str()).collect();
        
        // Execute the command
        let result = execute_nerdctl_command(&args)?;
        
        // Get the container ID from the output
        let container_id = result.stdout.trim().to_string();
        
        Ok(Self {
            name: self.name,
            container_id: Some(container_id),
            image: self.image,
            config: self.config,
            ports: self.ports,
            volumes: self.volumes,
            env_vars: self.env_vars,
            network: self.network,
            network_aliases: self.network_aliases,
            cpu_limit: self.cpu_limit,
            memory_limit: self.memory_limit,
            memory_swap_limit: self.memory_swap_limit,
            cpu_shares: self.cpu_shares,
            restart_policy: self.restart_policy,
            health_check: self.health_check,
            detach: self.detach,
            snapshotter: self.snapshotter,
        })
    }

```

Example output functions:
```rust

/// Set memory swap limit for a Container
pub fn container_with_memory_swap_limit(container: Container, memory_swap: &str) -> Container {
    container.with_memory_swap_limit(memory_swap)
}

/// Set CPU shares for a Container
pub fn container_with_cpu_shares(container: Container, shares: &str) -> Container {
    container.with_cpu_shares(shares)
}

/// Set health check with options for a Container
pub fn container_with_health_check_options(
    container: Container,
    cmd: &str,
    interval: Option<&str>,
    timeout: Option<&str>,
    retries: Option<i64>,
    start_period: Option<&str>
) -> Container {
    // Convert i64 to u32 for retries
    let retries_u32 = retries.map(|r| r as u32);
    container.with_health_check_options(cmd, interval, timeout, retries_u32, start_period)
}

/// Set snapshotter for a Container
pub fn container_with_snapshotter(container: Container, snapshotter: &str) -> Container {
    container.with_snapshotter(snapshotter)
}

/// Set detach mode for a Container
pub fn container_with_detach(container: Container, detach: bool) -> Container {
    container.with_detach(detach)
}

/// Build and run the Container
///
/// This function builds and runs the container using the configured options.
/// It provides detailed error information if the build fails.
pub fn container_build(container: Container) -> Result<Container, Box<EvalAltResult>> {
    // Get container details for better error reporting
    let container_name = container.name.clone();
    let image = container.image.clone().unwrap_or_else(|| "none".to_string());
    let ports = container.ports.clone();
    let volumes = container.volumes.clone();
    let env_vars = container.env_vars.clone();
    
    // Try to build the container
    let build_result = container.build();
    
    // Handle the result with improved error context
    match build_result {
        Ok(built_container) => {
            // Container built successfully
            Ok(built_container)
        },
        Err(err) => {
            // Add more context to the error
            let enhanced_error = match err {
                NerdctlError::CommandFailed(msg) => {
                    // Provide more detailed error information
                    let mut enhanced_msg = format!("Failed to build container '{}' from image '{}': {}", 
                        container_name, image, msg);
                    
                    // Add information about configured options that might be relevant
                    if !ports.is_empty() {
                        enhanced_msg.push_str(&format!("\nConfigured ports: {:?}", ports));
                    }
                    
                    if !volumes.is_empty() {
                        enhanced_msg.push_str(&format!("\nConfigured volumes: {:?}", volumes));
                    }
                    
                    if !env_vars.is_empty() {
                        enhanced_msg.push_str(&format!("\nConfigured environment variables: {:?}", env_vars));
                    }
                    
                    // Add suggestions for common issues
                    if msg.contains("not found") || msg.contains("no such image") {
                        enhanced_msg.push_str("\nSuggestion: The specified image may not exist or may not be pulled yet. Try pulling the image first with nerdctl_image_pull().");
                    } else if msg.contains("port is already allocated") {
                        enhanced_msg.push_str("\nSuggestion: One of the specified ports is already in use. Try using a different port or stopping the container using that port.");
                    } else if msg.contains("permission denied") {
                        enhanced_msg.push_str("\nSuggestion: Permission issues detected. Check if you have the necessary permissions to create containers or access the specified volumes.");
                    }
                    
                    NerdctlError::CommandFailed(enhanced_msg)
                },
                _ => err
            };
            
            nerdctl_error_to_rhai_error(Err(enhanced_error))
        }
    }
}
