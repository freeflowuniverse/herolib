========================
CODE SNIPPETS
========================
TITLE: MCP Client Configuration (SSE)
DESCRIPTION: Provides a JSON configuration example for connecting an MCP client to a FastAPI-MCP server using Server-Sent Events (SSE). This configuration specifies the URL of the MCP server.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/docs/getting-started/quickstart.mdx#_snippet_2

LANGUAGE: json
CODE:
```
{
  "mcpServers": {
    "fastapi-mcp": {
      "url": "http://localhost:8000/mcp"
    }
  }
}
```

----------------------------------------

TITLE: Basic Usage Example
DESCRIPTION: Demonstrates the fundamental integration of FastAPI-MCP into a FastAPI application. This example covers the initial setup and basic functionality.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/examples/README.md#_snippet_0

LANGUAGE: python
CODE:
```
from fastapi import FastAPI
from fastapi_mcp import MCP

app = FastAPI()
mcp = MCP(app)

@app.get("/")
def read_root():
    return {"Hello": "World"}

# To run this example:
# 1. Save the code as main.py
# 2. Install dependencies: pip install fastapi uvicorn fastapi-mcp
# 3. Run the server: uvicorn main:app --reload
```

----------------------------------------

TITLE: Install FastAPI-MCP with uv
DESCRIPTION: Installs the fastapi-mcp package using the uv package installer.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/docs/getting-started/installation.mdx#_snippet_0

LANGUAGE: bash
CODE:
```
uv add fastapi-mcp
```

----------------------------------------

TITLE: Install FastAPI-MCP
DESCRIPTION: Instructions for installing the FastAPI-MCP package using uv or pip.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/README_zh-CN.md#_snippet_0

LANGUAGE: bash
CODE:
```
uv add fastapi-mcp
```

LANGUAGE: bash
CODE:
```
pip install fastapi-mcp
```

----------------------------------------

TITLE: Install FastAPI-MCP with uv pip or pip
DESCRIPTION: Provides commands to install fastapi-mcp using uv pip or the standard pip installer.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/docs/getting-started/installation.mdx#_snippet_1

LANGUAGE: bash
CODE:
```
uv pip install fastapi-mcp
```

LANGUAGE: bash
CODE:
```
pip install fastapi-mcp
```

----------------------------------------

TITLE: Create Basic MCP Server
DESCRIPTION: Demonstrates how to create a basic MCP server by initializing a FastAPI app and wrapping it with the FastApiMCP class, then mounting the MCP to the application.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/docs/getting-started/quickstart.mdx#_snippet_0

LANGUAGE: python
CODE:
```
from fastapi import FastAPI
from fastapi_mcp import FastApiMCP

# Create (or import) a FastAPI app
app = FastAPI()

# Create an MCP server based on this app
mcp = FastApiMCP(app)

# Mount the MCP server directly to your app
mcp.mount_http()
```

----------------------------------------

TITLE: Set Up Development Environment with uv
DESCRIPTION: Installs project dependencies and sets up the virtual environment using the uv package manager.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/CONTRIBUTING.md#_snippet_1

LANGUAGE: bash
CODE:
```
uv sync
```

----------------------------------------

TITLE: Reregister Tools Example
DESCRIPTION: Illustrates how to re-register tools after adding new endpoints to an existing MCP server. This is necessary if endpoints are added after the initial server setup.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/docs/getting-started/FAQ.mdx#_snippet_1

LANGUAGE: python
CODE:
```
from fastapi import FastAPI
from fastapi_mcp import MCP

app = FastAPI()
mcp = MCP(app=app)

# Add initial endpoints...

# Add a new endpoint after MCP server creation
@app.get("/new_endpoint")
def new_endpoint():
    return {"message": "This is a new endpoint"}

# Re-register all tools to include the new endpoint
mcp.setup_server()

# Your FastAPI application setup...
```

----------------------------------------

TITLE: Install fastapi-mcp
DESCRIPTION: Installs the fastapi-mcp package using uv, a fast Python package installer. Alternatively, pip can be used.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
uv add fastapi-mcp
```

LANGUAGE: bash
CODE:
```
pip install fastapi-mcp
```

----------------------------------------

TITLE: Custom MCP Router Example
DESCRIPTION: Demonstrates advanced routing configuration in FastAPI-MCP, allowing for custom router setups beyond the default behavior.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/examples/README.md#_snippet_5

LANGUAGE: python
CODE:
```
from fastapi import FastAPI, APIRouter
from fastapi_mcp import MCP

app = FastAPI()

# Create a custom router
custom_router = APIRouter()

@custom_router.get("/custom_route")
def custom_route_endpoint():
    return {"message": "Custom Route Endpoint"}

# Initialize MCP with the custom router
mcp = MCP(app, router=custom_router)

# Endpoints defined directly on the app or other routers will also be discoverable by MCP if expose_all is True or they are explicitly exposed.
```

----------------------------------------

TITLE: Reregister Tools Example
DESCRIPTION: Shows how to add or register new endpoints (tools) to an existing MCP server after its initial creation. This allows for dynamic endpoint management.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/examples/README.md#_snippet_4

LANGUAGE: python
CODE:
```
from fastapi import FastAPI
from fastapi_mcp import MCP

app = FastAPI()
mcp = MCP(app)

@app.get("/initial")
def initial_endpoint():
    return {"message": "Initial Endpoint"}

@app.get("/added_later")
def added_later_endpoint():
    return {"message": "Added Later Endpoint"}

# Register the second endpoint after MCP initialization
mcp.reregister("/added_later")

# Now both /initial and /added_later endpoints are managed by MCP.
```

----------------------------------------

TITLE: Separate Server Example
DESCRIPTION: Demonstrates deploying the MCP server separately from the main FastAPI application. This pattern is useful for microservice architectures.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/examples/README.md#_snippet_3

LANGUAGE: python
CODE:
```
from fastapi import FastAPI
from fastapi_mcp import MCP

# Main FastAPI App
main_app = FastAPI()

@main_app.get("/main")
def read_main():
    return {"message": "Main App"}

# MCP Server App
mcp_app = FastAPI()
mcp = MCP(mcp_app)

@mcp.get("/mcp_service")
def mcp_service():
    return {"message": "MCP Service"}

# To run:
# 1. Run the main app: uvicorn main_app:main_app --port 8000
# 2. Run the MCP app: uvicorn mcp_app:mcp_app --port 8001
# The MCP server at port 8001 will discover and serve endpoints from the main app at port 8000.
```

----------------------------------------

TITLE: Full Schema Description Example
DESCRIPTION: Illustrates how to customize schema descriptions within FastAPI-MCP. This allows for more detailed and user-friendly API documentation.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/examples/README.md#_snippet_1

LANGUAGE: python
CODE:
```
from fastapi import FastAPI
from fastapi_mcp import MCP
from pydantic import BaseModel

app = FastAPI()
mcp = MCP(app)

class Item(BaseModel):
    name: str
    description: str | None = None
    price: float
    tax: float | None = None

    class Config:
        schema_extra = {
            "example": {
                "name": "Foo",
                "description": "A very nice Item",
                "price": 35.4,
                "tax": 4.2
            }
        }

@app.post("/items/")
def create_item(item: Item):
    return item

# This example shows how to add custom descriptions to your Pydantic models,
# which will be reflected in the OpenAPI (Swagger UI) documentation.
```

----------------------------------------

TITLE: Create and Mount MCP Server
DESCRIPTION: Demonstrates the minimal code required to initialize FastAPI-MCP and mount the MCP server to a FastAPI application. This setup exposes your FastAPI endpoints as MCP tools.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/docs/getting-started/welcome.mdx#_snippet_0

LANGUAGE: python
CODE:
```
from fastapi import FastAPI
from fastapi_mcp import FastApiMCP

app = FastAPI()

mcp = FastApiMCP(app)
mcp.mount_http()
```

----------------------------------------

TITLE: Run MCP Server with Uvicorn
DESCRIPTION: Shows how to run the FastAPI application with an integrated MCP server using uvicorn. This includes the necessary imports and the uvicorn.run call within an if __name__ == "__main__" block.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/docs/getting-started/quickstart.mdx#_snippet_1

LANGUAGE: python
CODE:
```
from fastapi import FastAPI
from fastapi_mcp import FastApiMCP

app = FastAPI()

mcp = FastApiMCP(app)
mcp.mount_http()

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
```

----------------------------------------

TITLE: Install and Run Pre-commit Hooks
DESCRIPTION: Installs pre-commit hooks to automatically check code style and quality before commits, and then runs them.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/CONTRIBUTING.md#_snippet_2

LANGUAGE: bash
CODE:
```
uv run pre-commit install
uv run pre-commit run
```

----------------------------------------

TITLE: FastAPI MCP AuthConfig with Auth0
DESCRIPTION: Example of initializing FastAPI MCP with Auth0 as the OAuth provider. It includes essential configuration like issuer, URLs, client credentials, scopes, and proxy setup.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/docs/advanced/auth.mdx#_snippet_6

LANGUAGE: python
CODE:
```
from fastapi_mcp import FastApiMCP, AuthConfig
from fastapi import Depends

# Assume verify_auth is defined elsewhere
def verify_auth():
    pass

mcp = FastApiMCP(
    app,
    auth_config=AuthConfig(
        issuer="https://auth.example.com",
        authorize_url="https://auth.example.com/authorize",
        oauth_metadata_url="https://auth.example.com/.well-known/oauth-authorization-server",
        client_id="your-client-id",
        client_secret="your-client-secret",
        audience="your-api-audience",
        default_scope="openid profile email",
        dependencies=[Depends(verify_auth)],
        setup_proxies=True,
    ),
)
```

----------------------------------------

TITLE: MCP Client Configuration (mcp-remote)
DESCRIPTION: Illustrates a JSON configuration for connecting an MCP client using the mcp-remote bridge, which is recommended for authentication or clients not supporting SSE. It includes the command, arguments, and an optional port for OAuth.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/docs/getting-started/quickstart.mdx#_snippet_3

LANGUAGE: json
CODE:
```
{
  "mcpServers": {
    "fastapi-mcp": {
      "command": "npx",
      "args": [
        "mcp-remote",
        "http://localhost:8000/mcp",
        "8080"  // Optional port number. Necessary if you want your OAuth to work and you don't have dynamic client registration.
      ]
    }
  }
}
```

----------------------------------------

TITLE: Configure HTTP Timeout Example
DESCRIPTION: Illustrates how to customize the HTTP timeout settings for requests made by FastAPI-MCP when interacting with other services.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/examples/README.md#_snippet_6

LANGUAGE: python
CODE:
```
from fastapi import FastAPI
from fastapi_mcp import MCP

app = FastAPI()

# Configure MCP with a custom HTTP timeout (e.g., 10 seconds)
mcp = MCP(app, http_timeout=10.0)

# Any requests made by MCP to other services will now use a 10-second timeout.
# This is useful for controlling how long MCP waits for responses from external APIs.
```

----------------------------------------

TITLE: MCP Inspector Usage
DESCRIPTION: Provides instructions on how to use the MCP Inspector to test a running FastAPI MCP server. It covers starting the inspector, connecting to the server, listing tools, and running an endpoint.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/docs/getting-started/FAQ.mdx#_snippet_2

LANGUAGE: bash
CODE:
```
# Install the MCP Inspector globally (if not already installed)
npm install -g @modelcontextprotocol/inspector

# Start the MCP Inspector
npx @modelcontextprotocol/inspector

# In the inspector, connect to your MCP server
# Enter the mount path URL, e.g., http://127.0.0.1:8000/mcp

# Navigate to the 'Tools' section
# Click 'List Tools' to see available endpoints

# To test an endpoint:
# 1. Select a tool
# 2. Fill in required parameters
# 3. Click 'Run Tool'
```

----------------------------------------

TITLE: Advanced Usage: Separate Deployment
DESCRIPTION: Provides an example of deploying the MCP server separately from the main FastAPI application, showing how to create an MCP server from one app and mount it onto another.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/README_zh-CN.md#_snippet_5

LANGUAGE: python
CODE:
```
from fastapi import FastAPI
from fastapi_mcp import FastApiMCP

# Your API application
api_app = FastAPI()
# ... define your API endpoints on api_app ...

# A separate MCP server application
mcp_app = FastAPI()

# Create MCP server from the API app
mcp = FastApiMCP(api_app)

# Mount the MCP server onto the separate application
mcp.mount(mcp_app)

# Now you can run both applications separately:
# uvicorn main:api_app --host api-host --port 8001
# uvicorn main:mcp_app --host mcp-host --port 8000
```

----------------------------------------

TITLE: Running Separate FastAPI and MCP Apps
DESCRIPTION: Provides the bash commands to run the original API application and the mounted MCP server application concurrently using uvicorn. This setup allows for distinct hosting and port configurations.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/docs/advanced/deploy.mdx#_snippet_1

LANGUAGE: bash
CODE:
```
uvicorn main:api_app --host api-host --port 8001
uvicorn main:mcp_app --host mcp-host --port 8000
```

----------------------------------------

TITLE: Custom Exposed Endpoints Example
DESCRIPTION: Shows how to control which endpoints are exposed by FastAPI-MCP. This is useful for managing the visibility of specific API operations.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/examples/README.md#_snippet_2

LANGUAGE: python
CODE:
```
from fastapi import FastAPI
from fastapi_mcp import MCP

app = FastAPI()
mcp = MCP(app, expose_all=False) # Set expose_all to False to control exposure manually

@app.get("/public")
def public_endpoint():
    return {"message": "This is public"}

@app.get("/private")
def private_endpoint():
    return {"message": "This is private"}

mcp.expose("/public") # Explicitly expose the public endpoint

# The /private endpoint will not be exposed by MCP unless explicitly added.
```

----------------------------------------

TITLE: FastAPI Route Operation ID Examples
DESCRIPTION: Demonstrates how to use explicit operation_id in FastAPI routes for clearer tool naming in FastAPI-MCP. The first example shows an auto-generated operation_id, while the second shows an explicitly defined 'get_user_info' operation_id.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/docs/configurations/tool-naming.mdx#_snippet_0

LANGUAGE: python
CODE:
```
import fastapi

app = fastapi.FastAPI()

# Auto-generated operation_id (something like "read_user_users__user_id__get")
@app.get("/users/{user_id}")
async def read_user(user_id: int):
    return {"user_id": user_id}

# Explicit operation_id (tool will be named "get_user_info")
@app.get("/users/{user_id}", operation_id="get_user_info")
async def read_user(user_id: int):
    return {"user_id": user_id}
```

----------------------------------------

TITLE: Configure HTTP Timeout Example
DESCRIPTION: Demonstrates how to configure custom HTTP request timeouts by injecting an httpx client. This is useful for API endpoints that require longer response times than the default 5 seconds.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/docs/getting-started/FAQ.mdx#_snippet_0

LANGUAGE: python
CODE:
```
from fastapi import FastAPI
from fastapi_mcp import MCP
import httpx

app = FastAPI()
mcp = MCP(app=app)

# Configure a custom timeout (e.g., 10 seconds)
custom_client = httpx.Client(timeout=10.0)
mcp.add_client(custom_client)

# Your FastAPI endpoints would go here...
```

----------------------------------------

TITLE: HTTP Transport Client Configuration
DESCRIPTION: Example JSON configuration for an MCP client connecting via HTTP transport. It specifies the URL for the FastAPI-MCP server.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/docs/advanced/transport.mdx#_snippet_3

LANGUAGE: json
CODE:
```
{
  "mcpServers": {
    "fastapi-mcp": {
      "url": "http://localhost:8000/mcp"
    }
  }
}
```

----------------------------------------

TITLE: SSE Transport Client Configuration
DESCRIPTION: Example JSON configuration for an MCP client connecting via SSE transport. It specifies the URL for the FastAPI-MCP server, which will be accessed using Server-Sent Events.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/docs/advanced/transport.mdx#_snippet_4

LANGUAGE: json
CODE:
```
{
  "mcpServers": {
    "fastapi-mcp": {
      "url": "http://localhost:8000/sse"
    }
  }
}
```

----------------------------------------

TITLE: MCP Client Call for OAuth Flow
DESCRIPTION: Example of how to call an MCP server configured with OAuth 2 flow using `mcp-remote`. It specifies the server address and an optional port number, which is crucial for dynamic client registration.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/docs/advanced/auth.mdx#_snippet_3

LANGUAGE: json
CODE:
```
{
  "mcpServers": {
    "fastapi-mcp": {
      "command": "npx",
      "args": [
        "mcp-remote",
        "http://localhost:8000/mcp",
        "8080"  // Optional port number. Necessary if you want your OAuth to work and you don't have dynamic client registration.
      ]
    }
  }
}
```

----------------------------------------

TITLE: Running Commands with Virtual Environment Activated
DESCRIPTION: Demonstrates how to run project commands like pytest, mypy, and ruff after activating the virtual environment.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/CONTRIBUTING.md#_snippet_3

LANGUAGE: bash
CODE:
```
source .venv/bin/activate  # On Windows: .venv\Scripts\activate

# Then run commands directly
pytest
mypy .
ruff check .
```

----------------------------------------

TITLE: Development Workflow Steps
DESCRIPTION: Outlines the typical development process, including forking, branching, making changes, testing, formatting, and creating a pull request.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/CONTRIBUTING.md#_snippet_8

LANGUAGE: bash
CODE:
```
# Fork the repository and set the upstream remote
# Create a feature branch (git checkout -b feature/amazing-feature)
# Make your changes
# Run type checking (mypy .)
# Run the tests (pytest)
# Format your code (ruff check . and ruff format .). Not needed if pre-commit is installed, as it will run it for you.
# Commit your changes (git commit -m 'Add some amazing feature')
# Push to the branch (git push origin feature/amazing-feature)
# Open a Pull Request. Make sure the Pull Request's base branch is [the original repository's](https://github.com/tadata-org/fastapi_mcp/) `main` branch.
```

----------------------------------------

TITLE: Basic Usage of FastAPI-MCP
DESCRIPTION: Demonstrates the simplest way to integrate FastAPI-MCP into a FastAPI application by mounting the MCP server directly. The MCP server will be available at '/mcp'.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/README.md#_snippet_1

LANGUAGE: python
CODE:
```
from fastapi import FastAPI
from fastapi_mcp import FastApiMCP

app = FastAPI()

mcp = FastApiMCP(app)

# Mount the MCP server directly to your FastAPI app
mcp.mount()
```

----------------------------------------

TITLE: Clone Repository and Set Up Remotes
DESCRIPTION: Clones the FastAPI-MCP repository and adds the upstream remote for tracking changes from the original repository.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/CONTRIBUTING.md#_snippet_0

LANGUAGE: bash
CODE:
```
git clone https://github.com/YOUR-USERNAME/fastapi_mcp.git
cd fastapi_mcp

# Add the upstream remote
git remote add upstream https://github.com/tadata-org/fastapi_mcp.git
```

----------------------------------------

TITLE: Basic Usage: Mount MCP Server
DESCRIPTION: Demonstrates the simplest way to integrate FastAPI-MCP by mounting the MCP server directly into a FastAPI application.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/README_zh-CN.md#_snippet_1

LANGUAGE: python
CODE:
```
from fastapi import FastAPI
from fastapi_mcp import FastApiMCP

app = FastAPI()

mcp = FastApiMCP(app)

# Directly mount the MCP server to your FastAPI application
mcp.mount()
```

----------------------------------------

TITLE: Mounting MCP to a Separate FastAPI App
DESCRIPTION: Demonstrates how to create an MCP server from an existing FastAPI application and mount it to a completely separate FastAPI application. This allows for independent deployment and management of the MCP server.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/docs/advanced/deploy.mdx#_snippet_0

LANGUAGE: python
CODE:
```
from fastapi import FastAPI
from fastapi_mcp import FastApiMCP

# Your API app
api_app = FastAPI()
# ... define your API endpoints on api_app ...

# A separate app for the MCP server
mcp_app = FastAPI()

# Create MCP server from the API app
mcp = FastApiMCP(api_app)

# Mount the MCP server to the separate app
mcp.mount_http(mcp_app)
```

----------------------------------------

TITLE: Adding Runtime Dependencies
DESCRIPTION: Adds a new package as a runtime dependency for the application using uv.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/CONTRIBUTING.md#_snippet_5

LANGUAGE: bash
CODE:
```
uv add new-package
```

----------------------------------------

TITLE: Custom HTTP Client with FastAPI-MCP
DESCRIPTION: Demonstrates how to initialize FastApiMCP with a custom httpx.AsyncClient, specifying a base URL and timeout. This allows for more control over HTTP requests made by the MCP integration.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/README_zh-CN.md#_snippet_8

LANGUAGE: python
CODE:
```
import httpx
from fastapi_mcp import FastApiMCP

# Assuming 'app' is your FastAPI instance
# app = FastAPI()

custom_client = httpx.AsyncClient(
    base_url="https://api.example.com",
    timeout=30.0
)

mcp = FastApiMCP(
    app,
    http_client=custom_client
)

mcp.mount()
```

----------------------------------------

TITLE: Advanced Usage: Adding Endpoints After Server Creation
DESCRIPTION: Explains the process of refreshing the MCP server to include new endpoints that are added to the FastAPI application after the MCP server has already been initialized and mounted.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/README_zh-CN.md#_snippet_6

LANGUAGE: python
CODE:
```
from fastapi import FastAPI
from fastapi_mcp import FastApiMCP

app = FastAPI()
# ... define initial endpoints ...

# Create MCP server
mcp = FastApiMCP(app)
mcp.mount()

# Add new endpoints after MCP server creation
@app.get("/new/endpoint/", operation_id="new_endpoint")
async def new_endpoint():
    return {"message": "Hello, world!"}

# Refresh the MCP server to include the new endpoints
mcp.setup_server()
```

----------------------------------------

TITLE: Running Commands without Activating Virtual Environment
DESCRIPTION: Shows how to execute project commands using the 'uv run' prefix when the virtual environment is not activated.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/CONTRIBUTING.md#_snippet_4

LANGUAGE: bash
CODE:
```
# Use uv run prefix for all commands
uv run pytest
uv run mypy .
uv run ruff check .
```

----------------------------------------

TITLE: Adding Development Dependencies
DESCRIPTION: Adds a new package specifically for development, testing, or CI purposes using uv with the --group dev flag.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/CONTRIBUTING.md#_snippet_6

LANGUAGE: bash
CODE:
```
uv add --group dev new-package
```

----------------------------------------

TITLE: Custom HTTP Client Configuration
DESCRIPTION: Demonstrates how to initialize FastAPI-MCP with a custom httpx.AsyncClient, allowing for a specified base URL and timeout settings. This is useful when the default ASGI transport is not suitable or when explicit HTTP client configuration is required.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/docs/advanced/asgi.mdx#_snippet_0

LANGUAGE: python
CODE:
```
import httpx
from fastapi import FastAPI
from fastapi_mcp import FastApiMCP

app = FastAPI()

custom_client = httpx.AsyncClient(
    base_url="https://api.example.com",
    timeout=30.0
)

mcp = FastApiMCP(
    app,
    http_client=custom_client
)

mcp.mount()
```

----------------------------------------

TITLE: Running Tests
DESCRIPTION: Command to execute all tests in the project using pytest.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/CONTRIBUTING.md#_snippet_10

LANGUAGE: bash
CODE:
```
# Run all tests
pytest
```

----------------------------------------

TITLE: Run Tests
DESCRIPTION: Command to execute all tests using the pytest framework.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/CONTRIBUTING.md#_snippet_11

LANGUAGE: bash
CODE:
```
# Run all tests
pytest
```

----------------------------------------

TITLE: MCP Server Configuration for Claude Desktop (Windows)
DESCRIPTION: Provides the JSON configuration for Claude Desktop to connect to an MCP server via mcp-proxy on Windows. It specifies the command to run and arguments, including the MCP server URL.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/README_zh-CN.md#_snippet_9

LANGUAGE: json
CODE:
```
{
  "mcpServers": {
    "my-api-mcp-proxy": {
        "command": "mcp-proxy",
        "args": ["http://127.0.0.1:8000/mcp"]
    }
  }
}
```

----------------------------------------

TITLE: Code Quality Checks
DESCRIPTION: Commands to check code formatting, style, and type correctness using ruff and mypy.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/CONTRIBUTING.md#_snippet_9

LANGUAGE: bash
CODE:
```
# Check code formatting and style
ruff check .
ruff format .

# Check types
mypy .
```

----------------------------------------

TITLE: Communication: Using Custom httpx.AsyncClient
DESCRIPTION: Demonstrates how to provide a custom `httpx.AsyncClient` to FastAPI-MCP for specifying a custom base URL or using different transport methods for communication with the FastAPI application.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/README_zh-CN.md#_snippet_7

LANGUAGE: python
CODE:
```
import httpx
from fastapi import FastAPI
from fastapi_mcp import FastApiMCP

app = FastAPI()

# Example of providing a custom httpx.AsyncClient
# custom_client = httpx.AsyncClient(base_url="http://localhost:8000")
# mcp = FastApiMCP(app, client=custom_client)
# mcp.mount()
```

----------------------------------------

TITLE: Advanced Usage: Custom Schema Descriptions
DESCRIPTION: Shows how to customize the MCP server's behavior regarding response descriptions, including options to include all possible response schemas and full response schemas in tool descriptions.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/README_zh-CN.md#_snippet_3

LANGUAGE: python
CODE:
```
from fastapi import FastAPI
from fastapi_mcp import FastApiMCP

app = FastAPI()

mcp = FastApiMCP(
    app,
    name="My API MCP",
    describe_all_responses=True,     # Include all possible response schemas in tool descriptions
    describe_full_response_schema=True  # Include full JSON schemas in tool descriptions
)

mcp.mount()
```

----------------------------------------

TITLE: Control Tool and Schema Descriptions
DESCRIPTION: Configures the MCP server to include all possible response schemas in tool descriptions using 'describe_all_responses' or full JSON schema using 'describe_full_response_schema'.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/docs/configurations/customization.mdx#_snippet_1

LANGUAGE: python
CODE:
```
from fastapi import FastAPI
from fastapi_mcp import FastApiMCP

app = FastAPI()

mcp = FastApiMCP(
    app,
    name="My API MCP",
    description="Very cool MCP server",
    describe_all_responses=True,
    describe_full_response_schema=True
)

mcp.mount_http()
```

----------------------------------------

TITLE: MCP Server Configuration for Claude Desktop (MacOS)
DESCRIPTION: Provides the JSON configuration for Claude Desktop to connect to an MCP server via mcp-proxy on MacOS. It requires the full path to the mcp-proxy executable and the MCP server URL.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/README_zh-CN.md#_snippet_10

LANGUAGE: json
CODE:
```
{
  "mcpServers": {
    "my-api-mcp-proxy": {
        "command": "/Full/Path/To/Your/Executable/mcp-proxy",
        "args": ["http://127.0.0.1:8000/mcp"]
    }
  }
}
```

----------------------------------------

TITLE: Set Server Metadata
DESCRIPTION: Defines the MCP server name and description by passing 'name' and 'description' arguments to the FastApiMCP constructor.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/docs/configurations/customization.mdx#_snippet_0

LANGUAGE: python
CODE:
```
from fastapi import FastAPI
from fastapi_mcp import FastApiMCP

app = FastAPI()

mcp = FastApiMCP(
    app,
    name="My API MCP",
    description="Very cool MCP server",
)
mcp.mount_http()
```

----------------------------------------

TITLE: Committing Dependency Changes
DESCRIPTION: Commits the updated pyproject.toml and uv.lock files after adding new dependencies.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/CONTRIBUTING.md#_snippet_7

LANGUAGE: bash
CODE:
```
git add pyproject.toml uv.lock
git commit -m "Add new-package dependency"
```

----------------------------------------

TITLE: Auth0 Environment Variables
DESCRIPTION: Required environment variables for Auth0 integration with FastAPI MCP. These variables store your Auth0 tenant and client credentials.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/docs/advanced/auth.mdx#_snippet_5

LANGUAGE: env
CODE:
```
AUTH0_DOMAIN=your-tenant.auth0.com
AUTH0_AUDIENCE=https://your-tenant.auth0.com/api/v2/
AUTH0_CLIENT_ID=your-client-id
AUTH0_CLIENT_SECRET=your-client-secret
```

----------------------------------------

TITLE: Mount HTTP/SSE Transport with Custom Routing
DESCRIPTION: Demonstrates mounting both HTTP and SSE transports to custom paths using an APIRouter. This allows for more flexible routing and integration with existing FastAPI applications.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/docs/advanced/transport.mdx#_snippet_2

LANGUAGE: python
CODE:
```
from fastapi import FastAPI, APIRouter
from fastapi_mcp import FastApiMCP

app = FastAPI()
router = APIRouter(prefix="/api/v1")

mcp = FastApiMCP(app)

# Mount to custom path with HTTP transport
mcp.mount_http(router, mount_path="/my-http")

# Or with SSE transport
mcp.mount_sse(router, mount_path="/my-sse")
```

----------------------------------------

TITLE: Refresh FastAPI MCP Server with New Endpoints
DESCRIPTION: This snippet shows how to add a new endpoint to a FastAPI application and then refresh the FastAPI MCP server to recognize and serve the new endpoint. It assumes you have already initialized FastApiMCP and mounted the HTTP server.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/docs/advanced/refresh.mdx#_snippet_0

LANGUAGE: python
CODE:
```
from fastapi import FastAPI
from fastapi_mcp import FastApiMCP

app = FastAPI()

mcp = FastApiMCP(app)
mcp.mount_http()

# Add new endpoints after MCP server creation
@app.get("/new/endpoint/", operation_id="new_endpoint")
async def new_endpoint():
    return {"message": "Hello, world!"}

# Refresh the MCP server to include the new endpoint
mcp.setup_server()
```

----------------------------------------

TITLE: Mount HTTP Transport
DESCRIPTION: Mounts the FastAPI application using HTTP transport, which is the recommended method for client-server communication. This leverages the latest MCP Streamable HTTP specification for better session management and connection handling.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/docs/advanced/transport.mdx#_snippet_0

LANGUAGE: python
CODE:
```
from fastapi import FastAPI
from fastapi_mcp import FastApiMCP

app = FastAPI()
mcp = FastApiMCP(app)

# Mount using HTTP transport (recommended)
mcp.mount_http()
```

----------------------------------------

TITLE: Advanced Usage: Customizing Exposed Endpoints
DESCRIPTION: Explains how to control which FastAPI endpoints are exposed as MCP tools using Open API operation IDs or tags, covering include/exclude patterns for both.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/README_zh-CN.md#_snippet_4

LANGUAGE: python
CODE:
```
from fastapi import FastAPI
from fastapi_mcp import FastApiMCP

app = FastAPI()

# Include only specific operations
mcp = FastApiMCP(
    app,
    include_operations=["get_user", "create_user"]
)

# Exclude specific operations
mcp = FastApiMCP(
    app,
    exclude_operations=["delete_user"]
)

# Include only operations with specific tags
mcp = FastApiMCP(
    app,
    include_tags=["users", "public"]
)

# Exclude operations with specific tags
mcp = FastApiMCP(
    app,
    exclude_tags=["admin", "internal"]
)

# Combine operation ID and tag filtering (include mode)
mcp = FastApiMCP(
    app,
    include_operations=["user_login"],
    include_tags=["public"]
)

mcp.mount()
```

----------------------------------------

TITLE: mcp-remote Configuration for Fixed Port
DESCRIPTION: JSON configuration for mcp-remote to run on a fixed port, which is crucial for setting up OAuth provider callback URLs correctly.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/docs/advanced/auth.mdx#_snippet_7

LANGUAGE: json
CODE:
```
{
  "mcpServers": {
    "example": {
      "command": "npx",
      "args": [
        "mcp-remote",
        "http://localhost:8000/mcp",
        "8080"
      ]
    }
  }
}
```

----------------------------------------

TITLE: Basic Token Passthrough Configuration
DESCRIPTION: Configures an MCP client to pass an Authorization header to FastAPI endpoints. This is useful for simple token-based authentication without a full OAuth flow. It specifies the command to run and environment variables for the token.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/docs/advanced/auth.mdx#_snippet_0

LANGUAGE: json
CODE:
```
{
  "mcpServers": {
    "remote-example": {
      "command": "npx",
      "args": [
        "mcp-remote",
        "http://localhost:8000/mcp",
        "--header",
        "Authorization:${AUTH_HEADER}"
      ]
    },
    "env": {
      "AUTH_HEADER": "Bearer <your-token>"
    }
  }
}
```

----------------------------------------

TITLE: Tool Naming: Explicit operation_id
DESCRIPTION: Illustrates how to use the `operation_id` parameter in FastAPI route definitions to provide clear and intuitive names for MCP tools, contrasting it with auto-generated IDs.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/README_zh-CN.md#_snippet_2

LANGUAGE: python
CODE:
```
# Auto-generated operation_id (like "read_user_users__user_id__get")
@app.get("/users/{user_id}")
async def read_user(user_id: int):
    return {"user_id": user_id}

# Explicit operation_id (tool will be named "get_user_info")
@app.get("/users/{user_id}", operation_id="get_user_info")
async def read_user(user_id: int):
    return {"user_id": user_id}
```

----------------------------------------

TITLE: FastAPI-MCP with Token Passthrough Dependency
DESCRIPTION: Sets up FastAPI-MCP to require an authorization header by adding a dependency to verify authentication. This ensures that only requests with a valid authorization header are processed.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/docs/advanced/auth.mdx#_snippet_1

LANGUAGE: python
CODE:
```
from fastapi import Depends
from fastapi_mcp import FastApiMCP, AuthConfig

mcp = FastApiMCP(
    app,
    name="Protected MCP",
    auth_config=AuthConfig(
        dependencies=[Depends(verify_auth)],
    ),
)
mcp.mount_http()
```

----------------------------------------

TITLE: Include Specific Tags
DESCRIPTION: Exposes only FastAPI endpoints associated with the specified tags by providing a list of tags to the 'include_tags' argument.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/docs/configurations/customization.mdx#_snippet_4

LANGUAGE: python
CODE:
```
from fastapi import FastAPI
from fastapi_mcp import FastApiMCP

app = FastAPI()

mcp = FastApiMCP(
    app,
    include_tags=["users", "public"]
)
mcp.mount_http()
```

----------------------------------------

TITLE: FastAPI-MCP with OAuth 2 Flow
DESCRIPTION: Configures FastAPI-MCP to support the full OAuth 2 flow, compliant with the MCP Spec. This includes specifying issuer, authorization URLs, client credentials, and an audience for secure authentication.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/docs/advanced/auth.mdx#_snippet_2

LANGUAGE: python
CODE:
```
from fastapi import Depends
from fastapi_mcp import FastApiMCP, AuthConfig

mcp = FastApiMCP(
    app,
    name="MCP With OAuth",
    auth_config=AuthConfig(
        issuer=f"https://auth.example.com/",
        authorize_url=f"https://auth.example.com/authorize",
        oauth_metadata_url=f"https://auth.example.com/.well-known/oauth-authorization-server",
        audience="my-audience",
        client_id="my-client-id",
        client_secret="my-client-secret",
        dependencies=[Depends(verify_auth)],
        setup_proxies=True,
    ),
)

mcp.mount_http()
```

----------------------------------------

TITLE: Mount SSE Transport
DESCRIPTION: Mounts the FastAPI application using SSE (Server-Sent Events) transport. This method is maintained for backwards compatibility with older MCP implementations.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/docs/advanced/transport.mdx#_snippet_1

LANGUAGE: python
CODE:
```
from fastapi import FastAPI
from fastapi_mcp import FastApiMCP

app = FastAPI()
mcp = FastApiMCP(app)

# Mount using SSE transport (backwards compatibility)
mcp.mount_sse()
```

----------------------------------------

TITLE: Combine Operation and Tag Filtering
DESCRIPTION: Combines operation ID filtering with tag filtering to selectively expose FastAPI endpoints. Endpoints matching either criteria will be included.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/docs/configurations/customization.mdx#_snippet_6

LANGUAGE: python
CODE:
```
from fastapi import FastAPI
from fastapi_mcp import FastApiMCP

app = FastAPI()

mcp = FastApiMCP(
    app,
    include_operations=["user_login"],
    include_tags=["public"]
)
mcp.mount_http()
```

----------------------------------------

TITLE: Include Specific Operations
DESCRIPTION: Exposes only the specified FastAPI endpoints by providing a list of operation IDs to the 'include_operations' argument.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/docs/configurations/customization.mdx#_snippet_2

LANGUAGE: python
CODE:
```
from fastapi import FastAPI
from fastapi_mcp import FastApiMCP

app = FastAPI()

mcp = FastApiMCP(
    app,
    include_operations=["get_user", "create_user"]
)
mcp.mount_http()
```

----------------------------------------

TITLE: FastAPI-MCP with Custom OAuth Metadata
DESCRIPTION: Configures FastAPI-MCP to use custom OAuth metadata, providing full control over the OAuth flow. This is useful for integrating with existing MCP-compliant OAuth servers or specialized implementations.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/docs/advanced/auth.mdx#_snippet_4

LANGUAGE: python
CODE:
```
from fastapi import Depends
from fastapi_mcp import FastApiMCP, AuthConfig

mcp = FastApiMCP(
    app,
    name="MCP With Custom OAuth",
    auth_config=AuthConfig(
        # Provide your own complete OAuth metadata
        custom_oauth_metadata={
            "issuer": "https://auth.example.com",
            "authorization_endpoint": "https://auth.example.com/authorize",
            "token_endpoint": "https://auth.example.com/token",
            "registration_endpoint": "https://auth.example.com/register",
            "scopes_supported": ["openid", "profile", "email"],
            "response_types_supported": ["code"],
            "grant_types_supported": ["authorization_code"],
            "token_endpoint_auth_methods_supported": ["none"],
            "code_challenge_methods_supported": ["S256"]
        },

        # Your auth checking dependency
        dependencies=[Depends(verify_auth)],
    ),
)

mcp.mount_http()
```

----------------------------------------

TITLE: Exclude Specific Tags
DESCRIPTION: Excludes FastAPI endpoints associated with the specified tags from being exposed as MCP tools by providing a list of tags to the 'exclude_tags' argument.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/docs/configurations/customization.mdx#_snippet_5

LANGUAGE: python
CODE:
```
from fastapi import FastAPI
from fastapi_mcp import FastApiMCP

app = FastAPI()

mcp = FastApiMCP(
    app,
    exclude_tags=["admin", "internal"]
)
mcp.mount_http()
```

----------------------------------------

TITLE: Exclude Specific Operations
DESCRIPTION: Excludes specific FastAPI endpoints from being exposed as MCP tools by providing a list of operation IDs to the 'exclude_operations' argument.

SOURCE: https://github.com/tadata-org/fastapi_mcp/blob/main/docs/configurations/customization.mdx#_snippet_3

LANGUAGE: python
CODE:
```
from fastapi import FastAPI
from fastapi_mcp import FastApiMCP

app = FastAPI()

mcp = FastApiMCP(
    app,
    exclude_operations=["delete_user"]
)
mcp.mount_http()
```