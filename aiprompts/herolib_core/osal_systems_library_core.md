# OSAL Core Module - Key Capabilities (freeflowuniverse.herolib.osal.core)


```v
//example how to get started

import freeflowuniverse.herolib.osal.core as osal

osal.exec(cmd:"ls /")!

```

this document has info about the most core functions, more detailed info can be found in  `aiprompts/herolib_advanced/osal.md` if needed.

## Key Functions

### 1. Process Execution

*   **`osal.exec(cmd: Command) !Job`**: Execute a shell command.
    *   **Key Parameters**: `cmd` (string), `timeout` (int), `retry` (int), `work_folder` (string), `environment` (map[string]string), `stdout` (bool), `raise_error` (bool).
    *   **Returns**: `Job` (status, output, error, exit code).
*   **`osal.execute_silent(cmd string) !string`**: Execute silently, return output.
*   **`osal.cmd_exists(cmd string) bool`**: Check if a command exists.
*   **`osal.process_kill_recursive(args: ProcessKillArgs) !`**: Kill a process and its children.

### 2. Network Utilities

*   **`osal.ping(args: PingArgs) !PingResult`**: Check host reachability.
    *   **Key Parameters**: `address` (string).
    *   **Returns**: `PingResult` (`.ok`, `.timeout`, `.unknownhost`).
*   **`osal.tcp_port_test(args: TcpPortTestArgs) bool`**: Test if a TCP port is open.
    *   **Key Parameters**: `address` (string), `port` (int).
*   **`osal.ipaddr_pub_get() !string`**: Get public IP address.

### 3. File System Operations

*   **`osal.file_write(path string, text string) !`**: Write text to a file.
*   **`osal.file_read(path string) !string`**: Read content from a file.
*   **`osal.dir_ensure(path string) !`**: Ensure a directory exists.
*   **`osal.rm(todelete string) !`**: Remove files/directories.

### 4. Environment Variables

*   **`osal.env_set(args: EnvSet)`**: Set an environment variable.
    *   **Key Parameters**: `key` (string), `value` (string).
*   **`osal.env_get(key string) !string`**: Get an environment variable's value.
*   **`osal.load_env_file(file_path string) !`**: Load variables from a file.

### 5. Command & Profile Management

*   **`osal.cmd_add(args: CmdAddArgs) !`**: Add a binary to system paths and update profiles.
    *   **Key Parameters**: `source` (string, required), `cmdname` (string).
*   **`osal.profile_path_add_remove(args: ProfilePathAddRemoveArgs) !`**: Add/remove paths from profiles.
    *   **Key Parameters**: `paths2add` (string), `paths2delete` (string).

### 6. System Information

*   **`osal.platform() !PlatformType`**: Identify the operating system.
*   **`osal.cputype() !CPUType`**: Identify the CPU architecture.
*   **`osal.hostname() !string`**: Get system hostname.

---

