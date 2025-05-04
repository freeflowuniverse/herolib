
/// Create a new Rhai engine with @{name} functionality
pub fn create_rhai_engine() -> Engine {
    let mut engine = Engine::new();
    
    // Register the @{name} module
    if let Err(err) = register_${name}_module(&mut engine) {
        eprintln!("Error registering @{name} module: {}", err);
    }
    
    // Register types
    if let Err(err) = register_@{name}_types(&mut engine) {
        eprintln!("Error registering @{name} types: {}", err);
    }
    
    engine
}

@{register_functions_rs}

@{register_types_rs}