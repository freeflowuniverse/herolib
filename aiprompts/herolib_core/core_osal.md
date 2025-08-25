# OSAL Core Module - Key Capabilities (freeflowuniverse.herolib.osal.core)

```v
//example how to get started

import freeflowuniverse.herolib.osal.core as osal

job := osal.exec(cmd: 'ls /')!
```

This document describes the core functionalities of the Operating System Abstraction Layer (OSAL) module, designed for platform-independent system operations in V.

## 1. Process Execution

*   **`osal.exec(cmd: Command) !Job`**: Execute a shell command.
    *   **Key Parameters**: `cmd` (string), `timeout` (int), `retry` (int), `work_folder` (string), `environment` (map[string]string), `stdout` (bool), `raise_error` (bool).
    *   **Returns**: `Job` (status, output, error, exit code).
*   **`osal.execute_silent(cmd string) !string`**: Execute silently, return output.
*   **`osal.execute_debug(cmd string) !string`**: Execute with debug output, return output.
*   **`osal.execute_stdout(cmd string) !string`**: Execute and print output to stdout, return output.
*   **`osal.execute_interactive(cmd string) !`**: Execute in an interactive shell.
*   **`osal.cmd_exists(cmd string) bool`**: Check if a command exists.

## 2. Network Utilities

*   **`osal.ping(args: PingArgs) !PingResult`**: Check host reachability.
    *   **Key Parameters**: `address` (string).
    *   **Returns**: `PingResult` (`.ok`, `.timeout`, `.unknownhost`).
*   **`osal.tcp_port_test(args: TcpPortTestArgs) bool`**: Test if a TCP port is open.
    *   **Key Parameters**: `address` (string), `port` (int).
*   **`osal.ipaddr_pub_get() !string`**: Get public IP address.

## 3. File System Operations

*   **`osal.file_write(path string, text string) !`**: Write text to a file.
*   **`osal.file_read(path string) !string`**: Read content from a file.
*   **`osal.dir_ensure(path string) !`**: Ensure a directory exists.
*   **`osal.rm(todelete string) !`**: Remove files/directories.

## 4. Environment Variables

*   **`osal.env_set(args: EnvSet)`**: Set an environment variable.
    *   **Key Parameters**: `key` (string), `value` (string).
*   **`osal.env_unset(key string)`**: Unset a specific environment variable.
*   **`osal.env_unset_all()`**: Unset all environment variables.
*   **`osal.env_set_all(args: EnvSetAll)`**: Set multiple environment variables.
    *   **Key Parameters**: `env` (map[string]string), `clear_before_set` (bool), `overwrite_if_exists` (bool).
*   **`osal.env_get(key string) !string`**: Get an environment variable's value.
*   **`osal.env_exists(key string) !bool`**: Check if an environment variable exists.
*   **`osal.env_get_default(key string, def string) string`**: Get an environment variable or a default value.
*   **`osal.load_env_file(file_path string) !`**: Load variables from a file.

## 5. Command & Profile Management

*   **`osal.cmd_add(args: CmdAddArgs) !`**: Add a binary to system paths and update profiles.
    *   **Key Parameters**: `source` (string, required), `cmdname` (string).
*   **`osal.profile_path_add_remove(args: ProfilePathAddRemoveArgs) !`**: Add/remove paths from profiles.
    *   **Key Parameters**: `paths2add` (string), `paths2delete` (string).

## 6. System Information & Utilities

*   **`osal.processmap_get() !ProcessMap`**: Get a map of all running processes.
*   **`osal.processinfo_get(pid int) !ProcessInfo`**: Get detailed information for a specific process.
*   **`osal.processinfo_get_byname(name string) ![]ProcessInfo`**: Get info for processes matching a name.
*   **`osal.process_exists(pid int) bool`**: Check if a process exists by PID.
*   **`osal.processinfo_with_children(pid int) !ProcessMap`**: Get a process and its children.
*   **`osal.processinfo_children(pid int) !ProcessMap`**: Get children of a process.
*   **`osal.process_kill_recursive(args: ProcessKillArgs) !`**: Kill a process and its children.
    *   **Key Parameters**: `name` (string), `pid` (int).
*   **`osal.whoami() !string`**: Return the current username.
*   **`osal.platform() !PlatformType`**: Identify the operating system.
*   **`osal.cputype() !CPUType`**: Identify the CPU architecture.
*   **`osal.hostname() !string`**: Get system hostname.
*   **`osal.sleep(duration int)`**: Pause execution for a specified duration.
*   **`osal.download(args: DownloadArgs) !pathlib.Path`**: Download a file from a URL.
    *   `pathlib.Path` is from `freeflowuniverse.herolib.core.pathlib`
    *   **Key Parameters**: `url` (string), `dest` (string), `timeout` (int), `retry` (int).
*   **`osal.user_exists(username string) bool`**: Check if a user exists.
*   **`osal.user_id_get(username string) !int`**: Get user ID.
*   **`osal.user_add(args: UserArgs) !int`**: Add a user.
    *   **Key Parameters**: `name` (string).
