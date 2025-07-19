module zinit

// Helper function to format memory usage in human-readable format
pub fn format_memory_usage(bytes i64) string {
	if bytes < 1024 {
		return '${bytes} B'
	} else if bytes < 1024 * 1024 {
		return '${bytes / 1024} KB'
	} else if bytes < 1024 * 1024 * 1024 {
		return '${bytes / 1024 / 1024} MB'
	} else {
		return '${bytes / 1024 / 1024 / 1024} GB'
	}
}

// Helper function to format CPU usage
pub fn format_cpu_usage(cpu_percent f64) string {
	return '${cpu_percent:.1f}%'
}
