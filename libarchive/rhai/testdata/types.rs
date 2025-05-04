use std::collections::HashMap;
use rhai::{Engine, EvalAltResult, Map, Dynamic, Array}; // Assuming necessary Rhai imports are here

// Define HealthCheck struct or use a placeholder if definition is complex/elsewhere
// Placeholder:
struct HealthCheck;

/// Container struct for nerdctl operations
#[derive(Clone)]
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


/// Register Container type with the Rhai engine
fn register_container_type(engine: &mut Engine) -> Result<(), Box<EvalAltResult>> {
	// Register Container type
	engine.register_type_with_name::<Container>("Container");

	// Register getters for Container properties
	engine.register_get("name", |obj: &mut Container| obj.name.clone());
	engine.register_get("container_id", |obj: &mut Container| {
		match &obj.container_id {
			Some(val) => val.clone(),
			None => "".to_string(), // Return empty string for None
		}
	});
	engine.register_get("image", |obj: &mut Container| {
		match &obj.image {
			Some(val) => val.clone(),
			None => "".to_string(), // Return empty string for None
		}
	});
	engine.register_get("config", |obj: &mut Container| {
		let mut map = rhai::Map::new();
		for (k, v) in &obj.config {
			map.insert(k.clone().into(), v.clone().into());
		}
		map
	});
	engine.register_get("ports", |obj: &mut Container| {
		let mut array = rhai::Array::new();
		for item in &obj.ports {
			array.push(rhai::Dynamic::from(item.clone()));
		}
		array
	});
	engine.register_get("volumes", |obj: &mut Container| {
		let mut array = rhai::Array::new();
		for item in &obj.volumes {
			array.push(rhai::Dynamic::from(item.clone()));
		}
		array
	});
	engine.register_get("env_vars", |obj: &mut Container| {
		let mut map = rhai::Map::new();
		for (k, v) in &obj.env_vars {
			map.insert(k.clone().into(), v.clone().into());
		}
		map
	});
	engine.register_get("network", |obj: &mut Container| {
		match &obj.network {
			Some(val) => val.clone(),
			None => "".to_string(), // Return empty string for None
		}
	});
	engine.register_get("network_aliases", |obj: &mut Container| {
		let mut array = rhai::Array::new();
		for item in &obj.network_aliases {
			array.push(rhai::Dynamic::from(item.clone()));
		}
		array
	});
	engine.register_get("cpu_limit", |obj: &mut Container| {
		match &obj.cpu_limit {
			Some(val) => val.clone(),
			None => "".to_string(), // Return empty string for None
		}
	});
	engine.register_get("memory_limit", |obj: &mut Container| {
		match &obj.memory_limit {
			Some(val) => val.clone(),
			None => "".to_string(), // Return empty string for None
		}
	});
	engine.register_get("memory_swap_limit", |obj: &mut Container| {
		match &obj.memory_swap_limit {
			Some(val) => val.clone(),
			None => "".to_string(), // Return empty string for None
		}
	});
	engine.register_get("cpu_shares", |obj: &mut Container| {
		match &obj.cpu_shares {
			Some(val) => val.clone(),
			None => "".to_string(), // Return empty string for None
		}
	});
	engine.register_get("restart_policy", |obj: &mut Container| {
		match &obj.restart_policy {
			Some(val) => val.clone(),
			None => "".to_string(), // Return empty string for None
		}
	});
	// TODO: Register getter for field: health_check (type: Option<HealthCheck>) - Add appropriate conversion if needed.
	engine.register_get("detach", |obj: &mut Container| obj.detach);
	engine.register_get("snapshotter", |obj: &mut Container| {
		match &obj.snapshotter {
			Some(val) => val.clone(),
			None => "".to_string(), // Return empty string for None
		}
	});

	Ok(())
}
