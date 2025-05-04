use std::path::PathBuf;
use std::io;
use std::fs;

// --- Simple Function ---
pub fn add(a: i32, b: i32) -> i32 {
    a + b
}

// --- Struct and Methods ---
#[derive(Clone)] // Added Clone for Rhai compatibility if needed directly
pub struct MyStruct {
    name: String,
}

impl MyStruct {
    pub fn new(name: String) -> Self {
        MyStruct { name }
    }

    // Immutable method
    pub fn get_name(&self) -> String {
        self.name.clone()
    }

    // Mutable method
    pub fn set_name(&mut self, new_name: String) {
        self.name = new_name;
    }
}

// --- Function Returning Result ---
#[derive(Clone)] // Added Clone for Rhai compatibility
pub struct Config {
    setting: String,
}

// Dummy error type
#[derive(Debug)]
pub struct ConfigError(String);

impl std::fmt::Display for ConfigError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "Config Error: {}", self.0)
    }
}
impl std::error::Error for ConfigError {}

pub fn load_config(path: &str) -> Result<Config, ConfigError> {
    if path == "valid/path" {
        Ok(Config { setting: "loaded".to_string() })
    } else {
        Err(ConfigError("Invalid path".to_string()))
    }
}

// --- Function Returning PathBuf ---
pub fn get_home_dir() -> PathBuf {
    // In a real scenario, this would use home::home_dir() or similar
    PathBuf::from("/fake/home")
}

// --- Function with Vec<String> ---
pub fn list_files(dir: &str) -> Vec<String> {
    // Dummy implementation for testing signature wrapping
    if dir == "valid/dir" {
        vec!["file1.txt".to_string(), "file2.rs".to_string()]
    } else {
        vec![]
    }
}
